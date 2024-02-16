//
//  InterviewRWLockViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import "InterviewRWLockViewController.h"
#import "NSMutaleArray+SafeOp.h"
@interface InterviewRWLockViewController () {
    NSString *_text;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;
@property (nonatomic, strong) NSMutableArray *array;
@end

@implementation InterviewRWLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
//    [self rwLock];
//    [self testSafeNSMutableArray];
    [self testBarrierAsync];
}


- (void)testBarrierAsync {
    NSMutableArray *arr = [NSMutableArray array];
    dispatch_queue_t conque1 = dispatch_queue_create("com.helloworld.djx1", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t conque2 = dispatch_queue_create("com.helloworld.djx2", DISPATCH_QUEUE_CONCURRENT);
    for ( int i = 0; i < 100000; i ++) {
        dispatch_async(conque1, ^{
            dispatch_barrier_async(conque2, ^{
                [arr addObject:@(i)];
            });
            dispatch_sync(conque2, ^{
                NSLog(@"i:%d-%@", i, @(arr.count));
            });
        });
    }
}

- (void)testSafeNSMutableArray
{
    dispatch_queue_t conque = dispatch_queue_create("com.interview.cwlock", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
    self.array = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 10000; i ++) {
        dispatch_async(conque, ^{
            [self.array safe_addObject:@(i)];
            NSLog(@"2arrCount:%ld", [self.array safe_count]);
        });
    }
    
    for (int i = 0; i < 10000; i ++) {
        dispatch_async(globalQueue, ^{
            [self.array safe_removeObjectAtIndex:i];
            NSLog(@"2arrCount:%ld", [self.array safe_count]);
        });
    }
    
}

- (void)rwLock {
    self.concurrentQueue = dispatch_queue_create("com.interview.rwlock", DISPATCH_QUEUE_CONCURRENT);
    
    for (int i = 0; i < 10; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.text = [NSString stringWithFormat:@"rwlock write text --- %d", i];
        });
    }
    
    for (int i = 0; i < 50; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"read %@ %@",[self text],[NSThread currentThread]);
        });
    }
    
    for (int i = 10; i < 20; i ++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            self.text = [NSString stringWithFormat:@"rwlock set text --- %d", i];
        });
    }
}

- (void)setText:(NSString *)text
{
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_sync(self.concurrentQueue, ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        strongSelf->_text = text;
        NSLog(@"write %@ %@", text, [NSThread currentThread]);
    });
}


- (NSString *)text
{
    __block NSString *t = nil;
    __weak typeof(self)weakSelf = self;
    dispatch_sync(self.concurrentQueue, ^{
        __strong typeof(weakSelf)strongSelf = weakSelf;
        t = strongSelf->_text;
        sleep(1);
    });
    return t;
}


@end
