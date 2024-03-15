//
//  WPDrawInfoCenter.h
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#import <Foundation/Foundation.h>
#import "WPDrawTraceInfo.h"
NS_ASSUME_NONNULL_BEGIN

@interface WPDrawInfoCenter : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<WPDrawTraceInfo *> *drawInfoBuffer;

+ (instancetype)defaultCenter;

@property (nonatomic, strong, readwrite) WPDrawTraceInfo *currentDraw;

- (void)appendCurrentDrawInfo;

@property (nonatomic, strong) NSArray<WPDrawPointInfo *> *points;

@end

NS_ASSUME_NONNULL_END
