//
//  SoundReminderViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/26.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "SoundReminderViewController.h"
#import "SoundReminderCell.h"

@interface SoundReminderViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation SoundReminderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"声音提醒";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    [self.dataArray addObjectsFromArray:@[@{@"name":@"有人迟到了，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"有人早退了，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"有人离岗了，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"有人申请异常处理，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"签到成功",@"isOn":@"1"},
                                          @{@"name":@"签退成功",@"isOn":@"1"},
                                          @{@"name":@"您快要迟到了，请抓紧时间",@"isOn":@"1"},
                                          @{@"name":@"您已早退，请及时处理",@"isOn":@"0"},
                                          @{@"name":@"您已离岗，请及时处理",@"isOn":@"0"},
                                          @{@"name":@"您没有打卡，请及时处理",@"isOn":@"0"},
                                          @{@"name":@"信号断开，请关注打卡状态",@"isOn":@"0"}]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SoundReminderCell" bundle:nil] forCellReuseIdentifier:@"SoundReminderCell"];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self getDataArrayFromServerIsRefresh:YES];
    }];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    //    NSDictionary *params = @{@"uid":[User getUserID],
    //                             @"token":[User getToken],
    //                             @"p":@(_page)};
    //    [DZNetworkingTool postWithUrl:kMineMyFansURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
    //        if (self.tableView.mj_footer.isRefreshing) {
    //            [self.tableView.mj_footer endRefreshing];
    //        }
    //        if (self.tableView.mj_header.isRefreshing) {
    //            [self.tableView.mj_header endRefreshing];
    //        }
    //        if ([responseObject[@"code"] intValue] == SUCCESS) {
    //            NSDictionary *dict = responseObject[@"data"];
    //            if (isRefresh) {
    //                [self.dataArray removeAllObjects];
    //            }
    //            [self.dataArray addObjectsFromArray:dict[@"list"]];
    //            [self.tableView reloadData];
    //            if (self.dataArray.count == [dict[@"total"] intValue]) {
    //                [self.tableView.mj_footer endRefreshingWithNoMoreData];
    //            }
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
    if (isRefresh) {
        [self.dataArray removeAllObjects];
    }
    [self.dataArray addObjectsFromArray:@[@{@"name":@"有人迟到了，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"有人早退了，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"有人离岗了，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"有人申请异常处理，请及时关注",@"isOn":@"0"},
                                          @{@"name":@"签到成功",@"isOn":@"1"},
                                          @{@"name":@"签退成功",@"isOn":@"1"},
                                          @{@"name":@"您快要迟到了，请抓紧时间",@"isOn":@"1"},
                                          @{@"name":@"您已早退，请及时处理",@"isOn":@"0"},
                                          @{@"name":@"您已离岗，请及时处理",@"isOn":@"0"},
                                          @{@"name":@"您没有打卡，请及时处理",@"isOn":@"0"},
                                          @{@"name":@"信号断开，请关注打卡状态",@"isOn":@"0"}]];
    [self.tableView reloadData];
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 10 : 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SoundReminderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SoundReminderCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        cell.titleLabel.text = @"开关";
        cell.myswitch.on = NO;
    }else
    {
        NSDictionary *dict = self.dataArray[indexPath.row];
        cell.titleLabel.text = dict[@"name"];
        cell.myswitch.on = [dict[@"isOn"] boolValue];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
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
