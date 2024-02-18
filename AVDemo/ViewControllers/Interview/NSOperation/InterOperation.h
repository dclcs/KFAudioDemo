//
//  InterOperation.h
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

static inline void currentThreadInfo(NSString* str);
static inline void dumpThreads(NSString* str);

@interface InterOperation : NSOperation

- (id)initWithUrl:(NSString *)url name:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
