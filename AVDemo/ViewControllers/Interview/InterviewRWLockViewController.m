//
//  InterviewRWLockViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import "InterviewRWLockViewController.h"

@interface InterviewRWLockViewController () {
    NSString *_text;
}

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@end

@implementation InterviewRWLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self rwLock];
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
