//
//  WPDrawPointInfo.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#import <Foundation/Foundation.h>
#import "WPDrawDefines.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WPDrawPointInfo : NSObject

@property (nonatomic, assign) CGFloat x;

@property (nonatomic, assign) CGFloat y;


/**
 绝对位置装变成相对位置 的 实例方法

 @param point 绝对位置
 */
- (instancetype)initWithCGPoint:(CGPoint)point drawCanvasWidth:(CGFloat)canvasWidth;


/**
 绝对位置装变成相对位置 的 类方法
 
 @param point 绝对位置
 */
+ (instancetype)drawPointFromCGPoint:(CGPoint)point drawCanvasWidth:(CGFloat)canvasWidth;


/**
 相对位置转换成绝对位置

 @param canvasWidth 画布宽度
 */
- (CGPoint)cgPointWithDrawCanvasWidth:(CGFloat)canvasWidth;

@end

NS_ASSUME_NONNULL_END
