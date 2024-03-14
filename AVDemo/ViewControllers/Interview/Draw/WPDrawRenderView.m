//
//  WPDrawRenderView.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/14.
//

#import "WPDrawRenderView.h"

@implementation WPDrawRenderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}

+ (Class)layerClass
{
    return [CAShapeLayer class];
}

- (void)drawWithInfo
{
    [self drawWithInfo:0];
}

- (void)drawWithInfo:(CGFloat)duration
{
    
}

- (void)drawWithInfo:(CGFloat)duration traceReserve:(BOOL)reserve
{
    
}



@end
