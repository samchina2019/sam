//
//  FindWorkingViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FindWorkingViewController.h"
#import "findWorkingCell.h"
#import "FabujiluViewController.h"
#import "FindFabujianliController.h"
#import "FindDetailViewController.h"
#import "GongRenFindWorkListModel.h"
#import "ReLayoutButton.h"
#import "YBPopupMenu.h"
#import "FrontViewController.h"
//#import "JYBDIDCardVC.h"

@interface FindWorkingViewController () <YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet ReLayoutButton *shanggangTimeBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiguanBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *fujinBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *gongzhongBtn;
@property (weak, nonatomic) IBOutlet UITableView *workTableView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;

@property (nonatomic) NSInteger page;

@property (nonatomic, strong) NSMutableArray *jiguanArray;
@property (nonatomic, strong) NSMutableArray *gongzhongArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *shanggangTimeArray;
@property (nonatomic, strong) NSMutableArray *distanceArray;

@property (nonatomic, strong) NSString *jiguanStr;
@property (nonatomic, strong) NSString *shanggangTimeStr;
@property (nonatomic, strong) NSString *gongzhongId;
@property (nonatomic, strong) NSString *distanceStr;
@property (nonatomic, strong) NSString *searchStr;

@end

@implementation FindWorkingViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//if ([DZTools islogin]) {
    [self loadData];
//    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.sectionHeaderView.frame = CGRectMake(0, 0, ViewWidth, 40);
    self.workTableView.tableHeaderView = self.sectionHeaderView;
    self.jiguanArray = [NSMutableArray array];
    self.gongzhongArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.distanceArray = [NSMutableArray arrayWithObjects:@"不限", @"1km内", @"3km内", @"10km内", nil];
    self.shanggangTimeArray = [NSMutableArray array];

    self.distanceStr = @"";
    self.jiguanStr = @"";
    self.gongzhongId = @"";
    self.shanggangTimeStr = @"";
    self.searchStr = @"";

    self.workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.workTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.workTableView registerNib:[UINib nibWithNibName:@"findWorkingCell" bundle:nil] forCellReuseIdentifier:@"findWorkingCell"];
    [self.workTableView.mj_header beginRefreshing];

    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"searchGongren" object:nil];
}


#pragma mark – Network

