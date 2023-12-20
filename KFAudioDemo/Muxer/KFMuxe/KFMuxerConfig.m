//
//  KFMuxerConfig.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/20.
//

#import "KFMuxerConfig.h"
#import <CoreGraphics/CoreGraphics.h>
@implementation KFMuxerConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        _muxerType = KFMediaAV;
        _preferredTransform = CGAffineTransformIdentity;
    }
    return self;
}


@end
