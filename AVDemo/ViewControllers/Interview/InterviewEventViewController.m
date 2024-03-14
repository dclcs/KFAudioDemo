//
//  InterviewEventViewController.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/11.
//

#import "InterviewEventViewController.h"
#import "YDSimulInterViewController.h"
#import "YDSImulInterKit.h"
#import "YDTSimulInterViewController.h"
#import "YDTSimulInterConfig.h"
#define MaxClickArea 100

@interface TestUIButton : UIButton

@end


@implementation TestUIButton

//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
//{
//    CGRect bounds = self.bounds;
//
//    CGFloat widthDelta = MAX(MaxClickArea - bounds.size.width, 0);
//    CGFloat heightDelta = MAX(MaxClickArea - bounds.size.height, 0);
//
//    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
//
//    return CGRectContainsPoint(bounds, point);
//}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bigRect = CGRectInset(self.bounds, -0.5 * MaxClickArea, -0.5 * MaxClickArea);
    if (CGRectContainsPoint(bigRect, point))
    {
        return self;
    } else {
        return nil;
    }
}

@end

@interface GestureUI : UIView

@end


@implementation GestureUI

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupGesture];
    }
    return self;
}

- (void)setupGesture
{
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureHandle)];
    [self addGestureRecognizer:ges];

}

- (void)gestureHandle
{
    NSLog(@"gesture ui");
}

@end

@interface InterviewEventViewController ()

@end

@implementation InterviewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    
    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MaxClickArea, MaxClickArea)];
    [self.view addSubview:emptyView];
    emptyView.center = self.view.center;
    emptyView.backgroundColor = UIColor.redColor;
    
    TestUIButton *button = [[TestUIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [self.view addSubview:button];
    button.center = self.view.center;
    button.backgroundColor = UIColor.blackColor;
    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    
    
    GestureUI *gestureView = [[GestureUI alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:gestureView];
    gestureView.backgroundColor = UIColor.greenColor;
    gestureView.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    [gestureView addSubview:btn];
    btn.backgroundColor = UIColor.blueColor;
    [btn addTarget:self action:@selector(btnInGestureUI) forControlEvents:UIControlEventTouchUpInside];
    btn.userInteractionEnabled = false;
}

- (void)clickBtn
{
    NSLog(@"click Btn");
    
    YDTSimulInterViewController *vc = [[YDTSimulInterViewController alloc] init];
    YDTSimulInterConfig *config = [[YDTSimulInterConfig alloc] init];
    config.viewController = vc;
    [YDSImulInterKit.sharedKit registerConfig:config];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)btnInGestureUI
{
    NSLog(@"button gesture");
}

@end

