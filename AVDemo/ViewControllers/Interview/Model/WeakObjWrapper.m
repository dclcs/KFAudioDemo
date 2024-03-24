//
//  WeakObjWrapper.m
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import "WeakObjWrapper.h"

@implementation WeakObjWrapper

- (instancetype)initWithWeakObject:(id)object
{
    if (self = [super init])
    {
        _weakObj = object;
    }
    return self;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
