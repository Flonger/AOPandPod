/*******************************************************************************\
** Demo1Method:NSMutableArray+SafeArray.m
** Created by Flonger(xue@flonger.com) on 2018/8/31
**
**Copyright © 2018 Flonger. All rights reserved.
\*******************************************************************************/


#import "NSMutableArray+SafeArray.h"
#import <objc/runtime.h>
@implementation NSMutableArray (SafeArray)
+ (void)load{
    //避免程序员手贱调用load方法
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [[self class] swizzleMethod:@selector(addObject:) withMethod:@selector(safeAddObject:)];
        [[self class] swizzleMethod:@selector(objectAtIndex:) withMethod:@selector(safeObjectAtIndex:)];
        [[self class] swizzleMethod:@selector(insertObject:atIndex:) withMethod:@selector(safeInsertObject:atIndex:)];
        [[self class] swizzleMethod:@selector(removeObjectAtIndex:) withMethod:@selector(safeRemoveObjectAtIndex:)];
        [[self class] swizzleMethod:@selector(replaceObjectAtIndex:withObject:) withMethod:@selector(safeReplaceObjectAtIndex:withObject:)];
        NSLog(@"%@ %@", @"SafeArray", [self class]);
    });
}
+ (void)swizzleMethod:(SEL)origSelector
           withMethod:(SEL)newSelector {
    Class class = NSClassFromString(@"__NSArrayM");
    
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

#pragma mark - method
- (void)safeAddObject:(id)anObject {
    //do safe operate
    if (anObject) {
//        NSLog(@"safeAddObject:");
        [self safeAddObject:anObject];
    } else {
        NSLog(@"safeAddObject: anObject is nil");
    }
}

- (id)safeObjectAtIndex:(NSInteger)index {
    //do safe operate
    if (index >= 0 && index <= self.count) {
        return [self safeObjectAtIndex:index];
    }
    NSLog(@"safeObjectAtIndex: index is invalid");
    return nil;
}

- (void)safeInsertObject:(id)anObject
                 atIndex:(NSInteger)index {
    //do safe operate
    if (anObject && index >= 0 && index <= self.count) {
        [self safeInsertObject:anObject atIndex:index];
    } else {
        NSLog(@"safeInsertObject:atIndex: anObject or index is invalid");
    }
}

- (void)safeRemoveObjectAtIndex:(NSInteger)index {
    //do safe operate
    if (index >= 0 && index <= self.count) {
        [self safeRemoveObjectAtIndex:index];
    } else {
        NSLog(@"safeRemoveObjectAtIndex: index is invalid");
    }
}

- (void)safeReplaceObjectAtIndex:(NSInteger)index
                      withObject:(id)anObject {
    //do safe operate
    if (anObject && index >= 0 && index <= self.count) {
        [self safeReplaceObjectAtIndex:index withObject:anObject];
    } else {
        NSLog(@"safeReplaceObjectAtIndex:withObject: anObject or index is invalid");
    }
}



@end
