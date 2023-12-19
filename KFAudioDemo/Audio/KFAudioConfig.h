//
//  KFAudioConfig.h
//  KFAudioDemo
//
//  Created by cl d on 2023/12/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFAudioConfig : NSObject

+ (instancetype)defaultConfig;

@property(nonatomic, assign)NSUInteger channels; // 声道数 2
@property(nonatomic, assign)NSUInteger sampleRate; // 采样率 441000
@property(nonatomic, assign)NSUInteger bitDepth; // 位深 16
@end

NS_ASSUME_NONNULL_END
