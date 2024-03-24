//
//  HTTPViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/12.
//

#import "HTTPViewController.h"
#import <DebugTool/DebugTool-Swift.h>
@interface HTTPViewController ()

@end

@implementation HTTPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RequestManager mockRequestWithUrl:@"https://reqres.in/api/users?page=10"];
//    
//    NSURL *url = [[NSURL alloc] initWithString:@"https://reqres.in/api/users?page=10"];
//    NSURLSession *sharedSession = NSURLSession.sharedSession;
//    
//    NSURLSessionTask *task = [sharedSession dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//            
//    }];
//    
//    [task resume];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
