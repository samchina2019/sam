//
//  MyPublishViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyPublishViewController.h"
#import "ServerBrowseHistoryListCell.h"
#import "MyPublishModel.h"

@interface MyPublishViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation MyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的发布";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServerBrowseHistoryListCell" bundle:nil] forCellReuseIdentifier:@"ServerBrowseHistoryListCell"];
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
        NSDictionary *params = @{
                                 @"row":@(10),
                                 @"page":@(_page)};
        [DZNetworkingTool postWithUrl:kMyServerList params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if(isRefresh){
                [self.dataArray removeAllObjects];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"][@"list"];
               
                for (NSDictionary *dict in array) {
                    MyPublishModel *model=[MyPublishModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            }else
            {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
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
#pragma mark--tableview deleteGate
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServerBrowseHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServerBrowseHistoryListCell" forIndexPath:indexPath];
    MyPublishModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text=[NSString stringWithFormat:@"%@",model.name];
    
    if ([model.type isEqualToString:@"1"]) {
        if (model.address.length==0) {
              cell.serverLabel.text=[NSString stringWithFormat:@"工地找人"];
        }else{
             cell.serverLabel.text=[NSString stringWithFormat:@"工地找人(%@)",model.address];
        }
        
    }else if ([model.type isEqualToString:@"2"]){
        if (model.address.length==0) {
            cell.serverLabel.text=[NSString stringWithFormat:@"工人找工作"];
        }else{
            cell.serverLabel.text=[NSString stringWithFormat:@"工人找工作(%@)",model.address];
        }
        
    }else if ([model.type isEqualToString:@"3"]){
        if (model.address.length==0) {
            cell.serverLabel.text=[NSString stringWithFormat:@"企业招聘"];
        }else{
            cell.serverLabel.text=[NSString stringWithFormat:@"企业招聘(%@)",model.address];
        }
      
    }else if ([model.type isEqualToString:@"4"]){
        if (model.address.length==0) {
            cell.serverLabel.text=[NSString stringWithFormat:@"员工求职"];
        }else{
            cell.serverLabel.text=[NSString stringWithFormat:@"员工求职(%@)",model.address];
        }
       
    }else if ([model.type isEqualToString:@"5"]){
        if (model.address.length==0) {
            cell.serverLabel.text=[NSString stringWithFormat:@"工程服务"];
        }else{
            cell.serverLabel.text=[NSString stringWithFormat:@"工程服务(%@)",model.address];
        }
    }
    // 时间戳 -> NSDate *
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.createtime];
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:date];
    cell.timeLabel.text = timeStr;
    if ([model.company isKindOfClass:[NSNull class]]) {
           cell.priceLabel.text=@"暂无价格";
    }else{
          cell.priceLabel.text=[NSString stringWithFormat:@"%@",model.company];
    }
  
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
