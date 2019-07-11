//
//  MyOrderPageViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MyOrderPageViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "MyOrderListViewController.h"

@interface MyOrderPageViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSString *key;

@end

@implementation MyOrderPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的订单";
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.key = @"";

    self.titleArray = @[@"全部",@"待付款",@"待收货",@"已完成",@"已取消"];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:17];
    self.titleView.indicatorExtension = 2;
    self.titleView.indicatorColor = TabbarColor;
    [self.view addSubview:self.titleView];
    
    _viewControllers = [NSMutableArray array];
    
    for (int i = 0; i < self.titleArray.count; i++) {
        MyOrderListViewController *vc = [[MyOrderListViewController alloc]init];
                vc.title = self.titleArray[i];
                vc.type=i+1;

        [self.viewControllers addObject:vc];
    }
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0,  40, ViewWidth, ViewHeight - NavAndStatusHight - 40) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
    
    self.titleView.selectIndex = self.selectIndex;
    self.pageContentView.contentViewCurrentIndex = self.selectIndex;
    
//    UIImage *image = [UIImage imageNamed:@"icon_search"];
//    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image  style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClicked)];
}

#pragma mark - FSPageContentViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    MyOrderListViewController *vc = self.viewControllers[endIndex];
    [vc.tableView.mj_header beginRefreshing];
}
#pragma mark - FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    MyOrderListViewController *vc = self.viewControllers[endIndex];
    [vc.tableView.mj_header beginRefreshing];
}



@end
