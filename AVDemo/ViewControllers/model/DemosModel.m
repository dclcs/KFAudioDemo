//
//  DemosModel.m
//  AVDemo
//
//  Created by cl d on 2024/2/14.
//

#import "DemosModel.h"

@implementation DemosModel

- (instancetype)initWithTitle:(NSString *)title target:(NSString *)target type:(DemoType)type
{
    if (self = [super init]) {
        _title = title;
        _target = target;
        _type = type;
    }
    
    return self;
}

@end
