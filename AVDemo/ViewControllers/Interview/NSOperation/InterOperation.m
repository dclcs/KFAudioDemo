//
//  InterOperation.m
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import "InterOperation.h"
#import <pthread/pthread.h>
#import <mach/mach.h>


@interface InterOperation () {
    NSString *_threadName;
    NSString *_url;
    BOOL excuting;
    BOOL finished;
}

@end


@implementation InterOperation

- (id)initWithUrl:(NSString *)url name:(NSString *)name
{
    self = [super init];
    if (self) {
        if (name != nil) _threadName = name;
        _url = url;
        excuting = NO;
        finished = NO;
    }
    
    return self;
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return excuting;
}

- (BOOL)isFinished {
    return finished;
}

- (void)start {
    [NSThread currentThread].name = _threadName;
    currentThreadInfo(@"start");
    
    if ([self isCancelled]) {
        
        [self willChangeValueForKey:@"isFinished"];
        finished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isFinished"];
    
    excuting = YES;
    
    [NSData dataWithContentsOfURL:[NSURL URLWithString:_url]];
    
    [self completeOpertaion];
    
    [self didChangeValueForKey:@"isExecuting"];
}

- (void)completeOpertaion {
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    excuting = NO;
    finished = YES;
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
}

- (void)dealloc
{
    dumpThreads(@"dealloc");
}

@end



static inline void currentThreadInfo( NSString* _Nullable str)
{
    if (str)
        NSLog(@"---------%@----------",str);

    NSThread* thread = [NSThread currentThread];
    mach_port_t machTID = pthread_mach_thread_np(pthread_self());
    NSLog(@"current thread num: %x thread name:%@", machTID,thread.name);
    
    if (str)
        NSLog(@"-------------------");
}

static inline void dumpThreads(NSString* str) {
    
    NSLog(@"---------%@----------",str);
    currentThreadInfo(nil);
    char name[256];
    thread_act_array_t threads = NULL;
    mach_msg_type_number_t thread_count = 0;
    task_threads(mach_task_self(), &threads, &thread_count);
    for (mach_msg_type_number_t i = 0; i < thread_count; i++) {
        thread_t thread = threads[i];
        pthread_t pthread = pthread_from_mach_thread_np(thread);
        pthread_getname_np(pthread, name, sizeof name);
        NSLog(@"mach thread %x: getname: %s", pthread_mach_thread_np(pthread), name);
    }
    NSLog(@"-------------------");
}
