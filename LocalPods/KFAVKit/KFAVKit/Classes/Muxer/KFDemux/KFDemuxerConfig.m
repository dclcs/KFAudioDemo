//
//  KFDemuxerConfig.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/20.
//

#import "KFDemuxerConfig.h"

@implementation KFDemuxerConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _demuxerType = KFMediaAV;
    }
    return self;
}

@end
