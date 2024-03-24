//
//  InterViewOffScreenRenderViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/24.
//

#import "InterViewOffScreenRenderViewController.h"

@interface InterViewOffScreenRenderViewController ()

@end

@implementation InterViewOffScreenRenderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self example];
}


- (void)example
{
    ///都用圆角
        //imageView没有设置背景色，不会离屏
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 30, 100, 100)];
    imgView.layer.cornerRadius = 20;
    imgView.layer.masksToBounds = YES;
    imgView.image = [UIImage imageNamed:@"demo_image"];
    [self.view addSubview:imgView];
    
    //imageView设置背景色，用clipsToBounds/masksToBounds不会离屏
    UIImageView *imgView2 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 150, 100, 100)];
    imgView2.layer.cornerRadius = 20;
//        imgView2.clipsToBounds = YES;
    imgView2.layer.masksToBounds = YES;
    imgView2.backgroundColor = [UIColor whiteColor];
    imgView2.image = [UIImage imageNamed:@"demo_image"];
    [self.view addSubview:imgView2];
    
    //imageView设置边框，会离屏
    UIImageView *imgView3 = [[UIImageView alloc] initWithFrame:CGRectMake(100, 270, 100, 100)];
    imgView3.layer.cornerRadius = 20;
    imgView3.layer.masksToBounds = YES;
    imgView3.image = [UIImage imageNamed:@"demo_image"];
    imgView3.layer.borderWidth = 2;
    imgView3.layer.borderColor = [UIColor redColor].CGColor;
    [self.view addSubview:imgView3];
    
    //按钮只设置背景色，不会离屏
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 400, 100, 100);
    btn.layer.cornerRadius = 20;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor redColor];
    [self.view addSubview:btn];
    
    //按钮设置背景图，会离屏
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 520, 100, 100);
    [btn1 setImage:[UIImage imageNamed:@"demo_image"] forState:UIControlStateNormal];
    btn1.layer.cornerRadius = 20;
    btn1.layer.masksToBounds = YES;
    [self.view addSubview:btn1];
}

// offscreen render
- (void)offscreenRender1
{
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(100, 30, 100, 100);
    btn1.layer.cornerRadius = 50;
    btn1.center = self.view.center;
    [self.view addSubview:btn1];

    btn1.clipsToBounds = YES;
    btn1.backgroundColor = [UIColor redColor];
    [btn1 setImage:[UIImage imageNamed:@"demo_image"] forState:UIControlStateNormal];
}

- (void)offscreenRender2
{
    UIImageView *img1 = [[UIImageView alloc]init];
    img1.frame = CGRectMake(100, 320, 100, 100);
    [self.view addSubview:img1];
    img1.center = self.view.center;

    img1.layer.cornerRadius = 50;
    img1.layer.masksToBounds = YES;
    img1.layer.borderColor = UIColor.blueColor.CGColor;
    img1.layer.borderWidth = 3;
    img1.backgroundColor = [UIColor blueColor];
    img1.image = [UIImage imageNamed:@"demo_image"];
}

- (void)offscreenRender3
{
    UIImageView *img2 = [[UIImageView alloc]init];
    img2.frame = CGRectMake(100, 480, 100, 100);
    [self.view addSubview:img2];
    
    img2.layer.cornerRadius = 50;
    img2.layer.masksToBounds = YES;
    
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    subView.backgroundColor = [UIColor redColor];
    [img2 addSubview:subView];

}

- (void)setImageCornerRadius
{
    UIView *view = [UIView new];
    UIImage *image = [UIImage imageNamed:@"demo_image"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self.view addSubview:view];
    [self.view addSubview:imageView];
    view.frame = CGRectMake(0, 0, 220, 220);
    view.center = self.view.center;
    imageView.frame = CGRectMake(0, 0, 200, 200);
    imageView.center = self.view.center;
    imageView.layer.masksToBounds = YES;
    imageView.layer.cornerRadius = 10;
    imageView.backgroundColor = UIColor.redColor;
}

- (void)layerMaskExample
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.redColor;
    view.frame = CGRectMake(0, 0, 220, 220);
    view.center = self.view.center;
    [self.view addSubview:view];

//    CALayer *layer = [[CALayer alloc] init];
//    layer.backgroundColor = UIColor.blueColor.CGColor;
//    layer.frame = view.bounds;
//    view.layer.mask = layer;
    
    UIBezierPath* path = [UIBezierPath bezierPathWithRect:view.bounds];
    CAShapeLayer* shape = [CAShapeLayer layer];
    shape.lineWidth = 10;
    shape.borderWidth = 10;
    shape.path = path.CGPath;
    view.layer.mask = shape;

}

- (void)groupOpacityExample
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.blackColor;
    view.frame = CGRectMake(0, 0, 220, 220);
    view.center = self.view.center;
    [self.view addSubview:view];
    view.layer.opacity = 0.3;
    view.layer.allowsGroupOpacity = YES;
}

- (void)clipOrMaskExample
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.blackColor;
    view.frame = CGRectMake(0, 0, 220, 220);
    view.center = self.view.center;
    [self.view addSubview:view];
    view.layer.masksToBounds = YES;
    view.clipsToBounds = YES;
}

- (void)shouldRasterize
{
    UIView *view = [UIView new];
    view.backgroundColor = UIColor.blackColor;
    view.frame = CGRectMake(0, 0, 220, 220);
    view.center = self.view.center;
    [self.view addSubview:view];
    view.layer.shouldRasterize = YES;
}

@end
