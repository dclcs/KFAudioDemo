//
//  InterviewDrawEnterViewController.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/14.
//

#import "InterviewDrawEnterViewController.h"
#import "WPDrawCanvasView.h"
@interface InterviewDrawEnterViewController ()

@end

@implementation InterviewDrawEnterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WPDrawCanvasView *view = [[WPDrawCanvasView alloc] init];
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
}


@end
