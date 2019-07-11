//
//  GuizeNextViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GuizeNextViewController.h"
#import "SetTableViewCell.h"
#import "GongDiKaoQinViewController.h"
#import "SetPeopleViewController.h"
#import "ZuyuanXinxiViewController.h"
#import "SearchViewCell.h"
#import "GroupPeopleModel.h"
#import "HeadView.h"
#import "QunGuanliViewController.h"

@interface GuizeNextViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *searchTableView;
//搜索
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *mobile;

@property (nonatomic) NSInteger page;

@property (strong, nonatomic) NSMutableArray *searchArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *adminArray;

@end

@implementation GuizeNextViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initItem];
    [self initTableView];

    self.adminArray = [NSMutableArray array];
}
#pragma mark – UI

- (void)initItem {

    self.navigationItem.title = @"设置人员";

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x101010) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)initTableView {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180)];
    view.userInteractionEnabled = YES;
    [view addSubview:self.bgView];

    self.adminArray = [NSMutableArray array];
    //设置圆角
    view.layer.cornerRadius = 3;
    //阴影的颜色
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    view.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    view.layer.shadowRadius = 3.f;
    //阴影偏移量
    view.layer.shadowOffset = CGSizeMake(0, 0);

    [self.tableView setTableHeaderView:view];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.searchTableView registerNib:[UINib nibWithNibName:@"SearchViewCell" bundle:nil] forCellReuseIdentifier:@"SearchViewCell"];
    self.searchArray = [NSMutableArray array];

    [self.tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetTableViewCell"];

    [self.tableView.mj_header beginRefreshing];
}

#pragma mark – Network

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSDictionary *params = @{
        @"group_id": @(self.groupId)

    };
    [DZNetworkingTool postWithUrl:kGroupUserList
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

                [self.adminArray removeAllObjects];
                [self.dataArray removeAllObjects];

                NSArray *adminArr = dict[@"group_admin"];
                for (NSDictionary *temp in adminArr) {
                    GroupPeopleModel *model = [GroupPeopleModel mj_objectWithKeyValues:temp];
                    [self.adminArray addObject:model];
                }

                NSArray *array = dict[@"user"];
                for (NSDictionary *temp in array) {
                    GroupPeopleModel *model = [GroupPeopleModel mj_objectWithKeyValues:temp];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];

            } else {
//                [DZTools showNOHud:responseObject[@"msg"] delay:2];
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

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.searchTableView) {
        return 1;
    }
    return 2;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        UIView *view = [[UIView alloc] init];
        return view;
    } else {
        if (section == 0) {
            UIView *view = [[UIView alloc] init];
            if (self.adminArray.count == 0) {
                view.frame = CGRectMake(0, 0, ViewWidth, 0);
            } else {
                view.frame = CGRectMake(0, 0, ViewWidth, 50);
                view.layer.cornerRadius = 3;
                view.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];

                UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
                titleLable.backgroundColor = [UIColor clearColor];
                titleLable.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
                titleLable.textAlignment = NSTextAlignmentCenter;
                [view addSubview:titleLable];

                titleLable.text = @"管理员";
            }

            return view;
        } else {
            HeadView *view = [[HeadView alloc] init];
            if (self.dataArray.count == 0) {
                view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
                view.hidden = YES;
            } else {
                view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 50);
                view.layer.cornerRadius = 3;
                view.hidden = NO;
                __weak typeof(self) weakSelf = self;
                view.moreBlock = ^{

                    //            weakSelf.hidesBottomBarWhenPushed=YES;
                    //              ZuyuanXinxiViewController *controller=[[ZuyuanXinxiViewController alloc]init];
                    //
                    //              [weakSelf.navigationController pushViewController:controller animated:YES];
                    //              weakSelf.hidesBottomBarWhenPushed=YES;
                    //

                };
                //            view.searchTextField.delegate=self;
                __weak typeof(HeadView *) weakSelfs = view;

                view.searchBlock = ^{
                    //                [weakSelf textFileSearch:weakSelfs.searchTextField];
                };
            }
            return view;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        if (self.searchArray.count == 0) {

            self.searchTableView.hidden = YES;

        } else {
            self.searchTableView.hidden = NO;
        }
        return self.searchArray.count;
    } else {
        if (section == 0) {

            return self.adminArray.count;
        } else {
            
            return self.dataArray.count;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (tableView == self.searchTableView) {
        return 40;
    }
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.searchTableView) {
        return 0.01;
    } else {

        if (section == 0) {
            if (self.adminArray.count == 0) {
                return 0.01;
            }
            return 50;
        } else {
            if (self.dataArray.count == 0) {
                return 0.01;
            }
            return 50;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.searchTableView) {
        SearchViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchViewCell" forIndexPath:indexPath];
        NSDictionary *dict = self.searchArray[indexPath.row];
            cell.addBlock = ^{
                
//                self.searchTableView.hidden = YES;
            };
        cell.nameLabel.text = [NSString stringWithFormat:@"%@", dict[@"nickname"]];
        cell.phoneLabel.text = [NSString stringWithFormat:@"%@", dict[@"mobile"]];
       
        return cell;
    } else {
        if (indexPath.section == 0) {
            SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
            GroupPeopleModel *model = self.adminArray[indexPath.row];

            __weak typeof(self) weakSelf = self;
            cell.setPeopleBlock = ^(SetTableViewCell *cell) {

                weakSelf.hidesBottomBarWhenPushed = YES;
                ZuyuanXinxiViewController *controller = [[ZuyuanXinxiViewController alloc] init];
                controller.group_id = self.groupId;
                controller.list_id = model.list_id;
                controller.phoneStr = model.mobile;
                [weakSelf.navigationController pushViewController:controller animated:YES];
                weakSelf.hidesBottomBarWhenPushed = YES;

            };
            if (model.group_nickname.length == 0) {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.nickname];
            } else {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.nickname, model.group_nickname];
            }

            cell.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", model.mobile];
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.avatar]]];
            if ([model.status isEqualToString:@"2"]) {
                cell.stateBtn.layer.borderColor = UIColorFromRGB(0xFA5458).CGColor;
                [cell.stateBtn.titleLabel setTextColor:UIColorFromRGB(0xFA5458)];
                [cell.stateBtn setTitle:@"异常" forState:UIControlStateNormal];
                cell.layer.cornerRadius = 3;
                cell.stateBtn.layer.borderWidth = 1;
                //
            } else {
                cell.stateBtn.layer.borderColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor;
                [cell.stateBtn.titleLabel setTextColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0]];
                cell.stateBtn.layer.borderWidth = 1;
                cell.layer.cornerRadius = 3;
            }

            return cell;
        } else {
            SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];

            GroupPeopleModel *model = self.dataArray[indexPath.row];

            //        __weak typeof(self) weakSelf = self;
            cell.setPeopleBlock = ^(SetTableViewCell *cell) {

                //            weakSelf.hidesBottomBarWhenPushed=YES;
                //            ZuyuanXinxiViewController *controller=[[ZuyuanXinxiViewController alloc]init];
                //            controller.personnel_management=self.personnel_management;
                //            controller.group_id=self.groupId;
                //            controller.list_id=model.list_id;
                //            controller.phoneStr=model.mobile;
                //            [weakSelf.navigationController pushViewController:controller animated:YES];
                //            weakSelf.hidesBottomBarWhenPushed=YES;

            };

            if (model.group_nickname.length == 0) {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.nickname];
            } else {
                cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.nickname, model.group_nickname];
            }
            cell.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", model.mobile];
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.avatar]] placeholderImage:[UIImage imageNamed:@"home_pic_content6"]];
            if ([model.status isEqualToString:@"2"]) {
                cell.stateBtn.layer.borderColor = UIColorFromRGB(0xFA5458).CGColor;
                [cell.stateBtn.titleLabel setTextColor:UIColorFromRGB(0xFA5458)];
                [cell.stateBtn setTitle:@"异常" forState:UIControlStateNormal];
                cell.layer.cornerRadius = 3;
                cell.stateBtn.layer.borderWidth = 1;

            } else {
                cell.stateBtn.layer.borderColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor;
                [cell.stateBtn.titleLabel setTextColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0]];
                cell.layer.cornerRadius = 3;
                cell.stateBtn.layer.borderWidth = 1;
            }

            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
