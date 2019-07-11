//
//  FabujiluViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FabujiluViewController.h"
#import "FabujiluCell.h"
#import "JianLiJiLuModel.h"
#import <UShareUI/UShareUI.h>
#import "FindFabujianliController.h"
#import "FabujianliViewController.h"

@interface FabujiluViewController ()
@property (weak, nonatomic) IBOutlet UITableView *fabujiluTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;
@end

@implementation FabujiluViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if ([DZTools islogin]) {
        [self refresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的发布记录";

    self.view.backgroundColor = [UIColor whiteColor];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self.fabujiluTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.fabujiluTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.fabujiluTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.fabujiluTableView registerNib:[UINib nibWithNibName:@"FabujiluCell" bundle:nil] forCellReuseIdentifier:@"FabujiluCell"];
    [self.fabujiluTableView.mj_header beginRefreshing];
}

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSDictionary *params = @{ @"page": @(_page),
                              @"limit": @(20) };
    [DZNetworkingTool postWithUrl:_isqiuzhi ? kQZMyFaBuJiLuList : kMyFaBuJiLuList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.fabujiluTableView.mj_footer.isRefreshing) {
                [self.fabujiluTableView.mj_footer endRefreshing];
            }
            if (self.fabujiluTableView.mj_header.isRefreshing) {
                [self.fabujiluTableView.mj_header endRefreshing];
            }

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                NSArray *array = dict[@"list"];
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                for (NSDictionary *dict in array) {
                    JianLiJiLuModel *model = [JianLiJiLuModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.fabujiluTableView reloadData];
                if (self.dataArray.count == [dict[@"total"] integerValue]) {
                    [self.fabujiluTableView.mj_footer endRefreshingWithNoMoreData];
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.fabujiluTableView.mj_footer.isRefreshing) {
                [self.fabujiluTableView.mj_footer endRefreshing];
            }
            if (self.fabujiluTableView.mj_header.isRefreshing) {
                [self.fabujiluTableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)rightBarButtonItemClicked {
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.fabujiluTableView.backgroundView = backgroundImageView;
        self.fabujiluTableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.fabujiluTableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.sectionHeaderView;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FabujiluCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FabujiluCell" forIndexPath:indexPath];
    JianLiJiLuModel *model = self.dataArray[indexPath.row];
    if (_isqiuzhi) {
        if (model.recruitment_post.length == 0) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.realName];
        } else {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.realName, model.recruitment_post];
        }

    } else {
        if (model.jobName.length == 0) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.username];
        } else {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.username, model.jobName];
        }
    }
    cell.timeLabel.text = model.createtime;
    cell.yuexinLabel.text = [NSString stringWithFormat:@"¥%@", model.salary];
    cell.cellButtonClickedHandler = ^(id obj, UIButton *sender) {
        //处理点击事件
        [self handleTheActionWithCell:obj andButton:sender model:model];
    };

    if ([model.status intValue] == 1) {
        [cell.xiajiaBtn setTitle:@"下架" forState:UIControlStateNormal];
    } else if ([model.status intValue] == 0) {
        [cell.xiajiaBtn setTitle:@"上架" forState:UIControlStateNormal];
    }

    cell.moreBlock = ^(NSInteger index) {
        if (index == 0) { //点击了删除
            NSDictionary *params = @{ @"id": [NSString stringWithFormat:@"%d", model.jobId] };
            [DZNetworkingTool postWithUrl:self.isqiuzhi ? kQZMyFaBuDelete : kMyFaBuDelete
                params:params
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [self.dataArray removeObjectAtIndex:indexPath.row];
                        [self.fabujiluTableView reloadData];
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
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作

                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"求职详情" thumImage:[UIImage imageNamed:@"AppIcon"]];
             
                NSString *url =  self.isqiuzhi ? kShareQYQiuzhi : kShareQiuzhi;
                //设置网页地址
                shareObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%d&token=%@",url,model.jobId,[User getToken]];
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
            if (self.isqiuzhi) {
                self.hidesBottomBarWhenPushed = YES;
                FabujianliViewController *vc = [[FabujianliViewController alloc] init];
                vc.fabuId = model.jobId;
                vc.isEdit = YES;
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            } else {
                self.hidesBottomBarWhenPushed = YES;
                FindFabujianliController *fabujiluViewController = [[FindFabujianliController alloc] init];
                fabujiluViewController.fabuId = model.jobId;
                fabujiluViewController.isEdit = YES;
                [self.navigationController pushViewController:fabujiluViewController animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            }
        }
    };

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

//下架 tag=101；刷新 102；置顶 103
- (void)handleTheActionWithCell:(FabujiluCell *)cell andButton:(UIButton *)sender model:(JianLiJiLuModel *)model {
    cell.moreView.hidden = YES;

    //处理cell上按钮的点击事件：
    switch (sender.tag) {
            
    case 101: {
        
        NSString *stutas = @"";
        if ([model.status isEqualToString:@"0"]) {
            stutas = @"1";
        }else if([model.status  isEqualToString:@"1"]){
            stutas = @"0";
        }
        
        NSDictionary *params = @{ @"id": [NSString stringWithFormat:@"%d", model.jobId],
                                  @"status": stutas };
        [DZNetworkingTool postWithUrl:self.isqiuzhi ? kQZMyFaBuXiaJia : kMyFaBuXiaJia
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    if ([model.status intValue] == 1) {
                        [cell.xiajiaBtn setTitle:@"上架" forState:UIControlStateNormal];
                        model.status = @"0";
                    } else if ([model.status intValue] == 0) {
                        [cell.xiajiaBtn setTitle:@"下架" forState:UIControlStateNormal];
                        model.status = @"1";
                    }
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];
    } break;
    case 102: {
        NSDictionary *params = @{ @"id": [NSString stringWithFormat:@"%d", model.jobId] };
        [DZNetworkingTool postWithUrl:self.isqiuzhi ? kQZjianliRefresh : kjianliRefresh
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
    } break;
    case 103: {
        NSDictionary *temp = @{ @"id": [NSString stringWithFormat:@"%d", model.jobId] };
        [DZNetworkingTool postWithUrl:self.isqiuzhi ? kTopRefresha : kFindWorkTopRefresha
            params:temp
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
    } break;
 
    default:
        break;
    }
}


@end
