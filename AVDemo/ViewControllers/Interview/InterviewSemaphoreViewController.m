//
//  InterviewSemaphoreViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/14.
//

#import "InterviewSemaphoreViewController.h"

@interface InterviewSemaphoreViewController ()

@end

@implementation InterviewSemaphoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    [self asyncTaskTransferTosync];
    
}


- (void)asyncTaskTransferTosync {
    // Task 1 ~ Task 2
    // 1-2 异步任务，但是必须1 执行完2执行
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t concurrentQueue = dispatch_queue_create("com.avdemo.interview.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(concurrentQueue, ^{
        NSLog(@"[%@]异步任务 1", [NSThread currentThread]);
        dispatch_semaphore_signal(sema);
    });

    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"[%@]异步任务 2", [NSThread currentThread]);
        dispatch_semaphore_signal(sema);
    });
}

// 限制最大并发数
- (void)maxConcurrentNums {
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_semaphore_t sema = dispatch_semaphore_create(2);
    for (int i = 0; i < 10; i ++) {
        dispatch_async(concurrentQueue, ^{
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
            
            NSLog(@"执行异步操作在%@线程", [NSThread currentThread]);
            dispatch_semaphore_signal(sema);
        });
    }
}


@end
