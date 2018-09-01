//
//  ViewController.m
//  Demo1Method
//
//  Created by 薛飞龙 on 2018/8/31.
//  Copyright © 2018 Flonger. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()
@property (nonatomic, strong) UIButton *btn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.view addSubview:self.btn];
    [self.btn addTarget:self action:@selector(btnClick) forControlEvents:(UIControlEventTouchUpInside)];
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



@end
