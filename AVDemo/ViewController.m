//
//  ViewController.m
//  KFAudioDemo
//
//  Created by cl d on 2023/12/19.
//

#import "ViewController.h"
#import "DemosModel.h"
static NSString * const KFMainTableCellIdentifier = @"KFMainTableCellIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) UITableView *myTableView;

@property (nonatomic, strong) NSArray<NSArray<DemosModel *> *> *demos;
@property (nonatomic, strong) NSArray *demoTitle;
@end

@implementation ViewController

#pragma mark - Property
- (UITableView *)myTableView {
    if (!_myTableView) {
        _myTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    
    return _myTableView;
}


- (void)mockDemos
{
    // AVS
    DemosModel *d0 = [[DemosModel alloc] initWithTitle:@"Audio Capture" target:@"KFAudioCaptureViewController" type:DemoTypeAV];
    DemosModel *d1 = [[DemosModel alloc] initWithTitle:@"Audio Encoder" target:@"KFAudioEncoderViewController" type:DemoTypeAV];
    DemosModel *d2 = [[DemosModel alloc] initWithTitle:@"Audio Muxer" target:@"KFAudioMuxerViewController" type:DemoTypeAV];
    DemosModel *d3 = [[DemosModel alloc] initWithTitle:@"Audio Demuxer" target:@"KFAudioDemuxerViewController" type:DemoTypeAV];
    DemosModel *d4 = [[DemosModel alloc] initWithTitle:@"Audio Decoder" target:@"KFAudioDecoderViewController" type:DemoTypeAV];
    DemosModel *d5 = [[DemosModel alloc] initWithTitle:@"Audio Render" target:@"KFAudioRenderViewController" type:DemoTypeAV];
    
    
    // Toy
    DemosModel *d6 = [[DemosModel alloc] initWithTitle:@"TestImageLoader" target:@"TestImageLoaderViewController" type:DemoTypeToy];
    
    // Interview
    DemosModel *d7 = [[DemosModel alloc] initWithTitle:@"多线程相关" target:@"InterviewGCDViewController" type:DemoTypeInterview];
    DemosModel *d8 = [[DemosModel alloc] initWithTitle:@"信号量使用" target:@"InterviewSemaphoreViewController" type:DemoTypeInterview];
    
    
    self.demos = @[@[d0, d1, d2, d3, d4, d5], @[d6], @[d7, d8]];
    
//    self.demoTitle = [[NSDictionary alloc] initWithObjects:@[@(DemoTypeAV), @(DemoTypeToy), @(DemoTypeInterview)] forKeys:@[@"Audio & Video", @"ToyImageLoader", @"InterView"]];
    self.demoTitle = @[@"Audio & Video", @"ToyImageLoader", @"InterView"];

}


#pragma mark - Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    [self mockDemos];
    [self setupUI];
}

#pragma mark - Setup
- (void)setupUI {
    // Use full screen layout.
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.extendedLayoutIncludesOpaqueBars = YES;
    
    self.title = @"Demos";
    
    // myTableView.
    [self.view addSubview:self.myTableView];
    self.myTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:self.myTableView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.myTableView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeRight multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.myTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0],
                                [NSLayoutConstraint constraintWithItem:self.myTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view.safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0],
                                ]];
}

#pragma mark - Navigation
- (void)goToDemoPageWithViewControllerName:(NSString *)name {
    UIViewController *vc = [(UIViewController *) [NSClassFromString(name) alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self goToDemoPageWithViewControllerName:self.demos[indexPath.section][indexPath.row].target];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.demos.count;
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.demoTitle[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return ((NSArray *)self.demos[section]).count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:KFMainTableCellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:KFMainTableCellIdentifier];
    }
    
    NSString *demoTitle = self.demos[indexPath.section][indexPath.row].title;
    cell.textLabel.text = demoTitle;
    
    return cell;
}


@end
