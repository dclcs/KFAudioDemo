//
//  WPDrawRenderView.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/14.
//

#import "WPDrawRenderView.h"
#import "WPDrawTraceInfo.h"
#import "WPDrawInfoCenter.h"
@interface WPDrawRenderView ()

@property (nonatomic, strong) WPDrawTraceInfo *lastTrace;
@property (nonatomic, assign) NSInteger lastSeq;

@end

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

- (void)drawWithInfo:(WPDrawTraceInfo *)traceInfo;
{
    [self drawWithInfo:traceInfo animateDuration:0];
}

- (void)drawWithInfo:(WPDrawTraceInfo *)traceInfo animateDuration:(CGFloat)duration
{
    [self drawWithInfo:traceInfo animateDuration:duration traceReserve:NO];
}

- (void)drawWithInfo:(WPDrawTraceInfo *)traceInfo animateDuration:(CGFloat)duration traceReserve:(BOOL)reserve
{
    if (traceInfo.isLineStart) {
        self.lastTrace = nil;
        [WPDrawInfoCenter defaultCenter].points = nil;
    } else {
        if (traceInfo.seq != self.lastSeq)
        {
            self.lastSeq = traceInfo.seq;
            
            if (self.lastTrace.points.count > 0) {
                NSMutableArray<WPDrawPointInfo *> *points = [NSMutableArray new];
                [points addObjectsFromArray:self.lastTrace.points];
                [WPDrawInfoCenter defaultCenter].points = points;
            } else {
                [WPDrawInfoCenter defaultCenter].points = nil;
            }
        } else {
            
        }
    }
    
    WPDrawTraceInfo *realDrawInfo;
    if ([WPDrawInfoCenter defaultCenter].points.count > 0) {
        NSMutableArray<WPDrawPointInfo *> *points = [NSMutableArray arrayWithCapacity:traceInfo.points.count + self.lastTrace.points.count];
        [points addObjectsFromArray:[WPDrawInfoCenter defaultCenter].points];
        [points addObjectsFromArray:traceInfo.points];
        realDrawInfo = [[WPDrawTraceInfo alloc] initWithDrawTraceInfo:traceInfo];
        realDrawInfo.points = points;
    } else {
        realDrawInfo = traceInfo;
    }
    
    if (traceInfo.type == WPDrawTypeDraw) {
        [self drawNormalWithDrawInfo:realDrawInfo lastDrawInfo:traceInfo animateDuration:duration];
    }
}

#define kNearZeroFloat 0.000001
- (void)drawNormalWithDrawInfo:(WPDrawTraceInfo *)realDrawInfo lastDrawInfo:(WPDrawTraceInfo *)lastDrawInfo animateDuration:(CGFloat)duration
{
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.drawsAsynchronously = YES;
    shapeLayer.strokeColor = UIColorFromHex(realDrawInfo.color).CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    
    CGFloat lineWidth = (realDrawInfo.widthV2 > kNearZeroFloat) ? realDrawInfo.widthV2 : realDrawInfo.width;
    lineWidth = lineWidth == 0 ? 5 : lineWidth;
    shapeLayer.lineWidth = lineWidth / 375 * SCREEN_WIDTH;
    UIBezierPath *path = [realDrawInfo generatePathWithCanvasWidth:self.frame.size.width];
    shapeLayer.path = path.CGPath;
    
    if (duration > 0) {
        CABasicAnimation *animation = [shapeLayer animationForKey:@"strokeAnimate"];
        if (animation) {
            [shapeLayer removeAnimationForKey:@"strokeAnimate"];
        }
        
        animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = duration;   // 持续时间
        animation.fromValue = @((realDrawInfo.points.count - lastDrawInfo.points.count)*1.0/realDrawInfo.points.count);
        animation.toValue = @(1);   // 到 1 结束
        // 保持动画结束时的状态
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        // 动画缓慢的进入，中间加速，然后减速的到达目的地。
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [shapeLayer addAnimation:animation forKey:@"strokeAnimate"];
    }
    self.composeImageView.image = [self getImageFromContext];
}


- (UIImage *)getImageFromContext
{
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.composeImageView.layer renderInContext:context];
    UIImage *composeImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return composeImage;
}

@end
