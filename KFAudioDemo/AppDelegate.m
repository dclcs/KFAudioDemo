//
//  AppDelegate.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/19.
//

#import "AppDelegate.h"
#import "ViewController.h"
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
    return YES;
}

@end
