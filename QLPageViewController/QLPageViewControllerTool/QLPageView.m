//
//  QLPageView.m
//  QLPageViewController
//
//  Created by 梁啟林 on 2018/8/7.
//  Copyright © 2018年 liangqilin. All rights reserved.
//

#import "QLPageView.h"
#import "QLCollectionViewCell.h"

//item间隔
static const CGFloat ItemMargin = 30.0f;
//标题选中大小
static const CGFloat ItemFontSize = 14.0f;
//最大放大倍数
static const CGFloat ItemMaxScale = 1.05;
//上面的collectionView高度
static const CGFloat collectionViewH = 45;


@interface QLPageView () <UIPageViewControllerDelegate, UIPageViewControllerDataSource, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *titleCollectionView;
@property (nonatomic, strong) UIPageViewController *pageVC;//分页滚动视图控制器

@property (nonatomic, strong) UIView *bottomLine;// 标题和页面之间的分割线
@property (nonatomic, strong) UIView *shadow;// 阴影

// 下划线-滚动条(用collectionView来做标题暂时没法准确跟踪frame，在scrollView上加button的方式可以)
//@property (nonatomic, strong) UIView *sliderView;

@property (nonatomic, strong) NSArray <UIViewController *>* viewControllers;//控制器数组
@property (nonatomic, strong) NSArray <NSString *>* titles;//标题数组

@property (nonatomic, assign) CGFloat progress;//滑动的进度
@property (nonatomic, assign) BOOL ignoreAnimation;//忽略动画

@end

@implementation QLPageView

- (instancetype)initWithFrame:(CGRect)frame viewControllers:(NSArray <UIViewController *>*)viewControllers titles:(NSArray <NSString *>*)titles{
    if (self = [super initWithFrame:frame]) {
        self.viewControllers = viewControllers;
        self.titles = titles;
        
        [self buildUI];
    }
    return self;
}

- (void)buildUI{
    //标题collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = ItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, ItemMargin, 0, ItemMargin);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _titleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, collectionViewH) collectionViewLayout:layout];
    _titleCollectionView.delegate = self;
    _titleCollectionView.dataSource = self;
    _titleCollectionView.backgroundColor = [UIColor whiteColor];
    [_titleCollectionView registerClass:[QLCollectionViewCell class] forCellWithReuseIdentifier:@"QLCollectionViewCell"];
    _titleCollectionView.showsHorizontalScrollIndicator = false;
    [self addSubview:_titleCollectionView];
    
    //阴影
    _shadow = [[UIView alloc] init];
    [_titleCollectionView addSubview:_shadow];
    
    //分割线
    _bottomLine = [UIView new];
    _bottomLine.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1];
    _bottomLine.frame = CGRectMake(0, _titleCollectionView.bounds.size.height - 0.5, self.bounds.size.width, 0.5);
    [self addSubview:_bottomLine];

    
    //内容pageViewController
    _pageVC = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    _pageVC.view.frame = CGRectMake(0, collectionViewH, self.bounds.size.width, self.bounds.size.height - collectionViewH);
    [_pageVC setViewControllers:@[self.viewControllers.firstObject] direction:UIPageViewControllerNavigationDirectionReverse animated:NO completion:nil];
    [self addSubview:_pageVC.view];
    
    //设置ScrollView代理，pageViewController内部自带的
    for (UIScrollView *scrollView in _pageVC.view.subviews) {
        if ([scrollView isKindOfClass:[UIScrollView class]]) {
            scrollView.delegate = self;
        }
    }
}

- (void)showInViewController:(UIViewController *)viewController {
    [viewController addChildViewController:_pageVC];
    [viewController.view addSubview:self];
}

#pragma mark layoutSubviews

- (void)layoutSubviews {
    [super layoutSubviews];
    //如果标题过少 自动居中
    __block typeof(self) weakSelf = self;
    [_titleCollectionView performBatchUpdates:nil completion:^(BOOL finished) {
        if (weakSelf.titleCollectionView.contentSize.width < weakSelf.titleCollectionView.bounds.size.width) {
            CGFloat insetX = (weakSelf.titleCollectionView.bounds.size.width - weakSelf.titleCollectionView.contentSize.width)/2.0f;
            weakSelf.titleCollectionView.contentInset = UIEdgeInsetsMake(0, insetX, 0, insetX);
        }
    }];
    
    //设置阴影
    _shadow.backgroundColor = _itemSelectedColor;
    _shadow.hidden = _hideShadow;
    
    //初始化选中位置 没设置的话默认为0
    self.selectedIndex = _selectedIndex;
}

