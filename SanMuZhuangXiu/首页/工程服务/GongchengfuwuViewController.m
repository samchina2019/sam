//
//  GongchengfuwuViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GongchengfuwuViewController.h"
#import "ChaichuFuwuViewController.h"
#import "GongChengFuWuCell.h"
#import "WebViewViewController.h"
#import "FalvListViewController.h"

@interface GongchengfuwuViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation GongchengfuwuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title=@"工程服务";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"GongChengFuWuCell" bundle:nil] forCellReuseIdentifier:@"GongChengFuWuCell"];
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
   
    [DZNetworkingTool postWithUrl:kGongChengFuWuHome params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *dict = responseObject[@"data"];
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:responseObject[@"data"]];
            [self.tableView reloadData];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
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
    GongChengFuWuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GongChengFuWuCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    cell.nameLabel.text = dict[@"name"];
    cell.array = dict[@"list"];
    cell.block = ^(int fabuID, NSString * _Nonnull fabuName) {
        if ([fabuName isEqualToString:@"相关法律"]) {
            self.hidesBottomBarWhenPushed = YES;
            FalvListViewController *viewController=[[FalvListViewController alloc]init];
            viewController.keywords = @"law";
            viewController.title = fabuName;
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if ([fabuName isEqualToString:@"验收标准"]) {
            self.hidesBottomBarWhenPushed = YES;
            FalvListViewController *viewController=[[FalvListViewController alloc]init];
            viewController.keywords = @"acceptance_criteria";
            viewController.title = fabuName;
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else if ([fabuName isEqualToString:@"施工工艺"]) {
            self.hidesBottomBarWhenPushed = YES;
            FalvListViewController *viewController=[[FalvListViewController alloc]init];
            viewController.keywords = @"construction_technology";
            viewController.title = fabuName;
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }else {
            self.hidesBottomBarWhenPushed = YES;
            ChaichuFuwuViewController *chaichuViewController=[[ChaichuFuwuViewController alloc]init];
            chaichuViewController.fuwuId =fabuID;
            chaichuViewController.fuwuName = fabuName;
            [self.navigationController pushViewController:chaichuViewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

@end
