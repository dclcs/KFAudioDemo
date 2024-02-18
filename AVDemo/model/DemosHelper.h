//
//  DemosHelper.h
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import <Foundation/Foundation.h>
#import "DemosModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface DemosHelper : NSObject

+ (NSDictionary *)readLocalFileWithName:(NSString *)name;

+ (NSArray *)parseTitles:(NSDictionary *)dict;

+ (NSArray<NSArray<DemosModel*>*> *)parseModels:(NSDictionary *)dicts withTitles:(NSArray *)titles;

@end

NS_ASSUME_NONNULL_END
