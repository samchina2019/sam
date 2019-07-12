//
//  MallSearchViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/15.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MallSearchViewController.h"
#import "StoreClassListCell.h"
#import "MallSellerList.h"

#import "StoreDetailViewController.h"

@interface MallSearchViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation MallSearchViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadBasicData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"搜索";
    
    self.dataArray = [NSMutableArray array];
    [self initTableView];
}
#pragma mark – UI

- (void)initTableView {
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreClassListCell" bundle:nil] forCellReuseIdentifier:@"StoreClassListCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark – Network
- (void)loadBasicData {

    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    //    kSearchStore
    NSDictionary *dict = @{
        @"search": self.wordStr,
        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        @"lat": [NSString stringWithFormat:@"%lf", latitude],
        @"page": @(1),
        @"row": @(20),
    };

    [DZNetworkingTool postWithUrl:kIndexStoreList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                NSArray *array = responseObject[@"data"][@"list"];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    MallSellerList *list = [MallSellerList mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:list];
                }
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //    return 5;

    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 145;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreClassListCell" forIndexPath:indexPath];
    MallSellerList *list = self.dataArray[indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, list.store_avatar]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.storeNameLabel.text = [NSString stringWithFormat:@"%@", list.seller_name];
    if (list.distance < 0) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"0km"];
    } else {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", (double) list.distance];
    }
    cell.starView.actualScore = list.level;
    cell.pingjiaLabel.text = [NSString stringWithFormat:@"%.f%%好评", list.ratio * 100];
    cell.yimaiLabel.text = [NSString stringWithFormat:@"%ld人已购买", list.order_count];
    cell.huodongLabel.text = [NSString stringWithFormat:@"满%ld减%ld", (long) list.man, (long) list.subtract];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    MallSellerList *list = self.dataArray[indexPath.row];
    StoreDetailViewController *viewController = [StoreDetailViewController new];
    viewController.seller_id = list.seller_id;
    viewController.storeName = list.seller_name;

    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTextField resignFirstResponder];
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSString *searchStr = self.searchTextField.text;
    if (searchStr.length == 0) {
        [DZTools showNOHud:@"关键字不能为空！" delay:2.0];

    } else {
        NSDictionary *params = @{
            @"search": searchStr,
            @"lng": [NSString stringWithFormat:@"%lf", longitude],
            @"lat": [NSString stringWithFormat:@"%lf", latitude],
            @"page": @(1),
            @"row": @(20),
        };
        [DZNetworkingTool postWithUrl:kIndexStoreList
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if (self.tableView.mj_footer.isRefreshing) {
                    [self.tableView.mj_footer endRefreshing];
                }
                if (self.tableView.mj_header.isRefreshing) {
                    [self.tableView.mj_header endRefreshing];
                }
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSDictionary *dict = responseObject[@"data"];

                    NSArray *array = dict[@"list"];
                    [self.dataArray removeAllObjects];
                    for (NSDictionary *dict in array) {
                        MallSellerList *list = [MallSellerList mj_objectWithKeyValues:dict];
                        [self.dataArray addObject:list];
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

    return YES;
}
@end
