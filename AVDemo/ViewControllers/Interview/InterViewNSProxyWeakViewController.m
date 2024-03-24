//
//  InterViewNSProxyWeakViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/24.
//

#import "InterViewNSProxyWeakViewController.h"


@interface WYProxy : NSProxy
@property(nonatomic, weak, readonly) NSObject *objc;
@end

@implementation WYProxy
- (id)transformObjc:(NSObject *)objc
{
    _objc = objc;
    return self;
}

+ (instancetype)proxyWithObjc:(id)objc
{
    return [[self alloc] transformObjc:objc];
}


- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    NSMethodSignature *signature;
    if (self.objc) {
        signature = [self methodSignatureForSelector:sel];
    } else {
        signature = [super methodSignatureForSelector:sel];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL sel = [invocation selector];
    if ([self.objc respondsToSelector:sel]) {
        [invocation invokeWithTarget:self.objc];
    }
}


@end

typedef void (^addBlock2)(int num1,int num2);

@interface InterViewNSProxyWeakViewController ()
@property (nonatomic, assign) addBlock2 block;
@property (nonatomic, strong) NSString *name;
@end

@implementation InterViewNSProxyWeakViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WYProxy *proxy = [WYProxy alloc];
    [proxy transformObjc:self];
    self.block = ^(int num1, int num2) {
        [proxy performSelector:@selector(setName:)];
        NSLog(@"num1+num2=%d",num1+num2);
    };
}

@end
