//
//  WPDrawCanvasView.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/14.
//

#import "WPDrawCanvasView.h"

@implementation WPDrawCanvasView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }
    
    NSLog(@"touchesBegan point : %@", NSStringFromCGPoint(point));
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"touchesMoved point : %@", NSStringFromCGPoint(point));
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"touchesEnded point : %@", NSStringFromCGPoint(point));
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
