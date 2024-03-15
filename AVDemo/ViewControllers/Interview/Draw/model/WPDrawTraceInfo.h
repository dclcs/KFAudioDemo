//
//  WPTraceInfo.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#import <Foundation/Foundation.h>
#import "WPDrawPointInfo.h"
#import "WPDrawDefines.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WPDrawTraceInfo : NSObject

@property (nonatomic, assign) WPDrawType type;
@property (nonatomic, strong) NSMutableArray<WPDrawPointInfo *> *points;
@property (nonatomic, assign) NSInteger color;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, assign) CGFloat widthV2;

@property (nonatomic, assign) NSInteger seq;
@property (nonatomic, assign) BOOL isLineStart;

- (UIBezierPath *)generatePathWithCanvasWidth:(CGFloat)canvasWidth;

//- (instancetype)initWithDrawInfo:(DrawInfo *)pbDrawInfo;


- (instancetype)initWithDrawTraceInfo:(WPDrawTraceInfo *)oldTraceInfo;

@end

NS_ASSUME_NONNULL_END
