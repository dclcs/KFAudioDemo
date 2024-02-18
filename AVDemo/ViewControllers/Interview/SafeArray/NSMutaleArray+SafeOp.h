//
//  NSMutaleArray.h
//  AVDemo
//
//  Created by cl d on 2024/2/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (SafeOp)

- (NSInteger) safe_count;

- (id)safe_objectAtIndex:(NSUInteger)index;

- (NSUInteger)safe_indexOfObject:(id)anObject;

- (void)safe_addObject:(id)object;

- (void)safe_insertObject:(id)object atIndex:(NSUInteger)index;

- (void)safe_removeLastObject;

- (void)safe_removeObjectAtIndex:(NSUInteger)index;

- (void)safe_removeAllObjects;

- (void)safe_removeObject:(id)object;

@end

NS_ASSUME_NONNULL_END
