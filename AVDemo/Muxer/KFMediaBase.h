//
//  KFMediaBase.h
//  KFAudioDemo
//
//  Created by cl d on 2023/12/20.
//
#import <Foundation/Foundation.h>

#ifndef KFMediaBase_h
#define KFMediaBase_h


typedef NS_ENUM (NSInteger, KFMediaType) {
    KFMediaNone = 0,
    KFMediaAudio = 1 << 0,
    KFMediaVideo = 1 << 1,
    KFMediaAV = KFMediaAudio | KFMediaVideo,
};

#endif /* KFMediaBase_h */
