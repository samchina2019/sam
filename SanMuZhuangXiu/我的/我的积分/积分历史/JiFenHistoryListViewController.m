//
//  JiFenHistoryListViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiFenHistoryListViewController.h"
#import "TransactionRecordCell.h"
#import "JifenListModel.h"

@interface JiFenHistoryListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation JiFenHistoryListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"TransactionRecordCell" bundle:nil] forCellReuseIdentifier:@"TransactionRecordCell"];
    [self.tableView.mj_header beginRefreshing];
}
- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
 NSDictionary *params = @{ };
    if (self.isShouRu) {
        params = @{ @"page": @(_page),
                    @"type":@"add"
                    };
    }else{
        params = @{ @"page": @(_page),
                    @"type":@"sub"
                    };
    }
   
    [DZNetworkingTool postWithUrl:kCoinLogList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];
               
//                NSArray *listArray = dict[@"list"];
                for (NSDictionary *temp in array) {
                    JifenListModel *model = [JifenListModel mj_objectWithKeyValues:temp];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionRecordCell" forIndexPath:indexPath];
    JifenListModel *model = self.dataArray[indexPath.row];

    cell.timeLabel.text = model.createtime;
    cell.nameLabel.text = model.memo;
    cell.moneyLabel.text = [NSString stringWithFormat:@"%@", model.score];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
