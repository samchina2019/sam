//
//  JiFenHistoryPageViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiFenHistoryPageViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "JiFenHistoryListViewController.h"

@interface JiFenHistoryPageViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation JiFenHistoryPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"积分交易记录";
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.titleArray = @[@"收入",@"支出"];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:15];
    self.titleView.indicatorExtension = -8;
    self.titleView.indicatorColor = TabbarColor;
    [self.view addSubview:self.titleView];
    
    _viewControllers = [NSMutableArray array];
    
    JiFenHistoryListViewController *vc1 = [[JiFenHistoryListViewController alloc]init];
    vc1.title = self.titleArray[0];
    vc1.isShouRu = YES;
    [self.viewControllers addObject:vc1];
    JiFenHistoryListViewController *vc2 = [[JiFenHistoryListViewController alloc]init];
    vc2.title = self.titleArray[1];
    vc2.isShouRu = NO;
    [self.viewControllers addObject:vc2];
    
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
