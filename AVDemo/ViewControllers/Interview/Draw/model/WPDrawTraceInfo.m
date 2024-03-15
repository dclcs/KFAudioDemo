//
//  WPTraceInfo.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#import "WPDrawTraceInfo.h"

@implementation WPDrawTraceInfo

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.points = [[NSMutableArray alloc] init];
    }
    return self;
}

//- (instancetype)initWithDrawInfo:(DrawInfo *)pbDrawInfo
//{
//    self = [super init];
//    if (self) {
//        self.color = pbDrawInfo.color;
//        self.width = pbDrawInfo.width;
//        self.widthV2 = pbDrawInfo.widthV2;
//        self.type = pbDrawInfo.drawType;
//        self.seq = pbDrawInfo.seq;
//        self.isLineStart = pbDrawInfo.firstPoint;
//        NSMutableArray<WPDrawPointInfo *> *pointInfos = [NSMutableArray arrayWithCapacity:pbDrawInfo.pointArray.count];
//        for (PointInfo *pbPoint in pbDrawInfo.pointArray) {
//            WPDrawPointInfo *point = [WPDrawPointInfo new];
//            point.x = pbPoint.x;
//            point.y = pbPoint.y;
//            [pointInfos addObject:point];
//        }
//        self.points = pointInfos;
//    }
//    return self;
//}

- (instancetype)initWithDrawTraceInfo:(WPDrawTraceInfo *)oldTraceInfo
{
    self = [super init];
    if (self) {
        self.color = oldTraceInfo.color;
        self.width = oldTraceInfo.width;
        self.widthV2 = oldTraceInfo.widthV2;
        self.type = oldTraceInfo.type;
        self.seq = oldTraceInfo.seq;
        self.isLineStart = oldTraceInfo.isLineStart;
        self.points = oldTraceInfo.points;
    }
    return self;
    
}



- (UIBezierPath *)generatePathWithCanvasWidth:(CGFloat)canvasWidth
{
    BOOL useCurve = YES;
    if (useCurve) {
        return [self curveBezierWithCanvasWidth:canvasWidth];
    } else {
        return [self lineBezierWithCanvasWidth:canvasWidth];
    }
    
}

- (UIBezierPath *)lineBezierWithCanvasWidth:(CGFloat)canvasWidth
{
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    CGPoint startPoint = [self.points.firstObject cgPointWithDrawCanvasWidth:canvasWidth];

    [bezierPath moveToPoint:startPoint];
    
    for (NSInteger i = 1; i < self.points.count; i++) {
        WPDrawPointInfo *iPoint = self.points[i];
        [bezierPath addLineToPoint:[iPoint cgPointWithDrawCanvasWidth:canvasWidth]];
    }
    return bezierPath;
}

- (UIBezierPath *)curveBezierWithCanvasWidth:(CGFloat)canvasWidth
{
    if (canvasWidth <= 0) {
        return nil;
    }
    
//    CGRect drawRect = CGRectMake(0, 0, canvasWidth, canvasWidth/kDrawCanvasRatio);
    UIBezierPath *bezierPath = [UIBezierPath bezierPath]; //[UIBezierPath bezierPathWithRect:drawRect];
    bezierPath.lineJoinStyle = kCGLineJoinRound;
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    CGPoint startPoint = [self.points.firstObject cgPointWithDrawCanvasWidth:canvasWidth];
    CGPoint previousPoint2 = startPoint;
    CGPoint previousPoint1 = startPoint;
    CGPoint currentPoint = startPoint;
    
    [bezierPath moveToPoint: startPoint];
    
    if (self.points.count == 1) {
        return bezierPath;
    }
    for (NSInteger i = 1; i < self.points.count; i++) {
        CGPoint point = [self.points[i] cgPointWithDrawCanvasWidth:canvasWidth];
        previousPoint2 = previousPoint1;
        previousPoint1 = currentPoint;
        currentPoint = point;
        
        CGPoint mid1 = midPoint(previousPoint1, previousPoint2);
        CGPoint mid2 = midPoint(currentPoint, previousPoint1);
        
        [bezierPath moveToPoint:mid1];
        [bezierPath addQuadCurveToPoint:mid2 controlPoint:previousPoint1];
    }
//    [bezierPath addClip];
    
    return bezierPath;
}

CGPoint midPoint(CGPoint p1, CGPoint p2)
{
    return CGPointMake((p1.x + p2.x) * 0.5, (p1.y + p2.y) * 0.5);
}


@end