- (void)loadData {

    [DZNetworkingTool postWithUrl:kArrayRecruit
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                [self.jiguanArray removeAllObjects];
                [self.gongzhongArray removeAllObjects];
                [self.shanggangTimeArray removeAllObjects];
                [self.gongzhongArray addObject:@{ @"id": @"",
                                                  @"name": @"不限" }];
                [self.shanggangTimeArray addObject:@"不限"];
                [self.jiguanArray addObjectsFromArray:dict[@"native_place"]];
                [self.gongzhongArray addObjectsFromArray:dict[@"stuff_work"]];
                [self.shanggangTimeArray addObjectsFromArray:dict[@"construction_time"]];
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
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSDictionary *params = @{ @"distance": self.distanceStr,
                              @"search_name": self.searchStr,
                              @"stuff_work_id": self.gongzhongId,
                              @"native_place": self.jiguanStr,
                              @"construction_time": self.shanggangTimeStr,
                              @"longitude": @([DZTools getAppDelegate].longitude),
                              @"latitude": @([DZTools getAppDelegate].latitude),
                              @"page": @(_page),
                              @"limit": @(20) };
    [DZNetworkingTool postWithUrl:kGongRenFindWorkList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                NSArray *array = dict[@"list"];

                for (NSDictionary *dict in array) {
                    GongRenFindWorkListModel *model = [GongRenFindWorkListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                if (self.dataArray.count == [dict[@"total"] integerValue]) {
                    [self.workTableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            [self.workTableView reloadData];
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
    return 110;
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
    findWorkingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"findWorkingCell" forIndexPath:indexPath];
    GongRenFindWorkListModel *model = self.dataArray[indexPath.row];
    if ([model.avatar containsString:@"http://"]) {
         [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    }else{
        NSString *url = [NSString stringWithFormat:@"http://zhuang.tainongnongzi.com%@",model.avatar];
         [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"img_head"]];
    }
   
    cell.nameLabel.text = model.username;
    cell.workTimeLabel.text = [NSString stringWithFormat:@"%@经验", model.work_year];
    cell.workKindLabel.text = model.name;
    cell.shanchangLabel.text = model.speciality;
    cell.jiguanLabel.text = model.native_place;
    cell.xinziLabel.text = [NSString stringWithFormat:@"%@",model.salary];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    FindDetailViewController *contentVC = [[FindDetailViewController alloc] init];
    GongRenFindWorkListModel *model = self.dataArray[indexPath.row];
    contentVC.jianliID = model.jobId;
    [self.navigationController pushViewController:contentVC animated:YES];
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (ybPopupMenu.tag == 100) { //籍贯回调
        [self.jiguanBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
        if (index == 0) {
            self.jiguanStr = @"";
        } else {
            self.jiguanStr = ybPopupMenu.titles[index];
        }
    } else if (ybPopupMenu.tag == 200) { //上岗时间
        [self.shanggangTimeBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
        if (index == 0) {
            self.shanggangTimeStr = @"";
        } else {
            self.shanggangTimeStr = ybPopupMenu.titles[index];
        }
    } else if (ybPopupMenu.tag == 300) { //工种
        for (NSDictionary *dict in self.gongzhongArray) {
            if ([ybPopupMenu.titles[index] isEqualToString:dict[@"name"]]) {
                self.gongzhongId = dict[@"id"];
            }
        }
        [self.gongzhongBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
    } else { //附近回调
        NSLog(@"点击了 %@ 选项", ybPopupMenu.titles[index]);
        [self.fujinBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
        switch (index) {
            case 0: {
                self.distanceStr = @"";
            } break;
            case 1: {
                self.distanceStr = @"1";
            } break;
            case 2: {
                self.distanceStr = @"3";
            } break;
            case 3: {
                self.distanceStr = @"10";
            } break;
                
            default:
                break;
        }
    }
    [self refresh];
}
#pragma mark - Function

- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.searchStr = [dic objectForKey:@"title"];
    [self refresh];
}
#pragma mark -- XibFunction
//附近点击
- (IBAction)fujinBtnClick:(id)sender {
    if (self.distanceArray.count > 0) {
        [YBPopupMenu showRelyOnView:sender
                             titles:self.distanceArray
                              icons:nil
                          menuWidth:ViewWidth / 4
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 400;
                          //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                      }];
    }
}
//全部工种
- (IBAction)qbgzBtnClick:(id)sender {
    if (self.gongzhongArray.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in self.gongzhongArray) {
            [temp addObject:dict[@"name"]];
        }
        [YBPopupMenu showRelyOnView:sender
                             titles:temp
                              icons:nil
                          menuWidth:ViewWidth / 4
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 300;
                          //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                      }];
    } else {
        [DZTools showNOHud:@"正在请求分类列表，请稍后重试！" delay:2.0];
        [self loadData];
    }
}
//籍贯
- (IBAction)jiguanBtnClick:(id)sender {
    if (self.jiguanArray.count > 0) {
        [YBPopupMenu showRelyOnView:sender
                             titles:self.jiguanArray
                              icons:nil
                          menuWidth:ViewWidth / 4
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 100;
                          //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                      }];
    } else {
        [DZTools showNOHud:@"正在请求分类列表，请稍后重试！" delay:2.0];
        [self loadData];
    }
}

//上岗时间
- (IBAction)workKindClick:(id)sender {
    if (self.shanggangTimeArray.count > 0) {
        [YBPopupMenu showRelyOnView:sender
                             titles:self.shanggangTimeArray
                              icons:nil
                          menuWidth:ViewWidth / 4
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 200;
                          //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                      }];
    } else {
        [DZTools showNOHud:@"正在请求分类列表，请稍后重试！" delay:2.0];
        [self loadData];
    }
}


//我的发布
- (IBAction)fabuBtnClick:(id)sender {

    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    FabujiluViewController *fabujiluViewController = [[FabujiluViewController alloc] init];

    [self.navigationController pushViewController:fabujiluViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//我要找工作
- (IBAction)findBtnClick:(id)sender {
    
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    [DZNetworkingTool postWithUrl:kShimingCheckIdauth params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            if ([responseObject[@"data"][@"is_auth_true"] intValue ] == 0) {
                //弹出框
                UIAlertController *alert = [UIAlertController
                                            alertControllerWithTitle:@"提示"
                                            message:@"您还没有实名认证，是否现在去实名认证？"
                                            preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"是"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *_Nonnull action) {
                                      //实名认证
#if TARGET_IPHONE_SIMULATOR
                                      NSLog(@"请用真机");
                                      
#elif TARGET_OS_IPHONE
//                                      JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
//                                      
//                                      AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image) {
//                                          if (info.name == nil || info.num == nil) {
//                                              [[DZTools topViewController].navigationController popViewControllerAnimated:YES];
//                                              [DZTools showText:@"请拍摄头像面" delay:2];
//                                          } else {
//                                              FrontViewController *viewController = [[FrontViewController alloc] init];
//                                              viewController.IDInfo = info;
//                                              [DZTools topViewController].hidesBottomBarWhenPushed = YES;
//                                              [[DZTools topViewController].navigationController pushViewController:viewController animated:YES];
//                                          }
//                                      };
//                                      self.hidesBottomBarWhenPushed = YES;
//                                      [self.navigationController pushViewController:AVCaptureVC animated:YES];
 # endif
                                  }]];
                [alert addAction:[UIAlertAction
                                  actionWithTitle:@"否"
                                  style:UIAlertActionStyleDefault
                                  handler:^(UIAlertAction *_Nonnull action) {
                                      [self.navigationController popViewControllerAnimated:YES];
                                  }]];
                //弹出提示框
                [self presentViewController:alert animated:true completion:nil];
                
            }else if ([responseObject[@"data"][@"is_auth_true"] intValue ] == 1){
                [DZTools showNOHud:@"实名认证中，不能发布招聘信息" delay:2];
                
            }else{
                self.hidesBottomBarWhenPushed = YES;
                FindFabujianliController *fabujiluViewController = [[FindFabujianliController alloc] init];
                [self.navigationController pushViewController:fabujiluViewController animated:YES];
                self.hidesBottomBarWhenPushed = YES;
                
            }
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
           [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}

@end
