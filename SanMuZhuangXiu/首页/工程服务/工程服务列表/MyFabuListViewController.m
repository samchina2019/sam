//
//  MyFabuListViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyFabuListViewController.h"
#import "MyFabuListCell.h"
#import "MyfabuListModel.h"
#import "ChaiChuFabuViewController.h"
#import <UShareUI/UShareUI.h>

@interface MyFabuListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSString *status;

@end

@implementation MyFabuListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的发布";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyFabuListCell" bundle:nil] forCellReuseIdentifier:@"MyFabuListCell"];
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
    NSDictionary *params = @{ @"category_id": @(self.fuwuId),
                              @"page": @(_page) };
    [DZNetworkingTool postWithUrl:kFuwuMyRelease
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
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *array = responseObject[@"data"][@"list"];
                for (NSDictionary *dict in array) {
                    MyfabuListModel *model = [MyfabuListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
                if (self.dataArray.count == [dict[@"total"] intValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
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
    return 120;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyFabuListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyFabuListCell" forIndexPath:indexPath];

    MyfabuListModel *model = self.dataArray[indexPath.row];

    cell.titleLabel.text = [NSString stringWithFormat:@"%@", model.title];
    cell.fuwutypeLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.name, model.city];
    cell.moneylabel.text = [NSString stringWithFormat:@"¥ %@ / 单位", model.price];
    cell.timelabel.text = [NSString stringWithFormat:@"%@", model.createtime];

    if ([model.status isEqualToString:@"1"]) {

        cell.zhanshiLabel.text = @"(展示中)";
        cell.xiajiabtn.userInteractionEnabled = YES;
        [cell.xiajiabtn setTitle:@"下架" forState:UIControlStateNormal];
    } else if ([model.status isEqualToString:@"-1"]) {
        cell.zhanshiLabel.textColor = [UIColor lightGrayColor];
        cell.zhanshiLabel.text = @"(禁用)";
        cell.xiajiabtn.userInteractionEnabled = NO;
        [cell.xiajiabtn setTitle:@"禁用" forState:UIControlStateNormal];
    } else if ([model.status isEqualToString:@"0"]) {
        cell.zhanshiLabel.textColor = [UIColor redColor];
        cell.zhanshiLabel.text = @"(已下架)";
        cell.xiajiabtn.userInteractionEnabled = YES;
        [cell.xiajiabtn setTitle:@"上架" forState:UIControlStateNormal];
    }

    //    if ([model.status isEqualToString:@"1"]) {
    //        [cell.xiajiabtn setTitle:@"上架" forState:UIControlStateNormal];
    //    } else if ([model.status isEqualToString:@"2"]) {
    //        [cell.xiajiabtn setTitle:@"下架" forState:UIControlStateNormal];
    //    }
    cell.cellButtonClickedHandler = ^(id _Nonnull obj, UIButton *_Nonnull sender) { //下架 tag=100；刷新 200；置顶 300
        self.status = model.status;
        MyFabuListCell *mycell = obj;
        if (sender.tag == 100) {

            NSDictionary *params = @{ @"id": [NSString stringWithFormat:@"%d", model.lookId],
                                      @"status": self.status

            };
            [DZNetworkingTool postWithUrl:kGCMyFaBuXiaJia
                params:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];
                        if ([model.status intValue] == 1) {
                            [mycell.xiajiabtn setTitle:@"上架" forState:UIControlStateNormal];
                            self.status = @"0";

                        } else if ([model.status intValue] == 0) {
                            [mycell.xiajiabtn setTitle:@"下架" forState:UIControlStateNormal];
                            self.status = @"1";
                        }

                        [self.tableView reloadData];
                    } else {
                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    }
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                    [DZTools showNOHud:RequestServerError delay:2.0];
                }
                IsNeedHub:NO];
        } else if (sender.tag == 200) {
            NSDictionary *params = @{ @"id": [NSString stringWithFormat:@"%d", model.lookId],
                                      @"status": model.status };
            [DZNetworkingTool postWithUrl:kGCjianliRefresh
                params:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];

                    } else {
                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    }
                    [self refresh];
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                    [DZTools showNOHud:RequestServerError delay:2.0];
                }
                IsNeedHub:NO];
        } else if (sender.tag == 300) {
            NSDictionary *params = @{
                @"id": [NSString stringWithFormat:@"%d", model.lookId],

            };
            [DZNetworkingTool postWithUrl:kGCjianliTopRefresh
                params:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];

                    } else {
                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    }
                    [self refresh];
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                    [DZTools showNOHud:RequestServerError delay:2.0];
                }
                IsNeedHub:NO];
        }
    };
    cell.moreBlock = ^(NSInteger index) {
        if (index == 0) {
            //            NSLog(@"点击了删除");
            NSDictionary *params = @{ @"id": [NSString stringWithFormat:@"%d", model.lookId] };
            [DZNetworkingTool postWithUrl:kGCMyFaBuDelete
                params:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [self.dataArray removeObjectAtIndex:indexPath.row];
                        [self.tableView reloadData];
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    } else {
                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    }
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                    [DZTools showNOHud:RequestServerError delay:2.0];
                }
                IsNeedHub:NO];

        } else if (index == 1) {
            [UMSocialUIManager setPreDefinePlatforms:@[
                @(UMSocialPlatformType_WechatSession),
                @(UMSocialPlatformType_WechatTimeLine),
                @(UMSocialPlatformType_QQ),
                @(UMSocialPlatformType_Qzone),
            ]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作

                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"装修你的爱家" thumImage:[UIImage imageNamed:@"AppIcon"]];
                //设置网页地址
                shareObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%d&token=%@", kShareProject, self.fuwuId, [User getToken]];
                //分享消息对象设置分享内容对象
                messageObject.shareObject = shareObject;
                //调用分享接口
                [[UMSocialManager defaultManager] shareToPlatform:platformType
                                                    messageObject:messageObject
                                            currentViewController:self
                                                       completion:^(id data, NSError *error) {
                                                           if (error) {
                                                               NSLog(@"************Share fail with error %@*********", error);
                                                           } else {
                                                               [DZTools showOKHud:@"分享成功" delay:2];
                                                           }
                                                       }];
            }];
        } else {
            MyfabuListModel *model = self.dataArray[indexPath.row];

            ChaiChuFabuViewController *vc = [[ChaiChuFabuViewController alloc] init];
            vc.navigationItem.title = @"重新发布";
            vc.isFromDetail = YES;
            vc.lookId = model.lookId;
            vc.fuwuId = self.fuwuId;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    
}

@end
