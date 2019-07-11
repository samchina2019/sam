//
//  MyZuJiPageViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyZuJiPageViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "GoodsBrowseHistoryListViewController.h"
#import "StoreBrowseHistoryListViewController.h"
#import "ServerBrowseHistoryListViewController.h"

@interface MyZuJiPageViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;

@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;

@end

@implementation MyZuJiPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"我的足迹";
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"批量删除" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarItemClick:)];
    
    self.navigationItem.rightBarButtonItem = item;
    
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeashClick:) name:@"shanpinData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeashClick:) name:@"dianpuData" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refeashClick:) name:@"fuwuData" object:nil];
    
    [self loadTitleView];
}
#pragma mark – UI
-(void)loadTitleView{
    self.titleArray = @[@"商品浏览",@"店铺浏览",@"服务浏览"];
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 40) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:15];
    self.titleView.indicatorExtension = -8;
    self.titleView.indicatorColor = TabbarColor;
    [self.view addSubview:self.titleView];
    
    _viewControllers = [NSMutableArray array];
    
    GoodsBrowseHistoryListViewController *vc1 = [[GoodsBrowseHistoryListViewController alloc]init];
    vc1.title = self.titleArray[0];
    [self.viewControllers addObject:vc1];
    StoreBrowseHistoryListViewController *vc2 = [[StoreBrowseHistoryListViewController alloc]init];
    vc2.title = self.titleArray[1];
    [self.viewControllers addObject:vc2];
    ServerBrowseHistoryListViewController *vc3 = [[ServerBrowseHistoryListViewController alloc]init];
    vc3.title = self.titleArray[2];
    [self.viewControllers addObject:vc3];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 40, ViewWidth, ViewHeight - NavAndStatusHight - 40) childVCs:self.viewControllers parentVC:self delegate:self];
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


#pragma mark - Function

-(void)refeashClick:(NSNotification *)noti{
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    [self.navigationItem.rightBarButtonItem setTitle:dic[@"title"]];
    [self.view layoutIfNeeded];
}
-(void)rightBarItemClick:(UIBarButtonItem *)item{
    
    NSDictionary *dict=@{
                         @"item":item.title
                         };
    if ([item.title isEqualToString:@"批量删除"]) {
        
         item.title = @"取消";
        
    }else{
        
         item.title = @"批量删除";
    }
     [[NSNotificationCenter defaultCenter] postNotificationName:@"shangpinchu" object:nil userInfo:dict];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"dianpuchu" object:nil userInfo:dict];
     [[NSNotificationCenter defaultCenter] postNotificationName:@"fuwuchu" object:nil userInfo:dict];
}


@end
