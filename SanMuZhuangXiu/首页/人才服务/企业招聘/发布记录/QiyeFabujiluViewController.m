//
//  QiyeFabujiluViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QiyeFabujiluViewController.h"
#import "QiyeFabujiluCell.h"
#import "QiyeJiluModel.h"
#import <UShareUI/UShareUI.h>
#import "FabuZhaopinViewController.h"
@interface QiyeFabujiluViewController ()
@property (weak, nonatomic) IBOutlet UITableView *workTableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;
@property (nonatomic, assign) int lookId;
@property (nonatomic, strong) NSString *statusStr;

@end

@implementation QiyeFabujiluViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    if ([DZTools islogin]) {
        [self refresh];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"发布记录";

    self.view.backgroundColor = [UIColor whiteColor];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    [self.workTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.workTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.workTableView registerNib:[UINib nibWithNibName:@"QiyeFabujiluCell" bundle:nil] forCellReuseIdentifier:@"QiyeFabujiluCell"];
    [self.workTableView.mj_header beginRefreshing];
}

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    //    kQiyeMyRelease
    NSDictionary *params = @{
        @"page": @(_page)

    };
    [DZNetworkingTool postWithUrl:kQiyeMyRelease
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *list = dict[@"list"];
                for (NSDictionary *dict in list) {
                    QiyeJiluModel *model = [QiyeJiluModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                //                [self.dataArray addObjectsFromArray:dict[@"list"]];
                [self.workTableView reloadData];
                if (self.dataArray.count == [dict[@"total"] intValue]) {
                    [self.workTableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
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
        self.workTableView.backgroundView = backgroundImageView;
        self.workTableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.workTableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QiyeFabujiluCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QiyeFabujiluCell" forIndexPath:indexPath];
    QiyeJiluModel *model = self.dataArray[indexPath.row];
    if ([model.status isEqualToString:@"1"]) {
        cell.zanshiLabel.textColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];
        [cell.xiajiaBtn setTitle:@"下架" forState:UIControlStateNormal];
        cell.zanshiLabel.text = @"(展示中)";
    } else if ([model.status isEqualToString:@"-1"]) {
        cell.zanshiLabel.textColor = [UIColor lightGrayColor];
        cell.zanshiLabel.text = @"(禁用)";
    } else if ([model.status isEqualToString:@"0"]) {
        cell.zanshiLabel.textColor = [UIColor redColor];
        [cell.xiajiaBtn setTitle:@"上架" forState:UIControlStateNormal];
        cell.zanshiLabel.text = @"(下架)";
    }
    cell.zhaopinNameLabel.text = model.name;
    cell.xinziLabel.text = [NSString stringWithFormat:@"¥%@", model.salary];
    cell.gongsiNameLabel.text = model.companyName;
    cell.gognzuoquyuLabel.text = model.work_region;

    //    __weak typeof (QiyeFabujiluCell *) weakself=cell;
    cell.moreBlock = ^(NSInteger index) {
        self.lookId = model.lookId;

        if (index == 0) {//0删除 1分享 2编辑
            NSLog(@"点击了删除");

            [self deleteClick];
        } else if (index == 1) {
            [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
            //显示分享面板
            [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
                // 根据获取的platformType确定所选平台进行下一步操作

                //创建分享消息对象
                UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
                UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"企业招聘详情" thumImage:[UIImage imageNamed:@"AppIcon"]];
                //设置网页地址
                shareObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%d&token=%@",kShareQYGangwei, model.lookId ,[User getToken]];
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
            self.hidesBottomBarWhenPushed = YES;
            FabuZhaopinViewController *vc = [[FabuZhaopinViewController alloc] init];
            vc.fabuId = model.lookId;
            vc.isEdit = YES;
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    };

    cell.cellButtonClickedHandler = ^(id obj, UIButton *sender) {
        if ([model.status isEqualToString:@"0"]) {
             self.statusStr = @"1";
        }else if([model.status  isEqualToString:@"1"]){
             self.statusStr = @"0";
        }
//        self.statusStr = model.status;
        self.lookId = model.lookId;
        //处理点击事件
        [self handleTheActionWithCell:obj andButton:sender];
    };

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)deleteClick {
    NSDictionary *dict = @{
                           @"id": @(self.lookId)
                           };
    [DZNetworkingTool postWithUrl:kDeleteRecruit
                           params:dict
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
}

#pragma  mark -- cellHandle

- (void)handleTheActionWithCell:(QiyeFabujiluCell *)cell andButton:(UIButton *)sender {
    cell.moreView.hidden = YES;

    if (sender.tag == 222) { //下架tag 111;刷新 222；置顶 333
                             //        kQiyeRefresh

        NSDictionary *dict = @{
            @"id": @(self.lookId)

        };
        [DZNetworkingTool postWithUrl:kQiyeRefresh
            params:dict
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

    } else if (sender.tag == 111) {
        //        NSLog(@"********%@",self.statusStr)
        NSDictionary *temp = @{
            @"id": @(self.lookId),
            @"status": self.statusStr,
            @"token": [User getToken],
        };

        [DZNetworkingTool postWithUrl:kQiyeLowerRecruit
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
    } else if (sender.tag == 333) {
        //        NSLog(@"********%@",self.statusStr)
        NSDictionary *temp = @{
            @"id": @(self.lookId),
            @"token": [User getToken],
        };

        [DZNetworkingTool postWithUrl:kQiyeTopRefresh
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
    }
    
    
    
   
}

@end
