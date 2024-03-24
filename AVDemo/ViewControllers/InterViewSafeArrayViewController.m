//
//  InterViewSafeArrayViewController.m
//  AVDemo
//
//  Created by cl d on 2024/3/24.
//

#import "InterViewSafeArrayViewController.h"
#import <objc/runtime.h>
@interface NSArray (Crash)

@end

@implementation NSArray (Crash)

+ (void)load
{
    [super load];
    Method oldObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtIndex:));
    Method newObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayI"), @selector(objectAtSafeIndex:));
    method_exchangeImplementations(oldObjectAtIndex, newObjectAtIndex);
    
    Method oldMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(objectAtIndex:));
    Method newMutableObjectAtIndex = class_getInstanceMethod(objc_getClass("__NSArrayM"), @selector(mutableObjectAtSafeIndex:));
    method_exchangeImplementations(oldMutableObjectAtIndex, newMutableObjectAtIndex);
    
}

- (id)objectAtSafeIndex:(NSUInteger)index
{
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self objectAtSafeIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"exception : %@", exception.reason);
            return nil;
        }
    }
    
    return [self objectAtSafeIndex:index];
}


- (id)mutableObjectAtSafeIndex:(NSUInteger)index
{
    if (index > self.count - 1 || !self.count) {
        @try {
            return [self mutableObjectAtSafeIndex:index];
        } @catch (NSException *exception) {
            NSLog(@"exception : %@", exception.reason);
            return nil;
        }
    }
    
    return [self mutableObjectAtSafeIndex:index];
}


@end


@interface InterViewSafeArrayViewController ()

@end

@implementation InterViewSafeArrayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *arr = [NSArray arrayWithObjects:@(23), @(45), nil];
    NSLog(@"arr at 2 : %@", [arr objectAtIndex:2]);
    
    [self showCustomClassNameOnly];
}



- (void)showAllClassNameInProject {
    int allClasses = objc_getClassList(NULL,0);
    Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * allClasses);
    allClasses = objc_getClassList(classes, allClasses);
    
    for (int i = 0; i < allClasses; i++) {
        Class clazz = classes[i];
        NSString *className = NSStringFromClass(clazz);
        NSLog(@"当前项目中全部 class: %@", className);
    }
    free(classes);
}

- (void)showCustomClassNameOnly {
    int allClasses = objc_getClassList(NULL,0);
    Class *classes = (__unsafe_unretained Class *)malloc(sizeof(Class) * allClasses);
    allClasses = objc_getClassList(classes, allClasses);
    
    for (int i = 0; i < allClasses; i++) {
        Class clazz = classes[i];
        NSBundle *b = [NSBundle bundleForClass:clazz];
        if (b == [NSBundle mainBundle]) {
            NSLog(@"自定义 class: %@", NSStringFromClass(clazz));
        }
    }
    free(classes);
}

@end
