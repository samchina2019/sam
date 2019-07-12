//
//  MyPublishPageViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyPublishPageViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "WorkFabujiluController.h"
#import "FabujiluViewController.h"
#import "QiyeFabujiluViewController.h"
#import "MyFabuListViewController.h"

@interface MyPublishPageViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MyPublishPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的发布";
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.titleArray = @[@"工地找工人",@"工人找工作",@"企业招聘",@"员工求职",@"工程服务"];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:15];
    self.titleView.indicatorExtension = -8;
    self.titleView.indicatorColor = TabbarColor;
    [self.view addSubview:self.titleView];
    
    _viewControllers = [NSMutableArray array];
    
    WorkFabujiluController *vc1 = [[WorkFabujiluController alloc]init];
    vc1.title = self.titleArray[0];
    [self.viewControllers addObject:vc1];
    FabujiluViewController *vc2 = [[FabujiluViewController alloc]init];
    vc2.title = self.titleArray[1];
    [self.viewControllers addObject:vc2];
    QiyeFabujiluViewController *vc3 = [[QiyeFabujiluViewController alloc]init];
    vc3.title = self.titleArray[2];
    [self.viewControllers addObject:vc3];
    FabujiluViewController *vc4 = [[FabujiluViewController alloc]init];
    vc4.title = self.titleArray[3];
    vc4.isqiuzhi = YES;
    [self.viewControllers addObject:vc4];
    MyFabuListViewController *vc5=[[MyFabuListViewController alloc]init];
    vc5.fuwuId = 0;
    vc5.title = self.titleArray[4];
    [self.viewControllers addObject:vc5];
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0,  40, ViewWidth, ViewHeight - NavAndStatusHight - 40) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
    
    self.titleView.selectIndex = 0;
    self.pageContentView.contentViewCurrentIndex = 0;
}
#pragma mark - FSPageContentViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}
#pragma mark - FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}

@end
