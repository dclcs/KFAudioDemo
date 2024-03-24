//
//  InterViewUIButtonClickMultiViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/24.
//

#import "InterViewUIButtonClickMultiViewController.h"
#import <objc/runtime.h>
@interface UIButton (FixMultiClick)
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
@property (nonatomic, assign) NSTimeInterval timeInterval;
@end

@implementation UIButton (FixMultiClick)

+ (void)load
{
    [super load];
    Method normal = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method fixMultiClick = class_getInstanceMethod(self, @selector(fixMultiClick_SendAction:to:forEvent:));
    method_exchangeImplementations(normal, fixMultiClick);
}

- (void)fixMultiClick_SendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    if ([NSDate date].timeIntervalSince1970 - self.timeInterval < self.acceptEventInterval) {
        return;
    }
    
    if (self.acceptEventInterval > 0) {
        self.timeInterval = [NSDate date].timeIntervalSince1970;
    }
    [self fixMultiClick_SendAction:action to:target forEvent:event];
}

static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_timeInterval = "UIControl_timeInterval";

- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval
{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)acceptEventInterval
{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, UIControl_timeInterval, @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, UIControl_timeInterval) doubleValue];
}

@end


@interface InterViewUIButtonClickMultiViewController ()

@end

@implementation InterViewUIButtonClickMultiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    btn.backgroundColor = UIColor.redColor;
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    btn.acceptEventInterval = 0.5f;
    [self.view addSubview:btn];
    btn.center = self.view.center;
}


- (void)btnClicked
{
    dispatch_queue_t queue = dispatch_queue_create("com.btn.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"task start sleep!!!!");
        NSLog(@"task exected!!!");
    });
}

@end
