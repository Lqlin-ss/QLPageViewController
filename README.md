# QLPageViewController
翻页滚动，类似头条那种，适合做新闻媒体或者订单类的页面

使用非常简单，把demo下载下来之后，把```QLPageViewControllerTool```文件夹拖入你的工程。

在使用界面导入 ```#import "QLPageView.h"```

初始化
```
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
    
    //下面这几个属性自由选择是赋值
    toolView.itemNormalColor = [UIColor blackColor];
    toolView.itemSelectedColor = [UIColor redColor];
    toolView.hideShadow = NO;
    toolView.selectedIndex = 3;
    
    //这一句必须写
    [toolView showInViewController:self];
```

遵循代理并实现代理
```
#pragma mark - QLPageViewDelegate
- (void)selectedPageOfIndex:(NSInteger)index{
    NSLog(@"selected   %ld", index);
}
```

### 效果图
[](https://github.com/Lqlin-ss/QLPageViewController/blob/master/QQ20180808-143301.png)


