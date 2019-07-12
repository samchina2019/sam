//
//  QiuziViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QiuziViewController.h"

#import "QiuziviewCell.h"

#import "YBPopupMenu.h"
#import "ReLayoutButton.h"

#import "GongRenFindWorkListModel.h"

//#import "JYBDIDCardVC.h"
#import "FrontViewController.h"
#import "FabujiluViewController.h"
#import "FabujianliViewController.h"
#import "QiuziDetailViewController.h"

@interface QiuziViewController () <YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *workTableView;

@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *erqiBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *gangweiBtn;
///距离
@property (strong, nonatomic) NSString *distanceStr;
///搜索关键字
@property (strong, nonatomic) NSString *searchStr;
///岗位
@property (strong, nonatomic) NSString *gangweiStr;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *gangweiTilteArray;
@property (strong, nonatomic) NSMutableArray *distanceArray;

@property (nonatomic) NSInteger page;
@end

@implementation QiuziViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self refresh];
    //    [self loadDetailData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
      //初始化数据
    self.distanceArray = [NSMutableArray arrayWithObjects:@"不限", @"1km内", @"3km内", @"10km内", nil];
    self.gangweiTilteArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.distanceStr = @"";
    self.searchStr = @"";
    self.gangweiStr = @"";
 
    //设置tableview
    self.sectionHeaderView.frame = CGRectMake(0, 0, ViewWidth, 40);
    self.workTableView.tableHeaderView = self.sectionHeaderView;
    [self.workTableView registerNib:[UINib nibWithNibName:@"QiuziviewCell" bundle:nil] forCellReuseIdentifier:@"QiuziviewCell"];
    [self.workTableView.mj_header beginRefreshing];
    
    self.workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.workTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"searchQiuzi" object:nil];
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
//加载岗位数据
- (void)loadData {
    [DZNetworkingTool postWithUrl:kQiyeEducatione
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            [self.gangweiTilteArray removeAllObjects];

            [self.gangweiTilteArray addObjectsFromArray:array];

        } else {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    }
    failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

        [DZTools showNOHud:RequestServerError delay:2.0];
    }
    IsNeedHub:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{ @"distance": self.distanceStr,
                              @"recruitment_post": self.gangweiStr,
                              @"longitude": @(longitude),
                              @"latitude": @(latitude),
                              @"page": @(_page),
                              @"limit": @(20) };
    [DZNetworkingTool postWithUrl:kYuanGongQiuZhiList
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
    return 87;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QiuziviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QiuziviewCell" forIndexPath:indexPath];
    GongRenFindWorkListModel *model = self.dataArray[indexPath.row];
    
    [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    cell.nameLabel.text = [NSString stringWithFormat:@"姓名:%@", model.realName];
    cell.gangweiLabel.text = [NSString stringWithFormat:@"岗位:%@", model.recruitment_post];
    cell.xueliLabel.text = [NSString stringWithFormat:@"学历:%@", model.education];
    cell.shijianLabel.text = [NSString stringWithFormat:@"工作时间:%@", model.work_year];

    if (model.salary.length==0) {
         cell.gongziLabel.text = [NSString stringWithFormat:@"¥0"];
    }else{
    cell.gongziLabel.text = [NSString stringWithFormat:@"¥%@", model.salary];
    }
   
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GongRenFindWorkListModel *model = self.dataArray[indexPath.row];
    QiuziDetailViewController *controller = [[QiuziDetailViewController alloc] init];
    controller.qiuziId = model.jobId;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma mark - Function
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (ybPopupMenu.tag == 100) { //附近回调
        NSLog(@"点击了 %@ 选项", ybPopupMenu.titles[index]);
        [self.erqiBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
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
    } else { //工种回调
        NSLog(@"点击了 %@ 选项", ybPopupMenu.titles[index]);
        [self.gangweiBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
        self.gangweiStr = ybPopupMenu.titles[index];
    }
    [self refresh];
}
//搜索数据的处理
- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.searchStr = [dic objectForKey:@"title"];
    [self refresh];
}
#pragma mark --XibFunction
//java工程师
- (IBAction)javaGongchengshiBtnClick:(id)sender {
    if (self.gangweiTilteArray.count > 0) {
    [YBPopupMenu showRelyOnView:sender
                         titles:self.gangweiTilteArray
                          icons:nil
                      menuWidth:140
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
        [DZTools showNOHud:@"正在请求列表，请稍后重试！" delay:2.0];
        [self loadData];
    }
}
//附近
- (IBAction)fujinBtnClick:(id)sender {
    if (self.distanceArray.count > 0) {
    [YBPopupMenu showRelyOnView:sender
                         titles:self.distanceArray
                          icons:nil
                      menuWidth:140
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
    }
}

//发布记录
- (IBAction)fabujiluBtnClick:(id)sender {
    //判断是否登录
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
                FabujiluViewController *fabujiluViewController = [[FabujiluViewController alloc] init];
                fabujiluViewController.isqiuzhi = YES;
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
//发布简历
- (IBAction)fabujianliBtnClick:(id)sender {
    //判断是否登录
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    
    self.hidesBottomBarWhenPushed = YES;
    
    FabujianliViewController *fabujianliViewController = [[FabujianliViewController alloc] init];
    [self.navigationController pushViewController:fabujianliViewController animated:YES];
    
    self.hidesBottomBarWhenPushed = YES;
 
}
@end
