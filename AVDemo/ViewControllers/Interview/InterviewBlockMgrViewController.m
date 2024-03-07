//
//  InterviewBlockMgrViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/17.
//

#import "InterviewBlockMgrViewController.h"
#import "BlockMonitorMgr.h"
@interface InterviewBlockMgrViewController ()

@end

@implementation InterviewBlockMgrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[BlockMonitorMgr shareInstance] start];
}


@end
