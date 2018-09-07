/*******************************************************************************\
** Demo1Method:NSInvocation+Extension.h
** Created by Flonger(xue@flonger.com) on 2018/9/7
**
**Copyright © 2018 Flonger. All rights reserved.
\*******************************************************************************/


#import <Foundation/Foundation.h>

@interface NSInvocation (Extension)
@property (nonatomic, strong) id returnValue_obj;

@property (nonatomic, copy) NSArray *arguments;

- (void)setMyArgument:(id)obj atIndex:(NSInteger)argumentIndex;
- (id)myArgumentAtIndex:(NSUInteger)index;
@end