if (tableView == self.searchTableView) {
    NSDictionary *dict = self.searchArray[indexPath.row];
    NSDictionary *temp = @{
                           @"group_id": @(self.groupId),
                           @"group_user_ids": dict[@"user_id"]
                           
                           };
    [DZNetworkingTool postWithUrl:kAddGroupUser
                           params:temp
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  [self refresh];
                                  self.searchTableView.hidden = YES;
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                              
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:responseObject[@"msg"] delay:2];
                           }
                        IsNeedHub:NO];
   }
}
#pragma mark – Network
#pragma mark – Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.view endEditing:YES];

    NSDictionary *dict = @{
        @"phone": self.searchTextField.text,
        @"page": @(1),
        @"limit": @(20)
    };
    [DZNetworkingTool postWithUrl:kGetUser
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.searchArray removeAllObjects];
            if ([responseObject[@"code"] intValue] == SUCCESS) {
               
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                NSArray *array = responseObject[@"data"];
                NSLog(@"%@", array);

                for (NSDictionary *dict in array) {
                    [self.searchArray addObject:dict];
                }

                [self.searchTableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

#pragma mark - Function

//跳过按钮的点击事件
- (void)rightBarButtonItemClicked {
    self.hidesBottomBarWhenPushed = YES;
    QunGuanliViewController *vc = [[QunGuanliViewController alloc] init];
    vc.groupId = self.groupId;
    
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
#pragma mark-- XibFunction
//添加按钮点击事件
- (IBAction)addBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SetPeopleViewController *controller = [[SetPeopleViewController alloc] init];
    controller.group_id = self.groupId;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (IBAction)endEdited:(id)sender {
    [self.tableView endEditing:YES];
}
//完成按钮的点击
- (IBAction)finishBtnClick:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    QunGuanliViewController *vc = [[QunGuanliViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=YES;
}

@end
