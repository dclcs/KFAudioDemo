//
//  InAssociatedModel+Test.m
//  AVDemo
//
//  Created by cl d on 2024/3/22.
//

#import "InAssociatedModel+Test.h"
#import <objc/runtime.h>
#import "WeakObjWrapper.h"

@implementation InAssociatedModel (Test)

//@dynamic testStr;
static const NSString *testStrKey = @"testStrKey";

- (void)setTestStr:(NSString *)testStr {
    objc_setAssociatedObject(self, &testStrKey, testStr, OBJC_ASSOCIATION_COPY);
}

- (NSString *)testStr {
    return objc_getAssociatedObject(self, &testStrKey);
}

//- (void)setVc:(UIViewController *)vc {
//    objc_setAssociatedObject(self, &viewControllerKey, vc, OBJC_ASSOCIATION_ASSIGN);
//}
//
//- (UIViewController *)vc {
//    return objc_getAssociatedObject(self, &viewControllerKey);
//}
OBJC_EXPORT void
objc_msgSend(void /* id self, SEL op, ... */ )
    OBJC_AVAILABLE(10.0, 2.0, 9.0, 1.0, 2.0);

static const NSString *viewControllerKey = @"viewControllerKey";

// 方式二 ： runtime + assign
void weak_setAssociatedObject(id _Nonnull object,
                              const void * _Nonnull key,
                              id _Nullable value)
{
    const char *clsName = [[NSString stringWithFormat:@"WeakObjWrapper%@", [value class]] UTF8String];
    clsName = [[NSString stringWithFormat:@"WeakObjWrapper"] UTF8String];
    Class childCls = objc_getClass(clsName);
    
    if (!childCls) {
        childCls = objc_allocateClassPair([value class], clsName, 0);
        objc_registerClassPair(childCls);
    }
    
    SEL sel = sel_registerName("dealloc");
    const char *deallocEncoding = method_getTypeEncoding(class_getInstanceMethod([value class], sel));
    
    __weak typeof(value) weakValue = value;
    
    IMP deallocImp = imp_implementationWithBlock(^(id _childCls) {
        objc_setAssociatedObject(object, key, nil, OBJC_ASSOCIATION_ASSIGN);
        ((void (*)(id, SEL))(void *)objc_msgSend)(weakValue, sel);
    });
    
    class_addMethod(childCls, sel, deallocImp, deallocEncoding);
    object_setClass(value, childCls);
    objc_setAssociatedObject(object, key, value, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setVc:(UIViewController *)vc
{
    weak_setAssociatedObject(self, &viewControllerKey, vc);
}

- (UIViewController *)vc
{
    return objc_getAssociatedObject(self, &viewControllerKey);
}

// 方式一 ： 设置weak关联对象
//- (void)setVc:(UIViewController *)vc {
//    WeakObjWrapper *wrapper = objc_getAssociatedObject(self, &viewControllerKey);
//    if (!wrapper) {
//        wrapper = [[WeakObjWrapper alloc] initWithWeakObject:vc];
//    } else {
//        wrapper.weakObj = vc;
//    }
//    objc_setAssociatedObject(self, &viewControllerKey, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}
//
//- (UIViewController *)vc {
//    WeakObjWrapper *wrapper = objc_getAssociatedObject(self, &viewControllerKey);
//    return wrapper.weakObj;
//}


- (void)funcOfAssociated
{
    NSLog(@"funcOfAssociated");
    [self func];
}

- (void)func
{
    NSLog(@"something in %s", __func__);
    // 调用原类的方法
    unsigned int count;
    Method *methods = class_copyMethodList([InAssociatedModel class], &count);
    NSInteger index = count - 1;
    
    for (int i = index ; i >= 0 ; i --)
    {
        
        SEL name = method_getName(methods[i]);
        NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
        
        if ([strName isEqualToString:@"func"]) {
            index = i;
            break;
        }
    }
    
    SEL sel = method_getName(methods[index]);
    IMP imp = method_getImplementation(methods[index]);
    ((void (*)(id, SEL))imp)(self, sel);

}


@end