#pragma mark - UIPageViewControllerDataSource & UIPageViewControllerDelegate
#pragma mark 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;
    // 返回的ViewController，将被添加到相应的UIPageViewController对象上。
    // UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
    // 不用我们去操心每个ViewController的顺序问题
    return _viewControllers[index];
    
}

#pragma mark 返回下一个ViewController对象

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.viewControllers count]) {
        return nil;
    }
    
    return _viewControllers[index];
}

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    NSUInteger index = [_viewControllers indexOfObject:pageViewController.viewControllers.firstObject];
    self.selectedIndex = index;
}

#pragma mark - UIScrollViewDelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (!scrollView.isDragging) {
        return;
    }
    if (scrollView.contentOffset.x == scrollView.bounds.size.width) {return;}
    CGFloat progress = scrollView.contentOffset.x/scrollView.bounds.size.width;
    self.progress = progress;
}

//手动设置滑动(偏移)的时候执行这个方法，判断这个时候肯定是点击标题切换的页面，不用执行阴影动画
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    _ignoreAnimation = false;
}

#pragma mark - UICollectionViewDelegate & UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    QLCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"QLCollectionViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _titles[indexPath.row];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:ItemFontSize];
    
    CGFloat scale = indexPath.row == _selectedIndex ? ItemMaxScale : 1;
    cell.transform = CGAffineTransformMakeScale(scale, scale);
    
    cell.textLabel.textColor = indexPath.row == _selectedIndex ? _itemSelectedColor : _itemNormalColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self itemWidthOfIndexPath:indexPath], _titleCollectionView.bounds.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    _ignoreAnimation = true;
}

#pragma mark 获取文字宽度
- (CGFloat)itemWidthOfIndexPath:(NSIndexPath*)indexPath {
    NSString *title = _titles[indexPath.row];
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineBreakMode:NSLineBreakByTruncatingTail];
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont boldSystemFontOfSize:ItemFontSize], NSParagraphStyleAttributeName : style };
    CGSize textSize = [title boundingRectWithSize:CGSizeMake(self.bounds.size.width, self.bounds.size.height)
                                          options:opts
                                       attributes:attributes
                                          context:nil].size;
    return textSize.width;
}

#pragma mark 根据当前选中item的frame配置相关frame
- (CGRect)shadowRectOfIndex:(NSInteger)index {
    return CGRectMake([_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0]].frame.origin.x, self.bounds.size.height - 2, [self itemWidthOfIndexPath:[NSIndexPath indexPathForRow:index inSection:0]], 2);
}

#pragma mark -
#pragma mark Setter 用于赋值触发更新
- (void)setSelectedIndex:(NSInteger)selectedIndex {
    //联动page
    [_pageVC setViewControllers:@[self.viewControllers[selectedIndex]] direction:selectedIndex < _selectedIndex animated:YES completion:^(BOOL finished) {
        
    }];
    
    _selectedIndex = selectedIndex;
    
    //更新阴影位置（延迟是为了避免cell不在屏幕上显示时，造成的获取frame失败问题）
    CGFloat rectX = [self shadowRectOfIndex:_selectedIndex].origin.x;
    __weak typeof(self) weakSelf = self;
    if (rectX <= 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.25 * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
            weakSelf.shadow.frame = [self shadowRectOfIndex:weakSelf.selectedIndex];
        });
    }else{
        _shadow.frame = [self shadowRectOfIndex:_selectedIndex];
    }
    
    //居中滚动标题
    [_titleCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:true];
    
    //更新字体大小
    [_titleCollectionView reloadData];
    
    //执行代理方法
    if (_mDelegate && [_mDelegate respondsToSelector:@selector(selectedPageOfIndex:)]) {
        [_mDelegate selectedPageOfIndex:selectedIndex];
    }
}

//更新阴影位置
- (void)setProgress:(CGFloat)progress {
    _progress = progress;
    //如果手动点击则不执行以下动画
    if (_ignoreAnimation) {
        return;
    }
    //更新阴影位置
    [self updateShadowPosition:progress];
    //更新标题颜色、大小
    [self updateItem:progress];
}

