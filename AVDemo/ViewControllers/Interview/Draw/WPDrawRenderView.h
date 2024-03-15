//
//  WPDrawRenderView.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/14.
//

#import <UIKit/UIKit.h>
#import "WPDrawTraceInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface WPDrawRenderView : UIView

@property (nonatomic, weak) UIImageView *composeImageView;

- (void)drawWithInfo:(WPDrawTraceInfo *)traceInfo;

- (void)drawWithInfo:(WPDrawTraceInfo *)traceInfo animateDuration:(CGFloat)duration;


@end

NS_ASSUME_NONNULL_END
