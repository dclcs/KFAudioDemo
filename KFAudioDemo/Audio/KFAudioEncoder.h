//
//  KFAudioEncoder.h
//  KFAudioDemo
//
//  Created by daicanglan on 2023/12/20.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFAudioEncoder : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithAudioBitrate:(NSInteger)audioBitrate;

@property (nonatomic, assign, readonly) NSInteger audioBitrate;
@property (nonatomic, copy) void (^sampleBufferOutputCallBack)(CMSampleBufferRef sample); // 编码数据回调
@property (nonatomic, copy) void (^errorCallBack)(NSError *error);

- (void)encodeSampleBuffer:(CMSampleBufferRef)buffer; // 编码
@end

NS_ASSUME_NONNULL_END
