//
//  ViewController.m
//  QLPageViewController
//
//  Created by 梁啟林 on 2018/8/7.
//  Copyright © 2018年 liangqilin. All rights reserved.
//

#import "ViewController.h"
#import "QLPageView.h"


#import "ContentViewController.h"

#import "TestViewController1.h"
#import "TestViewController2.h"
#import "TestViewController3.h"
#import "TestViewController4.h"
#import "TestViewController5.h"
#import "TestViewController6.h"


#define KIsiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)



@interface ViewController () <QLPageViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"demo";
    
    [self setupViews];
}

- (void)setupViews{
    NSArray *vcs = @[[[TestViewController1 alloc] init],
                     [[TestViewController2 alloc] init],
                     [[TestViewController3 alloc] init],
                     [[TestViewController4 alloc] init],
                     [[TestViewController5 alloc] init],
                     [[TestViewController6 alloc] init]];
    NSArray *titles = @[@"第一页", @"第二页", @"3", @"第4444444444页", @"第5页", @"第六页"];
    
    CGFloat y = KIsiPhoneX ? 88 : 64;
    //同样的页面跟换数据源的话，直接循环
    QLPageView *toolView = [[QLPageView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - 64) viewControllers:vcs titles:titles];
    toolView.mDelegate = self;
    
    toolView.itemNormalColor = [UIColor blackColor];
    toolView.itemSelectedColor = [UIColor redColor];
    toolView.hideShadow = NO;
//    toolView.selectedIndex = 3;
    
    [toolView showInViewController:self];
}

#pragma mark - QLPageViewDelegate
- (void)selectedPageOfIndex:(NSInteger)index{
    NSLog(@"selected   %ld", index);
    
    NSLog(@"%.1f, %.1f", [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
}


@end
