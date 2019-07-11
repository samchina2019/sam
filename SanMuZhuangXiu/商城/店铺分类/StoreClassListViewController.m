//
//  StoreClassListViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreClassListViewController.h"
#import "ReLayoutButton.h"
#import "StoreClassListCell.h"
//#import "UITableView+JHNoData.h"
#import "StoreDetailViewController.h"
#import "CategoryListModel.h"
@interface StoreClassListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *classTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *tuiJianBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *distanceBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *haopinBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *starBtn;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;

@property (strong, nonatomic) NSMutableArray *classDataArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation StoreClassListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self getClassDataArrayFromServer];
    [self getClassDataArrayFromServer];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = self.title;

    self.classDataArray = [NSMutableArray arrayWithCapacity:0];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    /// tableView的刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreClassListCell" bundle:nil] forCellReuseIdentifier:@"StoreClassListCell"];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark – Network

- (void)getClassDataArrayFromServer {
    [DZNetworkingTool postWithUrl:kLitestoreIndex
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                if ([[responseObject objectForKey:@"data"][@"Categorylist"] isEqual:[NSNull null]]) {

                } else {
                    NSDictionary *dict = [responseObject objectForKey:@"data"];
                    NSArray *arr = [dict objectForKey:@"Categorylist"];
                    NSLog(@"-----------%@", dict);
                    [self.classDataArray removeAllObjects];
                    for (NSDictionary *dict in arr) {
                        CategoryListModel *model = [CategoryListModel mj_objectWithKeyValues:dict];

                        [self.classDataArray addObject:model];
                    }
                    [self.classTableView reloadData];
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
        @"page": @(_page),
        @"row": @(20),
        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        @"lat": [NSString stringWithFormat:@"%lf", latitude],
        @"type": @"default"
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
            if (isRefresh) {
                [self.dataArray removeAllObjects];
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
#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (self.searchTF.text.length == 0) {

        [DZTools showNOHud:@"关键字不能为空" delay:2];
    }

    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
        @"page": @(_page),
        @"row": @(20),
        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        @"lat": [NSString stringWithFormat:@"%lf", latitude],
        @"type": @"default",
        @"search": self.searchTF.text
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

                [self.dataArray removeAllObjects];

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

    return YES;
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.classTableView) {
        return self.classDataArray.count;
    } else {
        if (self.dataArray.count == 0) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.tableView.backgroundView = backgroundImageView;
            self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.tableView.backgroundView = nil;
        }
        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        return 44;
    } else {
        return 130;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        static NSString *cellIdentifier = @"classCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        CategoryListModel *model = self.classDataArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        if (self.selectIndex == indexPath.row) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        } else {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        }

        return cell;
    } else {
        StoreClassListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreClassListCell" forIndexPath:indexPath];
        MallSellerList *list = self.dataArray[indexPath.row];
        NSString *imgStr = @"";
        if ([list.store_avatar containsString:@"http://"]) {
            imgStr = list.store_avatar;
        }else{
            imgStr = [NSString stringWithFormat:@"%@%@",@"http://zhuang.tainongnongzi.com",list.store_avatar];
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
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
        //        cell.peisongLabel.text = [NSString stringWithFormat:@"配送费:¥%.2f",  list.delivery_money];

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        if (self.selectIndex != indexPath.row) {
            UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
            selectCell.textLabel.textColor = UIColorFromRGB(0x666666);
            selectCell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            self.selectIndex = indexPath.row;
            CategoryListModel *model = self.classDataArray[indexPath.row];
            self.navigationItem.title =  model.name;
            [self.view layoutIfNeeded];
            [self lookDetailData:model.category_id];
        }
    } else {
        //         [tableView deselectRowAtIndexPath:indexPath animated:YES];
        self.hidesBottomBarWhenPushed = YES;
        MallSellerList *list = self.dataArray[indexPath.row];
        StoreDetailViewController *viewController = [StoreDetailViewController new];
        viewController.seller_id = list.seller_id;
        viewController.storeName = list.seller_name;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - Function
- (void)lookDetailData:(NSInteger)idStr {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
        @"page": @(_page),
        @"row": @(20),
        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        @"lat": [NSString stringWithFormat:@"%lf", latitude],
        @"type": @"default",
        @"seller_type_id": @(idStr)
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

                [self.dataArray removeAllObjects];

                NSArray *array = dict[@"list"];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    MallSellerList *list = [MallSellerList mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:list];
                }
                [self.tableView reloadData];

            } else {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
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

#pragma mark - XibFunction
//排序 1,推荐商家 2，距离 3，好评 4，星级
- (IBAction)panxuBtnclicked:(UIButton *)sender {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    sender.selected = YES;
    NSDictionary *dict = @{};
    switch (sender.tag) {
    case 1: {
        self.starBtn.selected = NO;
        self.distanceBtn.selected = NO;
        self.haopinBtn.selected = NO;
        dict = @{
            @"lng": [NSString stringWithFormat:@"%lf", longitude],
            @"lat": [NSString stringWithFormat:@"%lf", latitude],
            @"page": @(1),
            @"row": @(20),
            @"type": @"default"
        };
    } break;
    case 2: {
        self.starBtn.selected = NO;
        self.tuiJianBtn.selected = NO;
        self.haopinBtn.selected = NO;
        dict = @{
            @"lng": [NSString stringWithFormat:@"%lf", longitude],
            @"lat": [NSString stringWithFormat:@"%lf", latitude],
            @"page": @(1),
            @"row": @(20),
            @"type": @"distance"
        };
    } break;
    case 3: {
        self.starBtn.selected = NO;
        self.tuiJianBtn.selected = NO;
        self.distanceBtn.selected = NO;
        dict = @{
            @"lng": [NSString stringWithFormat:@"%lf", longitude],
            @"lat": [NSString stringWithFormat:@"%lf", latitude],
            @"page": @(1),
            @"row": @(20),
            @"type": @"praise"
        };
    } break;
    case 4: {
        self.haopinBtn.selected = NO;
        self.tuiJianBtn.selected = NO;
        self.distanceBtn.selected = NO;
        dict = @{
            @"lng": [NSString stringWithFormat:@"%lf", longitude],
            @"lat": [NSString stringWithFormat:@"%lf", latitude],
            @"page": @(1),
            @"row": @(20),
            @"type": @"level"
        };
    } break;
    default:
        break;
    }

    [DZNetworkingTool postWithUrl:kIndexStoreList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [self.dataArray removeAllObjects];
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                NSArray *array = dict[@"list"];
                
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


@end
