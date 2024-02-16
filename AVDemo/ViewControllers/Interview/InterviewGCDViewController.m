//
//  InterviewGCDViewController.m
//  AVDemo
//
//  Created by cl d on 2024/2/14.
//

#import "InterviewGCDViewController.h"

@interface InterviewGCDViewController ()
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSNumber *number;
@end

@implementation InterviewGCDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    
    
//    dispatch_queue_t serialQueue = dispatch_queue_create("serialQueue", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    dispatch_queue_t globalQueue = dispatch_get_global_queue(0, 0);
//
//    self.array = [NSMutableArray new];
//    for (int i = 0 ; i < 100; i ++) {
//        dispatch_async(concurrentQueue, ^{
////            [self.array addObject:@(i)];
//            self.number = @(i);
//        });
//    }
    
    NSLog(@"执行任务1");
       
       dispatch_queue_t queue = dispatch_queue_create("myqueu", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"Task 123");
    });
    
    
    dispatch_sync(queue, ^{
        NSLog(@"Task 14214");
    });
//       dispatch_async(queue, ^{ // 0
//           NSLog(@"执行任务2");
//           
//           dispatch_sync(queue, ^{ // 1
//               NSLog(@"执行任务3");
//           });
//       
//           NSLog(@"执行任务4");
//       });
       
       NSLog(@"执行任务5");
    
}


@end
