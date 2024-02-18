//
//  InterviewOperationViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/15.
//

#import "InterviewOperationViewController.h"
#import "InterOperation.h"
@interface InterviewOperationViewController ()

@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation InterviewOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
    NSArray* urls = @[
        @"https://s2.ax1x.com/2019/11/01/KHYIgJ.gif",
        @"https://res.cloudinary.com/dwpjzbyux/raw/upload/v1666474070/RawDemo/raw_vebed5.NEF",
        @"https://placehold.co/200x200.jpg",
        @"https://nr-platform.s3.amazonaws.com/uploads/platform/published_extension/branding_icon/275/AmazonS3.png",
    ];
    _queue = [NSOperationQueue new];
    for (int i=0; i < urls.count;i++)
    {
        InterOperation* operation = [[InterOperation alloc]initWithUrl:urls[i] name:[NSString stringWithFormat:@"%d",i]];
        [_queue addOperation:operation];
    }
}



@end
