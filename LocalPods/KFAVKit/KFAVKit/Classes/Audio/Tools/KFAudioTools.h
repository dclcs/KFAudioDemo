//
//  KFAudioTools.h
//  KFAudioDemo
//
//  Created by daicanglan on 2023/12/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFAudioTools : NSObject

+ (NSData *)adtsDataWithChannels:(NSInteger)channels
                      sampleRate:(NSInteger)sampleRate
                   rawDataLength:(NSInteger)rawDataLength;


+ (NSInteger)sampleRateIndex:(NSInteger)frequencyInHz;
@end

NS_ASSUME_NONNULL_END
