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


@interface ColoredView : UIView
@property (nonatomic, strong) UIColor* color;
@property (nonatomic, strong) NSString *colorDes;
@end

@implementation ColoredView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame color:(UIColor *)color withDesc:(NSString *)str{
    self = [super initWithFrame:frame];
    if (self) {
        self.color = color;
        self.colorDes = str;
        self.backgroundColor = color;
    }
    return self;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[%@] touchesBegan", self.colorDes);
    [super touchesBegan:touches withEvent:event];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[%@] touchesMoved", self.colorDes);
    [super touchesMoved:touches withEvent:event];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[%@] touchesEnded", self.colorDes);
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[%@] touchesCancelled", self.colorDes);
}

@end


// 自定义手势
@interface CircleGestureRecognizer : UIGestureRecognizer

@end

@implementation CircleGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[CircleGestureRecognizer] touchesBegan : %ld", (long)self.state);
    
//    NSLog(@"[CircleGestureRecognizer] touchesBegan changed state : %ld", (long)self.state);
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[CircleGestureRecognizer] touchesMoved : %ld", (long)self.state);
    self.state = UIGestureRecognizerStateBegan;
    NSLog(@"[CircleGestureRecognizer] touchesMoved : %ld", (long)self.state);

}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.state = UIGestureRecognizerStateEnded;
    NSLog(@"[CircleGestureRecognizer] touchesEnded : %ld", (long)self.state);
}


- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSLog(@"[CircleGestureRecognizer] touchesCancelled : %ld", (long)self.state);

}

@end

@interface InterviewEventViewController ()

@end

@implementation InterviewEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.grayColor;
    
//    UIView *emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MaxClickArea, MaxClickArea)];
//    [self.view addSubview:emptyView];
//    emptyView.center = self.view.center;
//    emptyView.backgroundColor = UIColor.redColor;
//    
//    TestUIButton *button = [[TestUIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [self.view addSubview:button];
//    button.center = self.view.center;
//    button.backgroundColor = UIColor.blackColor;
//    [button addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
//    
//    
//    GestureUI *gestureView = [[GestureUI alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
//    [self.view addSubview:gestureView];
//    gestureView.backgroundColor = UIColor.greenColor;
//    gestureView.center = CGPointMake(self.view.center.x, self.view.center.y + 100);
//    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
//    [gestureView addSubview:btn];
//    btn.backgroundColor = UIColor.blueColor;
//    [btn addTarget:self action:@selector(btnInGestureUI) forControlEvents:UIControlEventTouchUpInside];
//    btn.userInteractionEnabled = false;
    ColoredView *redView = [[ColoredView alloc] initWithFrame:CGRectMake(0, 0, 200, 200) color:[UIColor redColor] withDesc:@"red"];
    redView.center = self.view.center;
    [self.view addSubview:redView];
    
    ColoredView *blueView = [[ColoredView alloc] initWithFrame:CGRectMake(0, 0, 100, 100) color:[UIColor blueColor] withDesc:@"blue"];
    CircleGestureRecognizer *gesture = [[CircleGestureRecognizer alloc] initWithTarget:self action:@selector(cicle)];
//    blueView.center = redView.center;
    gesture.cancelsTouchesInView = NO;
//    gesture.delaysTouchesBegan = YES;
    gesture.delaysTouchesEnded = YES;
    [blueView addGestureRecognizer:gesture];
    [redView addSubview:blueView];
}

- (void)cicle
{
    NSLog(@"gesture called");
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

