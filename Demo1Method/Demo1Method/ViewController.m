//
//  ViewController.m
//  Demo1Method
//
//  Created by 薛飞龙 on 2018/8/31.
//  Copyright © 2018 Flonger. All rights reserved.
//

#import "ViewController.h"
#import "Aspects.h"
#import "AspectsHook.h"

@interface ViewController ()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
//    [AspectsHook hookWithClassName:@"ViewController" selector:@"btnClick" options:AspectPositionBefore];
    
    [AspectsHook hook];
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"hookMethod" ofType:@"js"];
    NSString *jsString = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    [AspectsHook getJSString:jsString];
    
    //封装方法
    SEL selector = @selector(test2:);
    //初始化方法签名
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    //设置调用者
    invocation.target = self;
    //设置调用方法
    invocation.selector = selector;
    //设置参数
    NSString * object = @"hello it's invocation method";
    ////指定参数，以指针方式，并且第一个参数的起始index是2，因为index为0，1的分别是self和selector
    [invocation setArgument:&object atIndex:2];
    //调用方法
    [invocation invoke];
    
    //返回值，这里的处理比较复杂 具体请百度
    const char *returnType = signature.methodReturnType;
    id returnValue;
    NSUInteger length = [signature methodReturnLength];
    void *buffer = (void *)malloc(length);
    [invocation getReturnValue:buffer];
    returnValue = [NSValue valueWithBytes:buffer objCType:returnType];//returnType为@即为字符串
    void *ret;
    [invocation getReturnValue:&ret];
    NSLog(@"result=%@",(__bridge id)(ret));
    
}
- (void)btnClick{
    NSLog(@"正常点击");
}
- (UIButton *)btn{
    if (!_btn) {
        _btn = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn.frame = CGRectMake(100, 100, 100, 100);
        [_btn setTitle:@"点击" forState:(UIControlStateNormal)];
        [_btn setBackgroundColor:[UIColor blueColor]];
    }
    return _btn;
}

- (void)test{
    NSLog(@"我是js下发的代码调用");
}

- (NSString *)test2:(NSString *)str{
    NSLog(@"test2 : %@",str);
    return str;
}

@end
