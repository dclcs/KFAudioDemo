//
//  InterviewResidentThreadViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import "InterviewResidentThreadViewController.h"

@interface InterviewResidentThreadViewController ()

@end

@implementation InterviewResidentThreadViewController

- (NSThread *)residentThread {
    static NSThread *thread = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        thread = [[NSThread alloc] initWithTarget:self selector:@selector(asyncTask) object:nil];
        [thread setName:@"resident-thread"];
        
        [thread start];
    });
    return thread;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    [self residentThread];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    BOOL canCancel = YES;
    if (canCancel) {
        [[self residentThread] cancel];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    SEL selector = NSSelectorFromString(@"runAnyTime");
    
    [self performSelector:selector onThread:[self residentThread] withObject:nil waitUntilDone:NO];
}


- (void)asyncTask {
    NSLog(@"resident Task. Current Thread: %@", [NSThread currentThread]);
    
    NSRunLoop *runloop = [NSRunLoop currentRunLoop];
    NSLog(@"resident Task. Runloop : %@", runloop);
    
    NSPort *port = [NSMachPort port];
    [runloop addPort:port forMode:NSRunLoopCommonModes];
    NSLog(@"resident Task. Runloop Added port : %@", runloop);
    
    [runloop run];
    NSLog(@"resident Task. End run");

}

- (void)runAnyTime {
    
    NSLog(@"resident Task. Current Thread: %@", [NSThread currentThread]);
}

@end
