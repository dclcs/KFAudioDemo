//
//  InterViewScrollViewController.m
//  AVDemo
//
//  Created by cl d on 2024/4/14.
//

#import "InterViewScrollViewController.h"
#import <Masonry/Masonry.h>
@interface InterViewScrollViewController ()
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation InterViewScrollViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.containerView = [[UIView alloc] init];
    self.scrollView = [[UIScrollView alloc] init];
    [self setupViews];
//    [self setupViewsWithoutAutoLayout];
    
}

- (void)setupViewsWithoutAutoLayout
{
    [self.view addSubview:self.scrollView];
    self.scrollView.frame = self.view.bounds;
    [self.scrollView addSubview:self.containerView];
    self.containerView.frame = self.view.bounds;
    UIView *subView = [[UIView alloc] init];
    subView.frame = CGRectMake(20, 20, self.containerView.frame.size.width - 40, 1000);
    [self.containerView addSubview:subView];
    subView.backgroundColor = UIColor.blueColor;
}

- (void)setupViews
{
    /// PS : contentLayout not support
    UILayoutGuide *contentLayoutGuide = self.scrollView.contentLayoutGuide;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    [self.scrollView addSubview:self.containerView];
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(contentLayoutGuide);
        make.left.right.mas_equalTo(contentLayoutGuide);
        make.width.equalTo(self.scrollView);
    }];
    
    UIView *subView = [[UIView alloc] init];
    subView.backgroundColor = UIColor.redColor;
    [self.containerView addSubview:subView];
    
    [subView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.right.mas_equalTo(self.containerView).inset(20);
        make.height.equalTo(@1000);
        make.bottom.equalTo(self.containerView).offset(-20);
    }];
    
}

@end
