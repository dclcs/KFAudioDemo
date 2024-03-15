//
//  WPDrawInfoCenter.m
//  AVDemo
//
//  Created by daicanglan on 2024/3/15.
//

#import "WPDrawInfoCenter.h"

@interface WPDrawInfoCenter ()

@property (nonatomic, strong,readwrite) NSMutableArray<WPDrawTraceInfo *> *drawInfoBuffer;
@property (nonatomic, assign) NSInteger nextSeqNewTraceNeed;

@end

@implementation WPDrawInfoCenter

+ (instancetype)defaultCenter
{
    static WPDrawInfoCenter *center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [[self alloc] init];
    });
    return center;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        self.sender = [[WPDrawInfoSender alloc] init];
//        self.drawInfoBuffer = [NSMutableArray array];
//        
//        self.nextSeqNewTraceNeed = 1;
//        self.nextSeqServerNeed = 1;
//        
//        self.config = [WPDrawConfig new];
    }
    return self;
}

- (void)appendCurrentDrawInfo
{
    if (!_currentDraw) {
        return;
    }
    [self.drawInfoBuffer addObject:_currentDraw];
//    if ([self.delegate respondsToSelector:@selector(didAppendDrawTrace:)]) {
//        [self.delegate didAppendDrawTrace:_currentDraw];
//    }
    
    _currentDraw = nil;
}


- (WPDrawTraceInfo *)currentDraw {
    if (!_currentDraw) {
        WPDrawTraceInfo *newDrawInfo = [WPDrawTraceInfo new];
//        if (self.config.isEraser) {
//            newDrawInfo.type = WPDrawTypeEraser;
//            newDrawInfo.width = self.config.eraserWidth;
//            newDrawInfo.widthV2 = self.config.eraserWidth;
//        } else {
        newDrawInfo.type = WPDrawTypeDraw;
//            //width表示2021.1.21之前版本用到的width，然后以前是用的int，所以这里是为了兼容老版本
//            newDrawInfo.width = self.config.penWidth < 1 ? 1 : self.config.penWidth;
//            newDrawInfo.widthV2 = self.config.penWidth;
//        }
        newDrawInfo.color = UIColor.redColor;
        newDrawInfo.seq = self.nextSeqNewTraceNeed;
        newDrawInfo.isLineStart = NO;
        self.nextSeqNewTraceNeed = self.nextSeqNewTraceNeed + 1;
        _currentDraw = newDrawInfo;
    }
    return _currentDraw;
}

@end
