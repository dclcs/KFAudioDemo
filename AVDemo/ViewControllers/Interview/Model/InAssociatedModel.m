//
//  InAssociatedModel.m
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import "InAssociatedModel.h"

@implementation InAssociatedModel

- (void)func
{
    NSLog(@"print func in %s", __func__);
}

- (void)classFunc
{
    NSLog(@"classFunc : %@", __func__);
}

@end
