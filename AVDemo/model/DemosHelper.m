//
//  DemosHelper.m
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import "DemosHelper.h"

@implementation DemosHelper


+ (NSDictionary *)readLocalFileWithName:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    return [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
}

+ (NSArray *)parseTitles:(NSDictionary *)dict
{
    NSArray* titles = dict[@"titles"];
    return titles;
}

+ (NSArray<NSArray<DemosModel *> *> *)parseModels:(NSDictionary *)dicts withTitles:(NSArray *)titles
{
    NSArray<DemosModel *> *demos = dicts[@"demos"];
    if (!demos) {
        return nil;
    }
    NSMutableArray<NSMutableArray<DemosModel *>*>* result = [NSMutableArray arrayWithCapacity:titles.count];
    for (int i = 0; i < titles.count; i ++) {
        NSMutableArray *emptyArr = [NSMutableArray new];
        [result addObject:emptyArr];
    }
    
    for (int i = 0; i < demos.count; i ++) {
        DemosModel *demo = [[DemosModel alloc] initWithDictionary:demos[i]];
        [result[demo.type] addObject:demo];
    }
    
    return result;
}


@end