#pragma mark -
#pragma mark 执行阴影过渡动画
//更新阴影位置
- (void)updateShadowPosition:(CGFloat)progress {
    
    //progress > 1 向左滑动表格反之向右滑动表格
    NSInteger nextIndex = progress > 1 ? _selectedIndex + 1 : _selectedIndex - 1;
    if (nextIndex < 0 || nextIndex == _titles.count) {return;}
    //获取当前阴影位置
    CGRect currentRect = [self shadowRectOfIndex:_selectedIndex];
    CGRect nextRect = [self shadowRectOfIndex:nextIndex];
    //如果在此时cell不在屏幕上 则不显示动画
    if (CGRectGetMinX(currentRect) <= 0 || CGRectGetMinX(nextRect) <= 0) {return;}
    
    progress = progress > 1 ? progress - 1 : 1 - progress;
    
    //更新宽度
    CGFloat width = currentRect.size.width + progress*(nextRect.size.width - currentRect.size.width);
    CGRect bounds = _shadow.bounds;
    bounds.size.width = width;
    _shadow.bounds = bounds;
    
    //更新位置
    CGFloat distance = CGRectGetMidX(nextRect) - CGRectGetMidX(currentRect);
    _shadow.center = CGPointMake(CGRectGetMidX(currentRect) + progress* distance, _shadow.center.y);
}

//更新标题颜色
- (void)updateItem:(CGFloat)progress {
    
    NSInteger nextIndex = progress > 1 ? _selectedIndex + 1 : _selectedIndex - 1;
    if (nextIndex < 0 || nextIndex == _titles.count) {return;}
    
    QLCollectionViewCell *currentItem = (QLCollectionViewCell *)[_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_selectedIndex inSection:0]];
    QLCollectionViewCell *nextItem = (QLCollectionViewCell *)[_titleCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:nextIndex inSection:0]];
    progress = progress > 1 ? progress - 1 : 1 - progress;
    
    //更新颜色
    currentItem.textLabel.textColor = [self transformFromColor:_itemSelectedColor toColor:_itemNormalColor progress:progress];
    nextItem.textLabel.textColor = [self transformFromColor:_itemNormalColor toColor:_itemSelectedColor progress:progress];
    
    //更新放大
    CGFloat currentItemScale = ItemMaxScale - (ItemMaxScale - 1) * progress;
    CGFloat nextItemScale = 1 + (ItemMaxScale - 1) * progress;
    currentItem.transform = CGAffineTransformMakeScale(currentItemScale, currentItemScale);
    nextItem.transform = CGAffineTransformMakeScale(nextItemScale, nextItemScale);
}

#pragma mark -
#pragma mark 更新颜色
- (UIColor *)transformFromColor:(UIColor*)fromColor toColor:(UIColor *)toColor progress:(CGFloat)progress {
    
    if (!fromColor || !toColor) {
        NSLog(@"Warning !!! color is nil");
        return [UIColor blackColor];
    }
    
    progress = progress >= 1 ? 1 : progress;
    
    progress = progress <= 0 ? 0 : progress;
    
    const CGFloat * fromeComponents = CGColorGetComponents(fromColor.CGColor);
    
    const CGFloat * toComponents = CGColorGetComponents(toColor.CGColor);
    
    size_t  fromColorNumber = CGColorGetNumberOfComponents(fromColor.CGColor);
    size_t  toColorNumber = CGColorGetNumberOfComponents(toColor.CGColor);
    
    if (fromColorNumber == 2) {
        CGFloat white = fromeComponents[0];
        fromColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        fromeComponents = CGColorGetComponents(fromColor.CGColor);
    }
    
    if (toColorNumber == 2) {
        CGFloat white = toComponents[0];
        toColor = [UIColor colorWithRed:white green:white blue:white alpha:1];
        toComponents = CGColorGetComponents(toColor.CGColor);
    }
    
    CGFloat red = fromeComponents[0]*(1 - progress) + toComponents[0]*progress;
    CGFloat green = fromeComponents[1]*(1 - progress) + toComponents[1]*progress;
    CGFloat blue = fromeComponents[2]*(1 - progress) + toComponents[2]*progress;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}

@end
