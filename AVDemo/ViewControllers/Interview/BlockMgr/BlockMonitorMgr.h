//
//  BlockMonitorMgr.h
//  AVDemo
//
//  Created by cl d on 2024/2/17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
#define BM_MicroFormat_MillSecond 1000
#define BM_MicroFormat_Second 1000000

@interface BlockMonitorMgr : NSObject

+ (BlockMonitorMgr *)shareInstance;

- (void)start;
- (void)stop;


@end

NS_ASSUME_NONNULL_END
