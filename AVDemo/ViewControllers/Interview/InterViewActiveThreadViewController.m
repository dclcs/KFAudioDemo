//
//  InterViewActiveThreadViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/24.
//

#import "InterViewActiveThreadViewController.h"

@interface DCLThread : NSThread

@end

@implementation DCLThread

- (NSString *)name {
    return @"DCLThread";
}

- (void)dealloc
{
    NSLog(@"dealloc %@", [NSThread currentThread]);
}

@end

@interface InterViewActiveThreadViewController ()
@property (nonatomic, strong) DCLThread *thread;
@property (assign, nonatomic, getter=isStoped) BOOL stopped;
@end

@implementation InterViewActiveThreadViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.stopped = NO;
    __weak typeof(self) weakSelf = self;
    self.thread = [[DCLThread alloc] initWithBlock:^{
        NSLog(@"%@ ----begin----", [NSThread currentThread]);
        [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
        while (weakSelf && !weakSelf.isStoped) {
            [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
        }
        NSLog(@"%@ ----end----", [NSThread currentThread]);
    }];
    [self.thread start];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(test) onThread:self.thread withObject:nil waitUntilDone:NO];
}

- (void)test
{
    NSLog(@"Run Task on %s %@", __func__, [NSThread currentThread]);

}

- (void)stop
{
    if (!self.thread) {
        return;
    }
    [self performSelector:@selector(stopThread) onThread:self.thread withObject:nil waitUntilDone:YES];
}

- (void)stopThread
{
    self.stopped = YES;
    CFRunLoopStop(CFRunLoopGetCurrent());
    
    self.thread = nil;
}

- (void)dealloc
{
    [self stop];
}

@end
