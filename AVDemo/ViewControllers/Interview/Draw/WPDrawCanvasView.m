//
//  WPDrawCanvasView.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/14.
//

#import "WPDrawCanvasView.h"
#import "WPDrawRenderView.h"
#import <Masonry/Masonry.h>

@interface WPDrawCanvasView ()

@property (nonatomic, strong) WPDrawRenderView *renderView;
@property (nonatomic, strong) UIImageView *composeImageView;

@end

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
    
    UIImageView *composeImageView = [[UIImageView alloc] initWithFrame:self.frame];
    [self addSubview:composeImageView];
    [composeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    self.composeImageView = composeImageView;
    
    WPDrawRenderView *renderView = [[WPDrawRenderView alloc] initWithFrame:self.frame];
    renderView.backgroundColor = [UIColor clearColor];
    renderView.composeImageView = composeImageView;
    [composeImageView addSubview:renderView];
    self.renderView = renderView;
    
    [renderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(composeImageView);
    }];
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    if (!CGRectContainsPoint(self.bounds, point)) {
        return;
    }
    
    WPDrawTraceInfo *drawInfo = [WPDrawInfoCenter defaultCenter].currentDraw;
    drawInfo.isLineStart = YES;
    [drawInfo.points addObject:[WPDrawPointInfo drawPointFromCGPoint:point drawCanvasWidth:self.frame.size.width]];
    NSLog(@"touchesBegan point : %@", NSStringFromCGPoint(point));
}


- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"touchesMoved point : %@", NSStringFromCGPoint(point));
    WPDrawTraceInfo *drawInfo = [WPDrawInfoCenter defaultCenter].currentDraw;
    [drawInfo.points addObject:[WPDrawPointInfo drawPointFromCGPoint:point drawCanvasWidth:self.frame.size.width]];
    [self.renderView drawWithInfo:drawInfo];
    if (drawInfo.points.count >= kDrawMaxPointNumPerTrace)
    {
        [[WPDrawInfoCenter defaultCenter] appendCurrentDrawInfo];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self];
    NSLog(@"touchesEnded point : %@", NSStringFromCGPoint(point));
    WPDrawTraceInfo *drawInfo = [WPDrawInfoCenter defaultCenter].currentDraw;
    [drawInfo.points addObject:[WPDrawPointInfo drawPointFromCGPoint:point drawCanvasWidth:self.frame.size.width]];
    [self.renderView drawWithInfo:drawInfo];
    [[WPDrawInfoCenter defaultCenter] appendCurrentDrawInfo];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

@end
