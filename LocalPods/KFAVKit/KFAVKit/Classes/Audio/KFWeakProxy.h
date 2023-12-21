//
//  KFWeakProxy.h
//  KFAudioDemo
//
//  Created by daicanglan on 2023/12/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KFWeakProxy : NSProxy
- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@property (nonatomic, weak, readonly) id target;
@end

NS_ASSUME_NONNULL_END
