//
//  WPDrawPointInfo.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#import "WPDrawPointInfo.h"

#define kScaleRatio 1000

@implementation WPDrawPointInfo

- (instancetype)initWithCGPoint:(CGPoint)point drawCanvasWidth:(CGFloat)canvasWidth
{
    self = [super init];
    if (self) {
        if (canvasWidth > 0) {
            self.x = (point.x / canvasWidth) * kScaleRatio;
//            self.x = MIN(self.x, 1000);
            CGFloat canvasHeight = canvasWidth / kDrawCanvasRatio;
            self.y = (point.y / canvasHeight) * kScaleRatio;
//            self.y = MIN(self.y, 1000);
        } else {
            //异常情况
            self.x = point.x;
            self.y = point.y;
        }

    }
    return self;
}


+ (instancetype)drawPointFromCGPoint:(CGPoint)point drawCanvasWidth:(CGFloat)canvasWidth
{
    WPDrawPointInfo *newPoint = [[WPDrawPointInfo alloc] initWithCGPoint:point drawCanvasWidth:canvasWidth];
    return newPoint;
}


- (CGPoint)cgPointWithDrawCanvasWidth:(CGFloat)canvasWidth
{
    if (canvasWidth > 0) {
//        self.x = MIN(self.x, 1000);
//        self.y = MIN(self.y, 1000);

        CGPoint resultPoint;
        resultPoint.x = self.x * canvasWidth / kScaleRatio;
        CGFloat canvasHeight = canvasWidth / kDrawCanvasRatio;
        resultPoint.y = self.y * canvasHeight / kScaleRatio;
        return resultPoint;
    } else {
        return CGPointMake(self.x, self.y);
    }
}

@end
