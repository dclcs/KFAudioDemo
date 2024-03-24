//
//  WeakObjWrapper.h
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeakObjWrapper : NSObject

@property (nonatomic, weak) id weakObj;
- (instancetype)initWithWeakObject:(id)object;
@end

NS_ASSUME_NONNULL_END
