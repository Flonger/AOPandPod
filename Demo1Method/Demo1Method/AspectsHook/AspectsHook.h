//
//  AspectsHook.h
//  Demo1Method
//
//  Created by 薛飞龙 on 2018/9/6.
//Copyright © 2018 Flonger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Aspects.h"
#import <JavaScriptCore/JavaScriptCore.h>

@interface AspectsHook : NSObject
+ (void)hook;
+ (JSContext *)context;
+ (id)getJSString:(NSString *)jsString;


@end
