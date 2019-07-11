//
//  ChaichuFuwuViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ChaichuFuwuViewController.h"
#import "ServerBrowseHistoryListCell.h"
#import "MyFabuListViewController.h"
#import "ChaichuDetailViewController.h"
#import "ChaiChuFabuViewController.h"
#import "FrontViewController.h"
//#import "JYBDIDCardVC.h"
#import "YBPopupMenu.h"
#import "ReLayoutButton.h"
#import "FuwuListModel.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

@interface ChaichuFuwuViewController () <CLLocationManagerDelegate, YBPopupMenuDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet ReLayoutButton *tuijianBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *fujinBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *diquBtn;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *areaListArray;
@property (strong, nonatomic) NSMutableArray *onlyClassTilteArray;

/// 定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;

///1最新排序
@property (nonatomic, assign) int is_new;
///1由近及远排序（当条件为1时，必须给经纬度）
@property (nonatomic, assign) int is_near;
///区县筛选地址
@property (nonatomic, strong) NSString *area;
@property (nonatomic) NSInteger page;

@end

@implementation ChaichuFuwuViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initLococation];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.navigationItem.title = @"最新发布";

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.areaListArray = [NSMutableArray array];
    self.onlyClassTilteArray = [NSMutableArray arrayWithObjects:@"推荐", @"最新", nil];

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    //    self.tableView.style=;
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"ServerBrowseHistoryListCell" bundle:nil] forCellReuseIdentifier:@"ServerBrowseHistoryListCell"];
    [self.tableView.mj_header beginRefreshing];
    self.area = @"郑州市";
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
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{ @"category_id": @(self.fuwuId),
                              @"page": @(_page),
                              @"is_new": @(self.is_new),
                              @"is_near": @(self.is_near),
                              @"lng": @(longitude),
                              @"lat": @(latitude),
                              @"city": self.area

    };
    [DZNetworkingTool postWithUrl:kGetRecruitList
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
                    FuwuListModel *model = [FuwuListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.areaListArray removeAllObjects];
                NSArray *tempArray = responseObject[@"data"][@"area_list"];
                for (NSDictionary *dict in tempArray) {
                    [self.areaListArray addObject:dict];
                }

                [self.tableView reloadData];

                if (self.dataArray.count == [dict[@"total"] intValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.areaListArray removeAllObjects];
                NSArray *tempArray = responseObject[@"data"][@"area_list"];
                for (NSDictionary *dict in tempArray) {
                    [self.areaListArray addObject:dict];
                }
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
#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];

    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *array, NSError *error) {
                       if (array.count > 0) {
                           CLPlacemark *placemark = [array objectAtIndex:0];
                           //             NSLog(@"????%@",placemark);
                           //获取城市
                           NSString *currCity = placemark.locality;
                           if (!currCity) {
                               //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                               currCity = placemark.administrativeArea;
                           }

                           [self.diquBtn setTitle:[NSString stringWithFormat:@"%@", placemark.locality] forState:UIControlStateNormal];
                           self.area = placemark.locality;

                       } else if (error == nil && [array count] == 0) {
                           NSLog(@"No results were returned.");
                       } else if (error != nil) {
                           NSLog(@"An error occurred = %@", error);
                       }

                   }];
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
    return 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ServerBrowseHistoryListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServerBrowseHistoryListCell" forIndexPath:indexPath];
    FuwuListModel *model = self.dataArray[indexPath.row];
    cell.titleLabel.text = model.title;
    cell.serverLabel.text = [NSString stringWithFormat:@"%@ (%@)", model.name, model.city];
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@", model.price];
    cell.jieshaoLabel.text = model.note;
    cell.timeLabel.text = [NSString stringWithFormat:@"%@", model.createtime];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FuwuListModel *model = self.dataArray[indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    ChaichuDetailViewController *controller = [[ChaichuDetailViewController alloc] init];
    controller.fuwuId = model.lookId;
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (ybPopupMenu.tag == 100) { //地区回调

        [self.diquBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
        [self loadAllDataWithTitle:ybPopupMenu.titles[index]];
    }
    if (ybPopupMenu.tag == 200) {
        //推荐回调
        NSLog(@"点击了 %@ 选项", ybPopupMenu.titles[index]);
        self.is_new = [NSString stringWithFormat:@"%ld", index];
        [self.tuijianBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
    }
    [self refresh];
}
#pragma mark - Function
//选择地区后加载数据
- (void)loadAllDataWithTitle:(NSString *)title {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{ @"category_id": @(self.fuwuId),
                              @"page": @(_page),
                              @"is_new": @(self.is_new),
                              @"is_near": @(self.is_near),
                              @"lng": @(longitude),
                              @"lat": @(latitude),
                              @"city": self.area,
                              @"area": title

    };
    [DZNetworkingTool postWithUrl:kGetRecruitList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                NSArray *array = responseObject[@"data"][@"list"];
                for (NSDictionary *dict in array) {
                    FuwuListModel *model = [FuwuListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.areaListArray removeAllObjects];
                NSArray *tempArray = responseObject[@"data"][@"area_list"];
                for (NSDictionary *dict in tempArray) {
                    [self.areaListArray addObject:dict];
                }

                [self.tableView reloadData];

                if (self.dataArray.count == [dict[@"total"] intValue]) {
                    [self.tableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {

                [self.dataArray removeAllObjects];
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

            [self.tableView reloadData];
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)initLococation {
    [[DZTools getAppDelegate].locationManager startUpdatingLocation];
    //判断定位操作是否被允许

    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters; //每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    } else {
        //提示用户无法进行定位操作
        NSLog(@"%@", @"定位服务当前可能尚未打开，请设置打开！");
    }
}

#pragma mark - XibFunction
- (IBAction)myFabuJiluClicked:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MyFabuListViewController *myPublishViewController = [[MyFabuListViewController alloc] init];
    myPublishViewController.fuwuId = self.fuwuId;
    myPublishViewController.fuwuName = self.fuwuName;
    [self.navigationController pushViewController:myPublishViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
- (IBAction)ChaichuFabuClicked:(id)sender {
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
                                      
#else
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
//                                      
//                                      self.hidesBottomBarWhenPushed = YES;
//                                      [self.navigationController pushViewController:AVCaptureVC animated:YES];
                                       #endif
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
                ChaiChuFabuViewController *controller = [[ChaiChuFabuViewController alloc] init];
                controller.fuwuId = self.fuwuId;
                controller.navigationItem.title = @"发布";
                controller.isFromDetail = NO;
                controller.fuwuName = self.fuwuName;
                [self.navigationController pushViewController:controller animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            }
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
  
}

//最新
- (IBAction)tuijianBtnClicked:(UIButton *)sender {

    sender.selected = !sender.selected;

    if (sender.selected) {
        self.fujinBtn.selected = NO;
        self.diquBtn.selected = NO;
    }

    if (self.onlyClassTilteArray.count > 0) {
        [YBPopupMenu showRelyOnView:sender
                             titles:self.onlyClassTilteArray
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
        //        [HUTools showNOHud:Localized(@"正在请求分类列表，请稍后重试！") delay:2.0];
        //        [self loadData];
    }
}
//附近
- (IBAction)fujinBtnClicked:(UIButton *)sender {

    sender.selected = !sender.selected;

    if (sender.selected) {
        self.tuijianBtn.selected = NO;
        self.diquBtn.selected = NO;
    }
    self.is_near = 1;
    [self refresh];
}
//地区的选择
- (IBAction)diquBtnClicked:(UIButton *)sender {
    sender.selected = !sender.selected;

    if (sender.selected) {
        self.tuijianBtn.selected = NO;
        self.fujinBtn.selected = NO;
    }

    if (self.areaListArray.count > 0) {
        NSMutableArray *temp = [NSMutableArray array];
        for (NSDictionary *dict in self.areaListArray) {
            [temp addObject:dict[@"name"]];
        }
        [YBPopupMenu showRelyOnView:sender
                             titles:temp
                              icons:nil
                          menuWidth:ViewWidth
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
//        [self loadData];
    }
}

@end
