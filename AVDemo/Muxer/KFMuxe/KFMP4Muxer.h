//
//  KFMP4Muxer.h
//  KFAudioDemo
//
//  Created by cl d on 2023/12/20.
//

#import <Foundation/Foundation.h>
#import <CoreMedia/CoreMedia.h>
#import "KFMuxerConfig.h"
NS_ASSUME_NONNULL_BEGIN

@interface KFMP4Muxer : NSObject

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithConfig:(KFMuxerConfig *)config;

@property (nonatomic, strong, readonly) KFMuxerConfig *config;
@property (nonatomic, copy) void (^errorCallBack)(NSError *error);

- (void)startWriting;
- (void)cancelWriting;
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer;
- (void)stopWriting:(void(^)(BOOL success, NSError *error))completeHandler;

@end

NS_ASSUME_NONNULL_END
