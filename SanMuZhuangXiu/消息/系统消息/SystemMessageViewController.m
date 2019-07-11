//
//  SystemMessageViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SystemMessageViewController.h"
#import "SystemMessageListCell.h"

@interface SystemMessageViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation SystemMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarItem.badgeValue = nil;
    // Do any additional setup after loading the view from its nib.
    switch (_type) {//1.系统消息2.考勤消息3.物流消息
        case 3:
        {
            self.navigationItem.title = @"系统消息";
        }
            break;
        case 4:
        {
            self.navigationItem.title = @"考勤消息";
        }
            break;
        case 5:
        {
            self.navigationItem.title = @"物流消息";
        }
            break;
        default:
            break;
    }
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 180;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"SystemMessageListCell" bundle:nil] forCellReuseIdentifier:@"SystemMessageListCell"];
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
    NSDictionary *params = @{@"type":@(self.type),
                             @"page":@(_page),
                             @"limit":@(20)};
    [DZNetworkingTool postWithUrl:kXiaoXiHomeDetail params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
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
    SystemMessageListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SystemMessageListCell" forIndexPath:indexPath];
    NSDictionary *dict = self.dataArray[indexPath.row];
    // 时间戳 -> NSDate *
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"createtime"] intValue]];
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:date];
    cell.timeLabel.text = [NSString stringWithFormat:@"  %@  ", timeStr];
    cell.titleLabel.text = dict[@"title"];
    cell.contentLabel.text = dict[@"content"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
