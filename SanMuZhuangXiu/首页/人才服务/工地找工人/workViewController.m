//
//  workViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "workViewController.h"
#import "WorkFabujiluController.h"
#import "workViewCell.h"
#import "WorkZhaogongrenController.h"
#import "gangweiDetailViewController.h"
#import "GongdiWorkModel.h"
#import "YBPopupMenu.h"
#import "ReLayoutButton.h"
#import "GongZhangRenZhengViewController.h"

@interface workViewController () <YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet ReLayoutButton *shanggangTimeBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiguanBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *fujinBtn;
@property (weak, nonatomic) IBOutlet UITableView *workTableView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *gongzhongBtn;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;

@property (nonatomic, strong) NSMutableArray *jiguanArray;
@property (nonatomic, strong) NSMutableArray *gongzhongArray;
@property (nonatomic, strong) NSMutableArray *shanggangTimeArray;
@property (nonatomic, strong) NSMutableArray *distanceArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
///籍贯
@property (nonatomic, strong) NSString *jiguanStr;
///上岗时间
@property (nonatomic, strong) NSString *shanggangTimeStr;
///工种ID
@property (nonatomic, strong) NSString *gongzhongId;
///距离
@property (nonatomic, strong) NSString *distanceStr;
///关键字
@property (nonatomic, strong) NSString *searchStr;

@property (nonatomic) NSInteger page;

@end

@implementation workViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//if ([DZTools islogin]) {
    [self loadData];
//  }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.sectionHeaderView.frame = CGRectMake(0, 0, ViewWidth, 40);
    self.workTableView.tableHeaderView = self.sectionHeaderView;
    [self.workTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.jiguanArray = [NSMutableArray array];
    self.gongzhongArray = [NSMutableArray array];
    self.shanggangTimeArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.distanceArray = [NSMutableArray arrayWithObjects:@"不限", @"1km内", @"3km内", @"10km内", nil];

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

    [self.workTableView registerNib:[UINib nibWithNibName:@"workViewCell" bundle:nil] forCellReuseIdentifier:@"workViewCell"];
    [self.workTableView.mj_header beginRefreshing];

    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"searchGongdi" object:nil];
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

- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSDictionary *params = @{ @"distance": self.distanceStr,
                              @"search_name": self.searchStr,
                              @"work_stuff_id": self.gongzhongId,
                              @"native_place": self.jiguanStr,
                              @"construction_time": self.shanggangTimeStr,
                              @"longitude": @([DZTools getAppDelegate].longitude),
                              @"latitude": @([DZTools getAppDelegate].latitude),
                              @"page": @(_page),
                              @"limit": @(20) };
    [DZNetworkingTool postWithUrl:kRecruitList
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
                    GongdiWorkModel *model = [GongdiWorkModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                NSLog(@"--*******---%@", self.dataArray);

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
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    workViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"workViewCell" forIndexPath:indexPath];
    GongdiWorkModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.name];
    cell.payLabel.text = [NSString stringWithFormat:@"¥%@", model.salary];

    cell.enjoyLabel.text = model.speciality;
    NSString *zhuStr = @"";

    //    是否提供住宿：10=是；20=否；
    if ([model.putup isEqualToString:@"10"]) {
        zhuStr = @"包住宿";
    } else {
        zhuStr = @"不包住宿";
    }

    cell.moneyLabel.text = [NSString stringWithFormat:@"%@  工资%@", zhuStr, model.settlement_time];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@", model.work_address, model.work_addressInfo];
    cell.timeLabel.text = [NSString stringWithFormat:@"%@发布", model.createtime];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GongdiWorkModel *model = self.dataArray[indexPath.row];
    gangweiDetailViewController *contentVC = [[gangweiDetailViewController alloc] init];
    contentVC.idStr = model.lookId;
    [self.navigationController pushViewController:contentVC animated:YES];
}

#pragma mark - Function

- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.searchStr = [dic objectForKey:@"title"];
    [self refresh];
}

#pragma mark-- XibFunction
//附近
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
    self.gongzhongBtn.selected = YES;
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
    self.jiguanBtn.selected = YES;
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
    self.shanggangTimeBtn.selected = YES;
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

//发布记录
- (IBAction)fabuBtnClick:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    WorkFabujiluController *fabujiluViewController = [[WorkFabujiluController alloc] init];

    [self.navigationController pushViewController:fabujiluViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//招工人
- (IBAction)findBtnClick:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    
    [DZNetworkingTool postWithUrl:kMyForemanAuth
                           params:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
      if ([responseObject[@"code"] intValue] == SUCCESS) {
          if ([responseObject[@"data"][@"is_auth_foreman"] intValue] == 0) {
              //跳转到工长认证
              GongZhangRenZhengViewController *viewController = [GongZhangRenZhengViewController new];
              self.hidesBottomBarWhenPushed = YES;
              [self.navigationController pushViewController:viewController animated:YES];
          } else if ([responseObject[@"data"][@"is_auth_foreman"] intValue] == 1) {
              [DZTools showNOHud:@"工长认证中，不能建群" delay:2];
          } else if ([responseObject[@"data"][@"is_auth_foreman"] intValue] == 2) {
          self.hidesBottomBarWhenPushed = YES;
          WorkZhaogongrenController *zhaopingongrenViewController = [[WorkZhaogongrenController alloc] init];
          [self.navigationController pushViewController:zhaopingongrenViewController animated:YES];
          self.hidesBottomBarWhenPushed = YES;
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

@end
