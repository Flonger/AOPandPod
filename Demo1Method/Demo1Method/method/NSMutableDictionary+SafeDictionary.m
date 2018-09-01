/*******************************************************************************\
** Demo1Method:NSMutableDictionary+SafeDictionary.m
** Created by Flonger(xue@flonger.com) on 2018/8/31
**
**Copyright © 2018 Flonger. All rights reserved.
\*******************************************************************************/


#import "NSMutableDictionary+SafeDictionary.h"
#import <objc/runtime.h>
@implementation NSMutableDictionary (SafeDictionary)
+ (void)load{
    //避免程序员手贱调用load方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleMethod:@selector(setObject:forKey:) withMethod:@selector(SafeSetObject:forKey:)];
        NSLog(@"%@ %@", @"SafeDictionary", [self class]);
    });
}
+ (void)swizzleMethod:(SEL)origSelector
           withMethod:(SEL)newSelector {
    //注意此处获取的并不是NSMutableDictionary而是__NSDictionaryM
    //同理NSMutableArray获取的Class是__NSArrayM
    Class class = NSClassFromString(@"__NSDictionaryM");
    
    Method originalMethod = class_getInstanceMethod(class, origSelector);
    Method swizzledMethod = class_getInstanceMethod(class, newSelector);
    
    BOOL didAddMethod = class_addMethod(class,
                                        origSelector,
                                        method_getImplementation(swizzledMethod),
                                        method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        class_replaceMethod(class,
                            newSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
- (void)SafeSetObject:(id)anObject forKey:(id)key
{
    if (anObject) {
//        NSLog(@"safe");
        [self SafeSetObject:anObject forKey:key];
    }else{
        NSLog(@"SafeSetObject:forKey: anObject is nil");
    }
}
@end
