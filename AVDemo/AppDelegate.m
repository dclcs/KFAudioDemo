//
//  AppDelegate.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/19.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import <Debugo/Debugo.h>
#import <DebugTool/DebugTool-Swift.h>

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
    
    return YES;
}

@end
