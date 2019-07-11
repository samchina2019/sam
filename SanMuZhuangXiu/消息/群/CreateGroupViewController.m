//
//  CreateGroupViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CreateGroupViewController.h"
#import "GroupListCell.h"
#import "FriendsListModel.h"
#import "SelectFriendsListViewController.h"
#import "QunGuanliViewController.h"

@interface CreateGroupViewController ()

@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;

@end

@implementation CreateGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.isEdit) {
        self.navigationItem.title = @"编辑";
        self.nameTF.userInteractionEnabled = NO;
        self.nameTF.text = self.groupModel.group_name;
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
            NSLog(@"下拉刷新");
            [self refresh];
        }];
        [self refresh];
    } else {
        self.navigationItem.title = @"创建群聊";
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
        button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    }

    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView.layer.shadowOpacity = 0.5f;
    self.bgView.layer.shadowRadius = 3.f;
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);

    self.headerView.frame = CGRectMake(0, 0, ViewWidth - 32, 170);
    self.tableView.tableHeaderView = self.headerView;

    [self.tableView registerNib:[UINib nibWithNibName:@"GroupListCell" bundle:nil] forCellReuseIdentifier:@"GroupListCell"];
}
- (void)refresh {
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    [DZNetworkingTool postWithUrl:kXXGroupUserList
        params:@{ @"group_id": @(self.groupModel.group_id) }
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"][@"user"];
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dict in array) {
                    FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)rightBarButtonItemClicked {
    if (self.nameTF.text.length == 0) {
        [DZTools showNOHud:@"请输入群名称" delay:2];
        return;
    }
    if (self.dataArray.count == 0) {
        [DZTools showNOHud:@"请添加群成员" delay:2];
        return;
    }
    NSString *userId = @"";
    for (int i = 0; i < self.dataArray.count; i++) {
        FriendsListModel *model = self.dataArray[i];
        if (i == 0) {
            userId = [NSString stringWithFormat:@"%ld", (long) model.user_id];
        } else {
            userId = [NSString stringWithFormat:@"%@,%ld", userId, (long) model.user_id];
        }
    }
    NSDictionary *params = @{ @"group_name": self.nameTF.text,
                              @"group_user_ids": userId };
    [DZNetworkingTool postWithUrl:kXXCreateGroup
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

#pragma mark--- UITableViewDataSource and UITableViewDelegate Methods---
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupListCell" forIndexPath:indexPath];
    FriendsListModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.nickname;
    cell.phoneLabel.text = model.mobile;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    if (self.isEdit && self.groupModel.group_owner) {
        cell.editBtn.hidden = NO;
        [cell.editBtn setTitle:@"移除" forState:UIControlStateNormal];
        if ([[User getUserID] integerValue] == model.user_id) {
            cell.editBtn.hidden = YES;
        }
    } else {
        cell.editBtn.hidden = YES;
    }
    cell.block = ^{
        NSDictionary *params = @{ @"group_id": @(self.groupModel.group_id),
                                  @"del_ids": @(model.user_id) };
        [DZNetworkingTool postWithUrl:kXXManagerGroup
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    [self.dataArray removeObjectAtIndex:indexPath.row];
                    [self.tableView reloadData];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - XibFunction
//邀请好友
- (IBAction)yaoqingFriend:(id)sender {
    if (self.isEdit) {
        if (!self.groupModel.group_owner) {
            return;
        }
        SelectFriendsListViewController *viewController = [[SelectFriendsListViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.block = ^(NSArray *_Nonnull array) {
            NSString *userId = @"";
            for (int i = 0; i < array.count; i++) {
                FriendsListModel *model = array[i];
                if (i == 0) {
                    userId = [NSString stringWithFormat:@"%ld", (long) model.user_id];
                } else {
                    userId = [NSString stringWithFormat:@"%@,%ld", userId, (long) model.user_id];
                }
            }
            NSDictionary *params = @{ @"group_id": @(self.groupModel.group_id),
                                      @"group_user_ids": userId };
            [DZNetworkingTool postWithUrl:kXXAddGroupUser
                params:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];
                        [self refresh];
                    } else {
                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    }
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                    [DZTools showNOHud:RequestServerError delay:2.0];
                }
                IsNeedHub:NO];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        SelectFriendsListViewController *viewController = [[SelectFriendsListViewController alloc] init];
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.block = ^(NSArray *_Nonnull array) {
            [self.dataArray addObjectsFromArray:array];
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }
}
#pragma mark --XibFunction
//工地群组
- (IBAction)gongDiGroupFriend:(id)sender {
    QunGuanliViewController *viewController = [[QunGuanliViewController alloc] init];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.isSelectStatus = YES;
    viewController.block = ^(int gongdiGroupID) {
        NSDictionary *params = @{ @"group_id": @(gongdiGroupID) };
        [DZNetworkingTool postWithUrl:kGroupUserList
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSDictionary *dict = responseObject[@"data"];

                    NSArray *adminArr = dict[@"group_admin"];
                    for (NSDictionary *temp in adminArr) {
                        FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:temp];
                        [self.dataArray addObject:model];
                    }

                    NSArray *array = dict[@"user"];
                    for (NSDictionary *temp in array) {
                        FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:temp];
                        [self.dataArray addObject:model];
                    }
                    if (self.isEdit) {
                        NSString *userId = @"";
                        for (int i = 0; i < self.dataArray.count; i++) {
                            FriendsListModel *model = self.dataArray[i];
                            if (i == 0) {
                                userId = [NSString stringWithFormat:@"%ld", (long) model.user_id];
                            } else {
                                userId = [NSString stringWithFormat:@"%@,%ld", userId, (long) model.user_id];
                            }
                        }
                        NSDictionary *params = @{ @"group_id": @(self.groupModel.group_id),
                                                  @"group_user_ids": userId };
                        [DZNetworkingTool postWithUrl:kXXAddGroupUser
                                               params:params
                                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
                                                      [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                                      [self refresh];
                                                  } else {
                                                      [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                                  }
                                              }
                                               failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                                   [DZTools showNOHud:RequestServerError delay:2.0];
                                               }
                                            IsNeedHub:NO];
                    }else{
                        [self.tableView reloadData];
                    }
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];
    };
    [self.navigationController pushViewController:viewController animated:YES];
}
@end
