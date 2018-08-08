# QLPageViewController
翻页滚动，类似头条那种，适合做新闻媒体或者订单类的页面

(声明：此工具在写的时候借鉴了别人的方法比如颜色渐变等，具体作者不详)

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
    QLPageView *toolView = [[QLPageView alloc] initWithFrame:CGRectMake(0, y, self.view.bounds.size.width, self.view.bounds.size.height - y) viewControllers:vcs titles:titles];
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

不需要居中的话只需要把这里注释掉
![](https://github.com/Lqlin-ss/QLPageViewController/blob/master/QQ20180808-143359.png)

写的时候分析附图，纠正一下，既然viewWillAppear每次执行，那么肯定比在scrollowView上面横向加多个viewController这种一次性全部加载的性能要好很多！
![](https://github.com/Lqlin-ss/QLPageViewController/blob/master/QQ20180807-154705.png)


### 效果图
![](https://github.com/Lqlin-ss/QLPageViewController/blob/master/QQ20180808-143301.png)


