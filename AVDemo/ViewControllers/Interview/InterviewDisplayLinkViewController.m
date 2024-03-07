//
//  InterviewDisplayLinkViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/16.
//

#import "InterviewDisplayLinkViewController.h"

@interface InterviewDisplayLinkViewController ()

@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) double lastTime;
@property (nonatomic, assign) int count;

@end

@implementation InterviewDisplayLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    _link = [CADisplayLink displayLinkWithTarget:self selector:@selector(displaylinkCallback:)];
    [_link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}



- (void)displaylinkCallback:(CADisplayLink *)link {
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    
    self.count += 1;
    double time = link.timestamp - self.lastTime;
    
    if (time < 1) {
        return;
    }
    
    self.lastTime = link.timestamp;
    double fps = self.count / time;
    self.count = 0;
    NSLog(@"fps = %f", fps);
    
}

@end
