//
//  NSMutaleArray.m
//  AVDemo
//
//  Created by cl d on 2024/2/16.
//

#import "NSMutaleArray+SafeOp.h"

static void * kSafeMutableArrayQueueSpecific = (void*)"kSafeMutableArrayQueueSpecific";

static inline void safe_op_arr_write(dispatch_queue_t queue, void(^block)(void))
{
    dispatch_barrier_sync(queue, ^{
        block();
    });
}


static inline id safe_op_arr_read(dispatch_queue_t queue, id (^block)(void))
{
    __block id data = nil;
    dispatch_sync(queue, ^{
        data = block();
    });
    return data;
}


@implementation NSMutableArray (SafeOp)

- (dispatch_queue_t)operationQueue {
    static dispatch_queue_t queue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        queue = dispatch_queue_create("com.toy.rwlock", DISPATCH_QUEUE_CONCURRENT);
        dispatch_queue_set_specific(queue, kSafeMutableArrayQueueSpecific, kSafeMutableArrayQueueSpecific, NULL);
    });
    return queue;
}

- (NSInteger)safe_count
{
    NSNumber *count = safe_op_arr_read(self.operationQueue, ^id{
        return @(self.count);
    });
    return [count integerValue];
}

- (id)safe_objectAtIndex:(NSUInteger)index
{
    id object = safe_op_arr_read(self.operationQueue, ^id{
        if (index >= self.count) {
            return NULL;
        }
        return [self objectAtIndex:index];
    });
    
    return object;
}

- (NSUInteger)safe_indexOfObject:(id)anObject
{
    NSNumber *index = safe_op_arr_read(self.operationQueue, ^id{
        NSInteger index = [self indexOfObject:anObject];
        return @(index);
    });
    
    return [index integerValue];
}

- (void)safe_addObject:(id)object
{
    if (!object) {
        return;
    }
    
    safe_op_arr_write(self.operationQueue, ^{
        [self addObject:object];
    });
}

- (void)safe_removeLastObject
{
    safe_op_arr_write(self.operationQueue, ^{
        [self removeLastObject];
    });
}

- (void)safe_removeObjectAtIndex:(NSUInteger)index
{
    safe_op_arr_write(self.operationQueue, ^{
        if (index < self.count) {
            [self removeObjectAtIndex:index];
        }
    });
}

- (void)safe_removeObject:(id)object
{
    safe_op_arr_write(self.operationQueue, ^{
        if (object) {
            [self removeObject:object];
        }
    });
}

- (void)safe_removeAllObjects
{
    safe_op_arr_write(self.operationQueue, ^{
        [self removeAllObjects];
    });
}


- (void)safe_insertObject:(nonnull id)object atIndex:(NSUInteger)index
{
    safe_op_arr_write(self.operationQueue, ^{
        if (object) {
            [self insertObject:object atIndex:index];
        }
    });
}

@end
