//
//  InAssociatedModel.h
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface InAssociatedModel : NSObject
@property (nonatomic, strong) NSString *aStr;

@property (atomic, copy) NSString* fistName;
@property (atomic, copy) NSString* thirdName;
@property (atomic, copy) NSString* secondName;


- (void)func;

+ (void)classFunc;
@end

NS_ASSUME_NONNULL_END
