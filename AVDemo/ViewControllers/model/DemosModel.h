//
//  DemosModel.h
//  AVDemo
//
//  Created by cl d on 2024/2/14.
//

#import <Foundation/Foundation.h>

/**
 * 命名规则
 *  DemoTypeXXXX
 */
typedef NS_OPTIONS(NSUInteger, DemoType) {
    DemoTypeAV = 1 << 0,
    DemoTypeToy = 1 << 1,
    DemoTypeInterview = 1 << 2,
};


NS_ASSUME_NONNULL_BEGIN

/**
 * 最后tableView使用的是一个二维数组
 * ```
 *  section : self.models.count
 *  rows : self.models[sec].count
 * ```
 */
@interface DemosModel : NSObject

//问： 为什么这里要用strong呢？
@property (nonatomic, strong) NSString *title; // 当前条目的名称

@property (nonatomic, strong) NSString *target; // 跳转vc的名字

@property (nonatomic, assign) DemoType type;


- (instancetype)initWithTitle:(NSString *)title target:(NSString *)target type:(DemoType)type;

@end

NS_ASSUME_NONNULL_END
