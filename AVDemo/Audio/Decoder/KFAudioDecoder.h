//
//  KFAudioDecoder.h
//  KFAudioDemo
//
//  Created by daicanglan on 2023/12/21.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
NS_ASSUME_NONNULL_BEGIN

@interface KFAudioDecoder : NSObject
@property (nonatomic, copy) void (^sampleBufferOutputCallBack)(CMSampleBufferRef sample);

@property (nonatomic, copy) void (^errorCallBack)(NSError *error);

- (void)decodeSampleBuffer:(CMSampleBufferRef)sampleBuffer; // 解码
@end

NS_ASSUME_NONNULL_END
