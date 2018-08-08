//
//  TestViewController5.m
//  QLPageViewController
//
//  Created by 梁啟林 on 2018/8/8.
//  Copyright © 2018年 liangqilin. All rights reserved.
//

#import "TestViewController5.h"

#define kRandomColor ([UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0f])

@interface TestViewController5 ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation TestViewController5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = kRandomColor;
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 170, self.view.bounds.size.width, 100)];
    _contentLabel.numberOfLines = 0;
    _contentLabel.textAlignment = NSTextAlignmentCenter;
    _contentLabel.backgroundColor = kRandomColor;
    _contentLabel.text = @"第 5 页";
    [self.view addSubview:_contentLabel];
    
    NSLog(@"viewDidLoad 第 5 页");
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear 第 5 页");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
