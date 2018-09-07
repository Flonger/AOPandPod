//
//  AspectsHook.m
//  Demo1Method
//
//  Created by 薛飞龙 on 2018/9/6.
//Copyright © 2018 Flonger. All rights reserved.
//

#import "AspectsHook.h"
#import "NSInvocation+Extension.h"
@implementation AspectsHook

+ (JSContext *)context{
    static JSContext *context;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        context = [[JSContext alloc] init];
    });
    return context;
    
}

+ (void)hook{
    
    JSContext * context = [self context];
    context[@"hookMethod"] = ^(NSString *className, NSString *selectorName, AspectOptions options, JSValue * value){
        [self hookWithClassName:className selector:selectorName options:options value:value];
    };
    context[@"hookClassMethod"] = ^id(NSString * className, NSString *selectorName, id arguments) {
        id obj = [self hookMethodWithClassname:className selector:selectorName arguments:arguments];
        return obj;
    };
    context[@"hookInstanceMethod"] = ^id(id instance, NSString *selectorName, id arguments) {
        id obj = [self hookMethodWithInstance:instance selector:selectorName arguments:arguments];
        return obj;
    };
}

+ (id)getJSString:(NSString *)jsString
{
    if (jsString == nil || jsString == (id)[NSNull null] || ![jsString isKindOfClass:[NSString class]]) return nil;
    JSValue *jsValue = [[self context] evaluateScript:jsString];
    id obj = jsValue.toObject;
    if (obj) {
        return obj;
    } else {
        return nil;
    }
}

+ (void)hookWithClassName:(NSString *)className selector:(NSString *)selectorName options:(AspectOptions)options value:(JSValue *)value{
    Class cla = NSClassFromString(className);
    SEL sel = NSSelectorFromString(selectorName);
    [cla aspect_hookSelector:sel
                 withOptions:options
                  usingBlock:^(id<AspectInfo>aspectInfo){
                      NSLog(@"我是Hook方法");
                      [value callWithArguments:@[aspectInfo.instance,aspectInfo.originalInvocation,aspectInfo.arguments]];
                  }
                       error:nil];
}

+ (id)hookMethodWithClassname:(NSString *)className selector:(NSString *)selectorName arguments:(NSArray *)arguments
{
    
    Class cla = NSClassFromString(className);
    SEL sel = NSSelectorFromString(selectorName);
    //判断是类方法还是实例方法
    if ([cla instancesRespondToSelector:sel]) {
        id instance = [[cla alloc] init];
        NSMethodSignature *signature = [instance methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = sel;
        invocation.arguments = arguments;
        [invocation invokeWithTarget:instance];
        return invocation.returnValue_obj;
    }else if ([cla respondsToSelector:sel]){
        NSMethodSignature *signature = [cla methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
        invocation.selector = sel;
        invocation.arguments = arguments;
        [invocation invokeWithTarget:cla];
        return invocation.returnValue_obj;
    }else{
        return nil;
    }
}
+ (id)hookMethodWithInstance:(id)instance selector:(NSString *)selectorName arguments:(NSArray *)arguments
{
    if (!instance) {
        return nil;
    }
    if (arguments && [arguments isKindOfClass:NSArray.class] == NO) {
        arguments = @[arguments];
    }
    SEL sel = NSSelectorFromString(selectorName);
    
    if ([instance isKindOfClass:JSValue.class]) {
        instance = [instance toObject];
    }
    NSMethodSignature *signature = [instance methodSignatureForSelector:sel];
    if (!signature) {
        return nil;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.selector = sel;
    invocation.arguments = arguments;
    [invocation invokeWithTarget:instance];
    return invocation.returnValue_obj;
}

@end
