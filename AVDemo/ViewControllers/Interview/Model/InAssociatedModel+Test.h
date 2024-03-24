//
//  InAssociatedModel+Test.h
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import "InAssociatedModel.h"
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface InAssociatedModel (Test)

@property (nonatomic, strong) NSString *testStr;

@property (nonatomic, weak) UIViewController *vc;

- (void)funcOfAssociated;
@end

NS_ASSUME_NONNULL_END
