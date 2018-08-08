//
//  QLPageView.h
//  QLPageViewController
//
//  Created by 梁啟林 on 2018/8/7.
//  Copyright © 2018年 liangqilin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QLPageViewDelegate <NSObject>

/**
 要显示的页面，手动滑动/直接选中标题切换 都会触发

 @param index 即将显示的页面是第index个
 */
- (void)selectedPageOfIndex:(NSInteger)index;

@end

@interface QLPageView : UIView

@property (nonatomic, assign) NSInteger selectedIndex;//!< 当前选中的位置 从0开始，第一页为0，没设置的话默认为0
@property (nonatomic, strong) UIColor *itemNormalColor;//!< 标题常规颜色
@property (nonatomic, strong) UIColor *itemSelectedColor;//!< 标题选中颜色
@property (nonatomic, strong) UIColor *sliderViewColor;//!< 下滑线颜色
@property (nonatomic, assign) BOOL hideShadow;//!< 是否显示标题和页面之间的分割线

@property (nonatomic, weak) id <QLPageViewDelegate> mDelegate;

/**
 初始化

 @param frame frame
 @param viewControllers 所有的页面
 @param titles 每个页面对应的标题（选项）
 @return 返回一个view实例
 */
- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray <UIViewController *>*)viewControllers titles:(NSArray <NSString *>*)titles;


/**
 这个方法其实就是把上面的实例（本工具）加载出来

 @param viewController 需要加载在哪个控制器上
 */
- (void)showInViewController:(UIViewController *)viewController;



@end
