//
//  InterviewCOWViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/16.
//

#import "InterviewCOWViewController.h"

@interface InterviewCOWViewController ()

@property (nonatomic, strong) NSString *strStrong;
@property (nonatomic, copy) NSMutableString *strCopy;


@end

@implementation InterviewCOWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    NSMutableString *mutableStr = [[NSMutableString alloc] initWithString:@"123123123"];
    self.strStrong = mutableStr;
    NSLog(@"strStrong = %@", self.strStrong);
    [mutableStr appendString:@"xxxxx"];
    NSLog(@"strStrong = %@", self.strStrong); // 这里修改mutable appendString 也同样修改了strStrong
    
    self.strCopy = mutableStr;
    NSLog(@"strCopy = %@", self.strCopy);
    [self.strCopy appendString:@"tttttt"];
    
}


@end
