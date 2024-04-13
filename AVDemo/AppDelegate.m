//
//  AppDelegate.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/19.
//

#import "AppDelegate.h"
#import "ViewController.h"
//#import <Debugo/Debugo.h>
#import <DebugTool/DebugTool-Swift.h>

@interface TestSSObject : NSObject
@property(nonatomic, copy) dispatch_block_t block;
@property(nonatomic, assign) NSInteger i;

@end

@implementation TestSSObject

-(void)aMethod
{
    __weak typeof(self) weakSelf = self;
    self.block = ^{
        TestSSObject *self = weakSelf;
        self.i += 1;
    };
}

- (void)dealloc
{
    NSLog(@"%@", self);
}

@end

@interface AppDelegate ()
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    ViewController *vc = [[ViewController alloc] init];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navVC;
    [self.window makeKeyAndVisible];
//    [Debugo fireWithConfiguration:^(DGConfiguration * _Nonnull configuration) {
//        // 配置 configuration，定制你的需求
//    }];
    
    [DebugTool fireWithConfiguration];
    
    observerRunLoop();
    TestSSObject *object = [[TestSSObject alloc] init];
    [object aMethod];
    
    return YES;
}
void observerRunLoop() {
    CFRunLoopObserverRef observer2 = CFRunLoopObserverCreateWithHandler(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"run loop entry");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"run loop before timers");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"run loop before sources");
                break;
            case  kCFRunLoopBeforeWaiting:
                NSLog(@"run loop before watiting");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"run loop after waiting");
                break;
            case kCFRunLoopExit:
                NSLog(@"run loop exit");
                break;
            default:
                NSLog(@"in default");
                break;
        }
    });
    CFRunLoopAddObserver([[NSRunLoop currentRunLoop] getCFRunLoop], observer2, kCFRunLoopCommonModes);
}

@end
