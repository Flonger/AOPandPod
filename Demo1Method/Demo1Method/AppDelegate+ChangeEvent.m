/*******************************************************************************\
** Demo1Method:AppDelegate+ChangeEvent.m
** Created by Flonger(xue@flonger.com) on 2018/8/31
**
**Copyright © 2018 Flonger. All rights reserved.
\*******************************************************************************/


#import "AppDelegate+ChangeEvent.h"
#import "Aspects.h"

typedef void (^AspectHandlerBlock)(id<AspectInfo> aspectInfo);
@implementation AppDelegate (ChangeEvent)

- (void)setEvent{
    NSDictionary *configs = @{
                              @"ViewController": @{
                                      @"HookEvents": @[
                                              @{
                                                  @"EventName": @"btn",
                                                  @"EventSelectorName": @"btnClick",
                                                  @"EventHandlerBlock": ^(id<AspectInfo> aspectInfo) {
                                                      dispatch_async(dispatch_get_main_queue(), ^{
                                                          UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Waring"
                                                                                                          message:@"我是交换方法的点击"
                                                                                                         delegate:nil
                                                                                                cancelButtonTitle:@"OK"
                                                                                                otherButtonTitles:nil, nil];
                                                          [alert show];
                                                      });
                                                      
                                                      
                                                  },
                                                  },
                                              ],
                                      },
                              };
    
    for (NSString * className in configs) {
        Class class = NSClassFromString(className);
        NSDictionary *config = configs[className];
        if (config[@"HookEvents"]) {
            for (NSDictionary *event in config[@"HookEvents"]) {
                SEL selekor = NSSelectorFromString(event[@"EventSelectorName"]);
                AspectHandlerBlock block = event[@"EventHandlerBlock"];
                
                [class aspect_hookSelector:selekor
                               withOptions:AspectPositionInstead
                                usingBlock:^(id<AspectInfo> aspectInfo) {
                                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                        block(aspectInfo);
                                    });
                                } error:NULL];
                
            }
        }
    }
    
}



@end
