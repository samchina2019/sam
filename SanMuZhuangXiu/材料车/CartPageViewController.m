//
//  CartPageViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CartPageViewController.h"
#import "CaiLiaoOrderViewController.h"
#import "CartViewController.h"
#import "GoodsDetailInfoViewController.h"
#import "PPBadgeView.h"

@interface CartPageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, strong) NSArray *pageContentArray;
@property (nonatomic, strong) UISegmentedControl *control;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) UILabel *numberLabel;
@end

@implementation CartPageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"xiaoxilaji" object:nil];
   
}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
///通知方法
- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.number = [dic[@"number"] intValue];
    
    [self.view layoutIfNeeded];

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = nil;

    self.nameArray = @[@"材料单",@"购物车"];
    [self initSelectButtonView];
    [self initPageViewController];
}

#pragma mark – UI

- (void)initSelectButtonView
{
    //导航条 布局
    _control = [[UISegmentedControl alloc]initWithItems:self.nameArray];
    _control.selectedSegmentIndex = 0;
    _control.tintColor = TabbarColor;
    _selectControlIndex = _control.selectedSegmentIndex;
    [_control addTarget:self action:@selector(changeSegment:) forControlEvents:UIControlEventValueChanged];
    //添加角标
    [[PPBadgeControl defaultBadge] setFont:[UIFont systemFontOfSize:8]];
    [[PPBadgeControl defaultBadge] setFlexMode:PPBadgeViewFlexModeMiddle];

    self.navigationItem.titleView = _control;
    [self.navigationItem.titleView pp_addBadgeWithNumber:self.number];
    [self.navigationItem.titleView pp_setBadgeHeight:10];
}
- (void)changeSegment:(UISegmentedControl*)tempControl
{
    if (tempControl.selectedSegmentIndex == _selectControlIndex) {
        return;
    }
    _selectControlIndex = tempControl.selectedSegmentIndex;
    [_pageViewController setViewControllers:@[_pageContentArray[_selectControlIndex]]
                                  direction:_selectControlIndex!=0? UIPageViewControllerNavigationDirectionForward : UIPageViewControllerNavigationDirectionReverse
                                   animated:YES
                                 completion:nil];
}

- (void)initPageViewController
{
    NSMutableArray *arrayM = [[NSMutableArray alloc] init];
    CaiLiaoOrderViewController *viewController1 = [CaiLiaoOrderViewController new];
    [arrayM addObject:viewController1];
    CartViewController *viewController2 = [CartViewController new];
    [arrayM addObject:viewController2];
    
    self.pageContentArray = [[NSArray alloc] initWithArray:arrayM];
    
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(UIPageViewControllerSpineLocationMid)};
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                          navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                        options:options];
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    _pageViewController.dataSource = nil;
    
    UIViewController *initialViewController =  [self viewControllerAtIndex:0];// 得到第一页
    
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.bounds;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}
#pragma mark - 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    index--;

    return [self viewControllerAtIndex:index];
}
#pragma mark - 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:viewController];
    if (index == NSNotFound) {
        return nil;
    }
    index++;
    if (index == [self.pageContentArray count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index];
}
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSUInteger index = [self presentationIndexForPageViewController:pageViewController];
    if (index == 1) {
        [_control setSelectedSegmentIndex:1];
//        self.tabBarItem.badgeValue = nil;
    }else{
        [_control setSelectedSegmentIndex:0];
    }
}
#pragma mark - 根据index得到对应的UIViewController
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (([self.pageContentArray count] == 0) || (index >= [self.pageContentArray count]))
    {
        return nil;
    }
    
    UIViewController *contentVC = _pageContentArray[index];
    return contentVC;
}
-(NSInteger)presentationIndexForPageViewController:
(UIPageViewController *)pageViewController
{
    UIViewController *currentVC = pageViewController.viewControllers[0];
    NSUInteger currentIndex = [self.pageContentArray indexOfObject:currentVC];
    return currentIndex;
}
- (NSUInteger)indexOfViewController:(UIViewController *)viewController {
    return [self.pageContentArray indexOfObject:viewController];
}

@end
