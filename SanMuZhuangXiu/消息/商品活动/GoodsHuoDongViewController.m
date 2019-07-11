//
//  GoodsHuoDongViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GoodsHuoDongViewController.h"
#import "GoodsHuoDongCell.h"

@interface GoodsHuoDongViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation GoodsHuoDongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"商品活动";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.rowHeight = 150;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"GoodsHuoDongCell" bundle:nil] forCellReuseIdentifier:@"GoodsHuoDongCell"];
    [self.tableView.mj_header beginRefreshing];
}
- (void)refresh
{
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
-(void)loadMore{
    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
//    NSDictionary *params = @{@"page":@(_page),
//                             @"limit":@(20)};
//    [DZNetworkingTool postWithUrl:kXiaoXiHomeDetail params:params success:^(NSURLSessionDataTask *task, id responseObject) {
//        if (self.tableView.mj_footer.isRefreshing) {
//            [self.tableView.mj_footer endRefreshing];
//        }
//        if (self.tableView.mj_header.isRefreshing) {
//            [self.tableView.mj_header endRefreshing];
//        }
//        if ([responseObject[@"code"] intValue] == SUCCESS) {
//            NSArray *array = responseObject[@"data"];
//            if (isRefresh) {
//                [self.dataArray removeAllObjects];
//            }
//            [self.dataArray addObjectsFromArray:array];
//            [self.tableView reloadData];
//        }else
//        {
//            [DZTools showNOHud:responseObject[@"msg"] delay:2];
//        }
//    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
//        if (self.tableView.mj_footer.isRefreshing) {
//            [self.tableView.mj_footer endRefreshing];
//        }
//        if (self.tableView.mj_header.isRefreshing) {
//            [self.tableView.mj_header endRefreshing];
//        }
//        [DZTools showNOHud:RequestServerError delay:2.0];
//    } IsNeedHub:NO];
    if (self.tableView.mj_footer.isRefreshing) {
        [self.tableView.mj_footer endRefreshing];
    }
    if (self.tableView.mj_header.isRefreshing) {
        [self.tableView.mj_header endRefreshing];
    }
//    [self.dataArray addObjectsFromArray:@[@"",@"",@""]];
    [self.tableView reloadData];
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.tableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsHuoDongCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GoodsHuoDongCell" forIndexPath:indexPath];
//    NSDictionary *dict = self.dataArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
