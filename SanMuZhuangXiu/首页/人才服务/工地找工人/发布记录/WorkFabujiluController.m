//
//  WorkFabujiluController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "WorkFabujiluController.h"
#import "WorkFabujiluCell.h"
#import "MyFabuModel.h"
#import <UShareUI/UShareUI.h>
#import "WorkZhaogongrenController.h"

@interface WorkFabujiluController ()
@property (weak, nonatomic) IBOutlet UITableView *workTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) NSInteger page;
@property (nonatomic, assign) int idStr;
///状态1，上架，0下架
@property (nonatomic, strong) NSString *stutas;

@end

@implementation WorkFabujiluController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([DZTools islogin]) {
        [self refresh];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

    [self.workTableView registerNib:[UINib nibWithNibName:@"WorkFabujiluCell" bundle:nil] forCellReuseIdentifier:@"WorkFabujiluCell"];
    [self.workTableView.mj_header beginRefreshing];
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
    NSDictionary *params = @{ @"limit": @(20),
                              //                              @"token": [User getToken],
                              @"p": @(_page) };
    [DZNetworkingTool postWithUrl:kmyRelease
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
                NSArray *array = dict[@"list"];
                for (NSDictionary *dict in array) {
                    MyFabuModel *model = [MyFabuModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.workTableView reloadData];
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
    return 180;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    WorkFabujiluCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WorkFabujiluCell" forIndexPath:indexPath];
    MyFabuModel *model = self.dataArray[indexPath.row];
    cell.zhaopinNameLabel.text = model.name;
    if ([model.status isEqualToString:@"1"]) {
        cell.zanshiLabel.textColor = UIColorFromRGB(0x3FAEE9);
        cell.zanshiLabel.text = @"(展示中)";
        cell.xiajiabtn.userInteractionEnabled = YES;
        [cell.xiajiabtn setTitle:@"下架" forState:UIControlStateNormal];
    } else if ([model.status isEqualToString:@"-1"]) {
        cell.zanshiLabel.textColor = [UIColor lightGrayColor];
        cell.zanshiLabel.text = @"(禁用)";

        cell.xiajiabtn.userInteractionEnabled = NO;
        [cell.xiajiabtn setTitle:@"禁用" forState:UIControlStateNormal];
    } else if ([model.status isEqualToString:@"0"]) {
        cell.zanshiLabel.textColor = [UIColor redColor];
        cell.zanshiLabel.text = @"(已下架)";
        cell.xiajiabtn.userInteractionEnabled = YES;
        [cell.xiajiabtn setTitle:@"上架" forState:UIControlStateNormal];
    }
    NSString *timeStr = [DZTools compareCurrentTime:model.createtime];
    cell.fabushijianLabel.text = [NSString stringWithFormat:@"%@已发布", timeStr];
    cell.rixinLabel.text = [NSString stringWithFormat:@"¥%@", model.salary];
    cell.techangLabel.text = model.speciality;
    cell.shanggangDateLabel.text = model.construction_time;
    cell.liulanNumLabel.text = [NSString stringWithFormat:@"%d人已浏览", model.read_number];
    cell.gongzuoAddressLabel.text = [NSString stringWithFormat:@"%@%@", model.work_address, model.work_addressInfo];

    cell.cellButtonClickedHandler = ^(id obj, UIButton *sender) {
        self.idStr = model.lookId;
        if ([model.status isEqualToString:@"0"]) {
            self.stutas = @"1";
        } else if ([model.status isEqualToString:@"1"]) {
            self.stutas = @"0";
        }
        //处理点击事件
        [self handleTheActionWithCell:obj andButton:sender];
    };

    //    __weak typeof (WorkFabujiluCell *) weakself=cell;
    cell.moreBlock = ^(NSInteger index) {
        if (index == 0) {
            NSLog(@"点击了删除");
            self.idStr = model.lookId;
            [self deleteClick];

        } else if (index == 1) {
            [self shareBtnClickWithId:model.lookId];
        } else {
            //编辑
            self.hidesBottomBarWhenPushed = YES;
            WorkZhaogongrenController *zhaopingongrenViewController = [[WorkZhaogongrenController alloc] init];
            zhaopingongrenViewController.isEdited = YES;
            zhaopingongrenViewController.userId = model.lookId;
            [self.navigationController pushViewController:zhaopingongrenViewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        }
    };

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
#pragma mark - Function

- (void)shareBtnClickWithId:(NSInteger)lookId {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作

        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"工地找工人详情" thumImage:[UIImage imageNamed:@"AppIcon"]];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@?id=%ld&token=%@", kShareGangwei, (long) lookId, [User getToken]];
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
}
- (void)deleteClick {
    NSDictionary *dict = @{
        @"id": @(self.idStr)
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

- (void)handleTheActionWithCell:(WorkFabujiluCell *)cell andButton:(UIButton *)sender {
    if (sender.tag == 201) { //下架 tag=201；刷新 202；置顶 203
        NSDictionary *dict = @{ @"id": @(self.idStr),
                                @"status": self.stutas };
        [DZNetworkingTool postWithUrl:kLowerRecruit
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
    } else if (sender.tag == 202) {
        NSDictionary *params = @{ @"id": @(self.idStr) };
        [DZNetworkingTool postWithUrl:kGongDiFindjianliRefresh
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
    } else if (sender.tag == 203) {
        NSDictionary *params = @{ @"id": @(self.idStr) };
        [DZNetworkingTool postWithUrl:kGongDiFindTopRefresha
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
    }
    
    
}

@end
