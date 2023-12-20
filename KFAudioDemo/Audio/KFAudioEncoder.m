//
//  KFAudioEncoder.m
//  KFAudioDemo
//
//  Created by daicanglan on 2023/12/20.
//

#import "KFAudioEncoder.h"
#import <AudioToolbox/AudioToolbox.h>


@interface KFAudioEncoder() {
    char *_leftBuffer; // 待编码缓冲区
    NSInteger _leftLength; // 待编码缓冲区长度、动态
    char *_aacBuffer; // 编码缓冲区
    NSInteger _bufferLength; // 每次发送给编码器的数据长度
}
@property (nonatomic, assign) AudioConverterRef audioEncoderInstance; // 音频编码实例
@property (nonatomic, assign) CMFormatDescriptionRef aacFormat; // 音频编码参数
@property (nonatomic, assign ,readwrite) NSInteger audiBitrate; // 音频编码码率
@property (nonatomic, assign) BOOL isError;
@property (nonatomic, strong) dispatch_queue_t encoderQueue;
@end

@implementation KFAudioEncoder

- (instancetype)initWithAudioBitrate:(NSInteger)audioBitrate
{
    self = [super init];
    if (self) {
        _audiBitrate = audioBitrate;
        _encoderQueue = dispatch_queue_create("com.KFAudioDemo.audioEncoder", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


- (void)dealloc
{
    // 清理编码器
    if (_audioEncoderInstance) {
        AudioConverterDispose(_audioEncoderInstance);
        _audioEncoderInstance = nil;
    }
    
    if (_aacFormat) {
        CFRelease(_aacFormat);
        _aacFormat = NULL;
    }
    
    // 清理缓冲区
    if (_aacBuffer) {
        free(_aacBuffer);
        _aacBuffer = NULL;
    }
    
    if (_leftBuffer) {
        free(_leftBuffer);
        _leftBuffer = NULL;
    }
}

- (void)encodeSampleBuffer:(CMSampleBufferRef)buffer
{
    if (!buffer || !CMSampleBufferGetDataBuffer(buffer) || self.isError) {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    CFRetain(buffer);
    dispatch_async(_encoderQueue, ^{
        [weakSelf encodeSampleBufferInternal:buffer];
        CFRelease(buffer);
    });
}

- (void)encodeSampleBufferInternal:(CMSampleBufferRef)buffer
{
    // 1. 从输入数据中获取音频格式信息
    CMAudioFormatDescriptionRef audioFormatRef = CMSampleBufferGetFormatDescription(buffer);
    if (!audioFormatRef) {
        return;
    }
    
    // 获取音频参数，AudioStreamBasicDescription包含音频的数据格式、声道数、位深、采样率等
    AudioStreamBasicDescription audioFormat = *CMAudioFormatDescriptionGetStreamBasicDescription(audioFormatRef);
    
    // 2、根据音频参数创建编码器实例
    NSError *error = nil;
    if (!_audioEncoderInstance) {
        [self setupAudioEncoderInstanceWithInputAudioFormat:audioFormat error:&error];
        if (error) {
            [self callBackError:error];
            return;
        }
        
        if (!_audioEncoderInstance) {
            return;
        }
    }
    
    // 3、获取输入数据中的PCM数据
    CMBlockBufferRef blockBuffer = CMSampleBufferGetDataBuffer(buffer);
    size_t audioLength;
    char *dataPointer = NULL;
    CMBlockBufferGetDataPointer(blockBuffer, 0, NULL, &audioLength, &dataPointer);
    if (audioLength == 0 || !dataPointer) {
        return;
    }
    
    // 4、处理音频时间戳信息
    CMSampleTimingInfo timingInfo = { CMTimeMake(CMSampleBufferGetNumSamples(buffer), audioFormat.mSampleRate), CMSampleBufferGetPresentationTimeStamp(buffer), kCMTimeInvalid};
    
    // 5、基于编码缓冲区对PCM数据进行编码
    if (_leftLength + audioLength >= _bufferLength) {
        // 当待编码缓冲区遗留数据加上新来的数据长度(_leftLength + audioLength)大于每次给编码器的数据长度(_bufferLength)时，则进行循环编码，每次送给编码器长度为 _bufferLength 的数据量。
        // 拷贝待编码的数据到缓冲区 totalBuffer
        NSInteger totalSize = _leftLength + audioLength; // 当前数据的总长度
        NSInteger encoderCount = totalSize / _bufferLength; // 计算发给编码器数据的总长度
        char *totalBuffer = malloc(totalSize);
        char *p = totalBuffer;
        memset(totalBuffer, 0, (int)totalSize);
        memcpy(totalBuffer, _leftBuffer, _leftLength);
        memcpy(totalBuffer + _leftLength, dataPointer, audioLength);
        
        // 分encodeCount次发送给编码器
        for (NSInteger index = 0; index < encoderCount; index ++) {
            [self encodeBuffer:p timing:timingInfo];
            p += _bufferLength;
        }
        
        // 处理不够 _bufferLength 长度的剩余数据，先存在 _leftBuffer 中，等下次凑足一次编码需要的数据再编码。
        _leftLength = totalSize % _bufferLength;
        memset(_leftBuffer, 0, _bufferLength);
        memcpy(_leftBuffer, totalBuffer + (totalSize - _leftLength), _leftLength);
        
        // free
        free(totalBuffer);
    } else {
        // 否则 现存到待编码缓冲区，等下一次数据够了在发送给编码器
        memcpy(_leftBuffer + _leftLength, dataPointer, audioLength);
        _leftLength = _leftLength + audioLength;
    }
}


- (void)encodeBuffer:(char *)buffer 
              timing:(CMSampleTimingInfo)timing
{
    // 1、创建编码接口对应的待编码缓冲区AudioBufferList，填充待编码数据
    AudioBuffer inBuffer;
    AudioStreamBasicDescription audioFormat = *CMAudioFormatDescriptionGetStreamBasicDescription(_aacFormat);
    inBuffer.mNumberChannels = (UInt32)audioFormat.mChannelsPerFrame;
    inBuffer.mData = buffer;
    inBuffer.mDataByteSize = (UInt32)_bufferLength;
    AudioBufferList inBufferList;
    inBufferList.mNumberBuffers = 1;
    inBufferList.mBuffers[0] = inBuffer;
    
    // 2、创建编码输出缓冲区 AudioBufferList 接受编码后的数据
    AudioBufferList outBufferList;
    outBufferList.mNumberBuffers = 1;
    outBufferList.mBuffers[0].mNumberChannels = inBuffer.mNumberChannels;
    outBufferList.mBuffers[0].mDataByteSize = inBuffer.mDataByteSize;
    outBufferList.mBuffers[0].mData = _aacBuffer;
    
    // 3、编码
    UInt32 outputDataPacketSize = 1; // 每次编码 1 个包。1 个包有 1024 个帧，这个对应创建编码器实例时设置的 mFramesPerPacket。
    // 需要在回调方法 inputDataProcess 中将待编码的数据拷贝到编码器的缓冲区的对应位置。这里把我们自己创建的待编码缓冲区 AudioBufferList 作为 inInputDataProcUserData 传入，在回调方法中直接拷贝它。
    OSStatus status = AudioConverterFillComplexBuffer(_audioEncoderInstance, inputDataProcess, &inBufferList, &outputDataPacketSize, &outBufferList, NULL);
    if (status != noErr) {
        [self errorWithCode:status userInfo:nil];
        return;
    }
    
    // 4、获取编码后的ACC数据进行封装
    size_t aacEncoderSize = outBufferList.mBuffers[0].mDataByteSize;
    char *blockBufferDataPoter = malloc(aacEncoderSize);
    memcpy(blockBufferDataPoter, _aacBuffer, aacEncoderSize);
    // 编码数据封装到CMBlockBufferRef中
    CMBlockBufferRef blockBuffer = NULL;
    status = CMBlockBufferCreateWithMemoryBlock(kCFAllocatorDefault, blockBufferDataPoter, aacEncoderSize, NULL, NULL, 0, aacEncoderSize, 0, &blockBuffer);
    if (status != kCMBlockBufferNoErr) {
        return;
    }
    
    // 编码数据CMBlockBuffer 在封装到CMSampleBuffer中
    CMSampleBufferRef sampleBuffer = NULL;
    const size_t sampleSizeArray[] = {aacEncoderSize};
    status = CMSampleBufferCreateReady(kCFAllocatorDefault, blockBuffer, _aacFormat, 1, 1, &timing, 1, sampleSizeArray, &sampleBuffer);
    CFRelease(blockBuffer);
    
    // 5、回调编码数据
    if (self.sampleBufferOutputCallBack) {
        self.sampleBufferOutputCallBack(sampleBuffer);
    }
    
    if (sampleBuffer) {
        CFRelease(sampleBuffer);
    }
}

/// 创建编码器实例
/// - Parameters:
///   - inputFormat: 输入音频的格式
///   - error: 错误返回
- (void)setupAudioEncoderInstanceWithInputAudioFormat:(AudioStreamBasicDescription)inputFormat 
                                                error:(NSError **)error
{
    // 1. 设置音频编码器输出参数。其中一些参数与输入的音频参数一致
    AudioStreamBasicDescription outputFormat = {0};
    outputFormat.mSampleRate = inputFormat.mSampleRate;
    outputFormat.mFormatID = kAudioFormatMPEG4AAC;
    outputFormat.mChannelsPerFrame = (UInt32)inputFormat.mChannelsPerFrame;
    outputFormat.mFramesPerPacket = 1024;
    outputFormat.mBytesPerPacket = 0;
    outputFormat.mBytesPerFrame = 0;
    outputFormat.mBitsPerChannel = 0;
    
    // 2、基于音频输入和输出参数创建音频编码器
    OSStatus result = AudioConverterNew(&inputFormat, &outputFormat, &_audioEncoderInstance);
    if (result != noErr) {
        *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:result userInfo:nil];
        return;
    }
    
    // 3、设置编码器参数，音频编码码率
    UInt32 outputBitrate = (UInt32)self.audiBitrate;
    result = AudioConverterSetProperty(_audioEncoderInstance, kAudioConverterEncodeBitRate, sizeof(outputBitrate), &outputBitrate);
    if (result != noErr) {
        *error = [self errorWithCode:result userInfo:nil];
        return;
    }

    // 4、创建编码格式信息
    result = CMAudioFormatDescriptionCreate(kCFAllocatorDefault, &outputFormat, 0, NULL, 0, NULL, nil, &_aacFormat);
    if (result != noErr) {
        *error = [self errorWithCode:result userInfo:nil];
        return;
    }
    
    
    // 5、设置每次发送给编码器的数据长度
    // 这里设置每次送给编码器的数据长度为：1024 * 2(16 bit 采样深度) * 声道数量，这个长度为什么要这么计算呢？
    // 因为我们每次调用 AudioConverterFillComplexBuffer 编码时，是送进去一个包（packet），而对于 AAC 来讲，mFramesPerPacket 需要是 1024，即 1 个 packet 有 1024 帧，而每个音频帧的大小是：2(16 bit 采样深度) * 声道数量。
    _bufferLength = 1024 * 2 * inputFormat.mChannelsPerFrame;
    
    // 6、初始化待编码缓冲区和编码缓冲区
    if (!_leftBuffer) {
        _leftBuffer = malloc(_bufferLength);
    }
    
    if (!_aacBuffer) {
        _aacBuffer = malloc(_bufferLength);
    }
}



static OSStatus inputDataProcess(AudioConverterRef inConverter,
                                 UInt32 *ioNumberDataPackets,
                                 AudioBufferList *ioData,
                                 AudioStreamPacketDescription **outDataPacketDescription,
                                 void *inUserData) {
    // 将待编码的数据拷贝到编码器的缓冲区的对应位置进行编码。
    AudioBufferList bufferList = *(AudioBufferList *) inUserData;
    ioData->mBuffers[0].mNumberChannels = 1;
    ioData->mBuffers[0].mData = bufferList.mBuffers[0].mData;
    ioData->mBuffers[0].mDataByteSize = bufferList.mBuffers[0].mDataByteSize;
    
    return noErr;
}

#pragma mark - 处理错误
- (void)callBackError:(NSError *)error
{
    self.isError = YES;
    if (error && self.errorCallBack) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.errorCallBack(error);
        });
    }
}

- (NSError *)errorWithCode:(NSInteger)code
                  userInfo:(NSDictionary<NSErrorUserInfoKey, id> *)userInfo
{
    return [NSError errorWithDomain:NSStringFromClass(self.class) code:code userInfo:userInfo];
}


@end
