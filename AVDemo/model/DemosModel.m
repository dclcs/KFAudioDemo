//
//  DemosModel.m
//  AVDemo
//
//  Created by cl d on 2024/2/14.
//

#import "DemosModel.h"

@implementation DemosModel


- (instancetype)initWithDictionary:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.target = dictionary[@"target"];
        self.title = dictionary[@"title"];
        self.type = ((NSString *)dictionary[@"type"]).intValue;
    }
    return self;
}

@end
