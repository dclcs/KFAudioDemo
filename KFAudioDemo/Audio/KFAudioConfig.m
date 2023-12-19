//
//  KFAudioConfig.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/19.
//

#import "KFAudioConfig.h"

@implementation KFAudioConfig

+ (instancetype)defaultConfig
{
    KFAudioConfig *config = [[self alloc] init];
    config.channels = 2;
    config.sampleRate = 44100;
    config.bitDepth = 16;
    
    return config;
}

@end
