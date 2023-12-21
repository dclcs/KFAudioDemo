//
//  KFMuxerConfig.h
//  KFAudioDemo
//
//  Created by cl d on 2023/12/20.
//

#import <Foundation/Foundation.h>
#import "KFMediaBase.h"
NS_ASSUME_NONNULL_BEGIN

@interface KFMuxerConfig : NSObject
@property (nonatomic, strong) NSURL *outputURL; // 封装文件的输出地址
@property (nonatomic, assign) KFMediaType muxerType;
@property (nonatomic, assign) CGAffineTransform preferredTransform;// 图像的变换信息。比如：视频图像旋转。
@end

NS_ASSUME_NONNULL_END
