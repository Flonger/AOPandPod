/*******************************************************************************\
** Demo1Method:UIViewController+Analytics.m
** Created by Flonger(xue@flonger.com) on 2018/8/31
**
**Copyright © 2018 Flonger. All rights reserved.
\*******************************************************************************/


#import "UIViewController+Analytics.h"
#import <objc/runtime.h>
@implementation UIViewController (Analytics)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL originalSelector = @selector(viewWillAppear:);
        SEL swizzledSelector = @selector(new_viewWillAppear:);
        
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        
        BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        if (success) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

#pragma mark - Method Swizzling

- (void)new_viewWillAppear:(BOOL)animated {
    [self new_viewWillAppear:animated];
    NSLog(@"%@",NSStringFromClass([self class]));
}
@end
