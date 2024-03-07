//
//  BlockMonitorMgr.m
//  AVDemo
//
//  Created by cl d on 2024/2/17.
//

#import "BlockMonitorMgr.h"
#import <sys/time.h>

static BOOL g_bLaunchOver = NO;
static CFRunLoopActivity g_runLoopActivity;
typedef enum : NSUInteger {
    eRunloopInitMode,
    eRunloopDefaultMode,
} ERunloopMode;

static ERunloopMode g_runLoopMode;
static BOOL g_bRun;
static struct timeval g_tvRun;

@interface BlockMonitorMgr () {
    CFRunLoopObserverRef m_runLoopBeginObserver;
    CFRunLoopObserverRef m_runLoopEndObserver;
    CFRunLoopObserverRef m_initializationBeginRunloopObserver;
    CFRunLoopObserverRef m_initializationEndRunloopObserver;

}

@end

@implementation BlockMonitorMgr

+ (BlockMonitorMgr *)shareInstance
{
    static BlockMonitorMgr *g_monitorMgr = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        g_monitorMgr = [[BlockMonitorMgr alloc] init];
    });
    return g_monitorMgr;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        g_bLaunchOver = YES;
    }
    return self;
}

- (void)start
{
    [self addRunLoopObserver];
}

- (void)stop
{
    
}

void myRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    g_runLoopActivity = activity;
    g_runLoopMode = eRunloopDefaultMode;
    switch (activity) {
        case kCFRunLoopEntry:
            g_bRun = YES;
            break;
        case kCFRunLoopBeforeTimers:
            if (g_bRun == NO) {
                gettimeofday(&g_tvRun, NULL);
            }
            g_bRun = YES;
            break;
        case kCFRunLoopBeforeSources:
            if (g_bRun == NO) {
                gettimeofday(&g_tvRun, NULL);
            }
            g_bRun = YES;
            break;
        case kCFRunLoopAfterWaiting:
            if (g_bRun == NO) {
                gettimeofday(&g_tvRun, NULL);
            }
            g_bRun = YES;
            break;
        case kCFRunLoopAllActivities:
            break;
        default:
            break;
    }
}

void myRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    g_runLoopActivity = activity;
    g_runLoopMode = eRunloopDefaultMode;
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
//            if (g_bSensitiveRunloopHangDetection && g_bRun) {
//                [WCBlockMonitorMgr checkRunloopDuration];
//            }
            [BlockMonitorMgr checkRunloopDuration];
            gettimeofday(&g_tvRun, NULL);
            g_bRun = NO;
            break;

        case kCFRunLoopExit:
            g_bRun = NO;
            break;

        case kCFRunLoopAllActivities:
            break;

        default:
            break;
    }
}

void myInitializetionRunLoopBeginCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    g_runLoopActivity = activity;
    g_runLoopMode = eRunloopInitMode;
    switch (activity) {
        case kCFRunLoopEntry:
            g_bRun = YES;
            g_bLaunchOver = NO;
            break;

        case kCFRunLoopBeforeTimers:
            gettimeofday(&g_tvRun, NULL);
            g_bRun = YES;
            g_bLaunchOver = NO;
            break;

        case kCFRunLoopBeforeSources:
            gettimeofday(&g_tvRun, NULL);
            g_bRun = YES;
            g_bLaunchOver = NO;
            break;

        case kCFRunLoopAfterWaiting:
            gettimeofday(&g_tvRun, NULL);
            g_bRun = YES;
            g_bLaunchOver = NO;
            break;

        case kCFRunLoopAllActivities:
            break;
        default:
            break;
    }
}

void myInitializetionRunLoopEndCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info)
{
    g_runLoopActivity = activity;
    g_runLoopMode = eRunloopInitMode;
    switch (activity) {
        case kCFRunLoopBeforeWaiting:
            gettimeofday(&g_tvRun, NULL);
            g_bRun = NO;
            g_bLaunchOver = YES;
            break;

        case kCFRunLoopExit:
            g_bRun = NO;
            g_bLaunchOver = YES;
            break;

        case kCFRunLoopAllActivities:
            break;

        default:
            break;
    }
}

- (void)addRunLoopObserver
{
    NSRunLoop *curRunLoop = [NSRunLoop currentRunLoop];
    
    //the first observer
    CFRunLoopObserverContext context = { 0, (__bridge  void *)self, NULL, NULL, NULL };
    CFRunLoopObserverRef beginObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &myRunLoopBeginCallback, &context);
    CFRetain(beginObserver);
    m_runLoopBeginObserver = beginObserver;
    
    //the last observer
    CFRunLoopObserverRef endObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MAX, &myRunLoopEndCallback, &context);
    CFRetain(endObserver);
    m_runLoopEndObserver = endObserver;
    
    CFRunLoopRef runloop = [curRunLoop getCFRunLoop];
    CFRunLoopAddObserver(runloop, beginObserver, kCFRunLoopCommonModes);
    CFRunLoopAddObserver(runloop, endObserver, kCFRunLoopCommonModes);
    
    // init runloop mode
    CFRunLoopObserverContext initializationContext = { 0, (__bridge void *)self, NULL, NULL, NULL };
    m_initializationBeginRunloopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &myInitializetionRunLoopBeginCallback, &initializationContext);
    CFRetain(m_initializationBeginRunloopObserver);
    
    m_initializationEndRunloopObserver = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopAllActivities, YES, LONG_MIN, &myInitializetionRunLoopEndCallback, &initializationContext);
    CFRetain(m_initializationEndRunloopObserver);
    
    CFRunLoopAddObserver(runloop, m_initializationBeginRunloopObserver, (CFRunLoopMode)@"UIInitilaizationRunLoopMode");
    CFRunLoopAddObserver(runloop, m_initializationEndRunloopObserver, (CFRunLoopMode)@"UIInitilaizationRunLoopMode");

}


+ (void)checkRunloopDuration
{
    struct timeval tvCur;
    gettimeofday(&tvCur, NULL);
    unsigned long long duration = [BlockMonitorMgr diffTime:&g_tvRun endTime:&tvCur];
    
    if ((duration > 250 * BM_MicroFormat_MillSecond) && (duration < 60 * BM_MicroFormat_Second)) {
        // leave main thread as soon as possible
        
        NSLog(@"Runloop hang detected!");
    }
}


+ (unsigned long long)diffTime:(struct timeval *)tvStart endTime:(struct timeval *)tvEnd {
    return 1000000 * (tvEnd->tv_sec - tvStart->tv_sec) + tvEnd->tv_usec - tvStart->tv_usec;
}

@end
