//
//  InterViewAssociatedViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import "InterViewAssociatedViewController.h"
#import "InAssociatedModel+Test.h"
@interface InterViewAssociatedViewController ()

@end

@implementation InterViewAssociatedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // usage of InAssociatedModel
    InAssociatedModel *m = [[InAssociatedModel alloc] init];
    [m funcOfAssociated];
    
//    m.testStr = @"123123";
//    NSLog(@"m.testStr = %@", m.testStr);
    {
        UIViewController *vc = [[UIViewController alloc] init];
        m.vc = vc;
        NSLog(@"in - vc = %@", m.vc);

    }
    NSLog(@"out - vc = %@", m.vc);
    
    
    // atomic 实验
    m.fistName = @"firstName";
    m.secondName = @"secondName";
    m.thirdName = @"thirdName";
    
    dispatch_queue_t queue = dispatch_queue_create("com.atmoic.queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        NSLog(@"secondName 0 : thread : %@", [NSThread currentThread]);
        [m setSecondName:@"firstName0"];
    });
    
    dispatch_async(queue, ^{
        NSLog(@"get secondName : thread : %@", [NSThread currentThread]);
        NSLog(@"thirdName = %@", m.secondName);
    });
    
    dispatch_async(queue, ^{
        NSLog(@"secondName 1 : thread : %@", [NSThread currentThread]);
        [m setSecondName:@"secondName0"];
    });
    
    
    [InAssociatedModel classFunc];
    
}


@end
