//
//  DakaViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DakaViewController.h"

#import "WorkFabujiluController.h"
//cell
#import "ZidongTableViewCell.h"
//model
#import "DaKaListModel.h"

#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AVFoundation/AVFoundation.h>

#import "WAMediaPlayer.h"

@interface DakaViewController () <MAMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *workTableView;
//自动打卡按钮
@property (weak, nonatomic) IBOutlet UIButton *zidongDakaBtn;
//手动打卡
@property (weak, nonatomic) IBOutlet UIButton *shoudongDakaBtn;
//手动签到
@property (weak, nonatomic) IBOutlet UIButton *shoudongBtn;

// 定位管理器
@property (nonatomic, strong) MAMapView *map;
// 定位管理器
@property (nonatomic, strong) CLLocation *currentLocation;          //定位坐标
@property (nonatomic, strong) AMapLocationManager *locationManager; //定位管

@property (strong, nonatomic) NSMutableArray *zidongDakaDataArray;
@property (strong, nonatomic) NSMutableArray *shoudongDakaDataArray;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) DaKaListModel *model;

@property (nonatomic) NSInteger page;
///1为签到 2，签退 3，中午打卡
@property (nonatomic, assign) int type;
///群ID
@property (nonatomic, assign) int groupId;
///yes签到
@property (nonatomic, assign) BOOL isQiandao;
///yes自动打卡
@property (nonatomic, assign) BOOL isZidong;

@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *timeStr;
///声音播放器
@property (nonatomic, strong) WAMediaPlayer *player;

@end

@implementation DakaViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"打卡";

    [self initMapView];
    [self initTableView];
}
#pragma mark – UI
- (void)initTableView {
    [self.workTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.zidongDakaDataArray = [NSMutableArray array];
    self.shoudongDakaDataArray = [NSMutableArray array];

    self.workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.workTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.workTableView registerNib:[UINib nibWithNibName:@"ZidongTableViewCell" bundle:nil] forCellReuseIdentifier:@"ZidongTableViewCell"];
    [self.workTableView.mj_header beginRefreshing];
}
//MapView
- (void)initMapView {
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;

    self.map = [[MAMapView alloc] initWithFrame:self.bgView.bounds];
    self.map.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.map.delegate = self;
    //设置地图缩放比例，即显示区域
    [_map setZoomLevel:15.1 animated:YES];
    _map.mapType = MKMapTypeStandard;
    _map.userTrackingMode = MAUserTrackingModeFollow; //追踪用户的location更新
    _map.showsUserLocation = YES;                     //定位小蓝点
    //设置定位精度
    _map.desiredAccuracy = kCLLocationAccuracyBest;
    //设置定位距离
    _map.distanceFilter = kCLLocationAccuracyHundredMeters;

    [self.bgView addSubview:self.map];

    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;

    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
}
#pragma mark – Network
- (void)refresh {

    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    //    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{ @"lng": @(longitude),
                              @"lat": @(latitude),
    };
    [DZNetworkingTool postWithUrl:kGetClockinGroup
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            //获取数据
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];

                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    DaKaListModel *model = [DaKaListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.workTableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
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
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    ZidongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZidongTableViewCell" forIndexPath:indexPath];
    DaKaListModel *model = self.dataArray[indexPath.row];
    cell.gongdiLabel.text = [NSString stringWithFormat:@"%@", model.group_name];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@", model.address];
    if (model.gooff_time.length == 0 || model.clockin_time.length == 0) {
    cell.timelabel.text = @"暂未设置";
    }else{
    cell.timelabel.text = [NSString stringWithFormat:@"%@-%@", model.clockin_time, model.gooff_time];
    }
    if ([model.clockin isEqualToString:@"1"]) {
        cell.setBtn.hidden = NO;
        [cell.setBtn setTitle:@"当前" forState:UIControlStateNormal];
        [cell.setBtn setTitleColor:[UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1.0] forState:UIControlStateNormal];
        [cell.setBtn setBackgroundColor:[UIColor colorWithRed:76 / 255.0 green:217 / 255.0 blue:100 / 255.0 alpha:1.0]];
        cell.setBtn.layer.cornerRadius = 8.5;
    } else {
        cell.setBtn.hidden = YES;
    }
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    double dictence = [self distanceBetweenOrderBy:latitude:model.lat:longitude:model.lng];
    if (dictence < model.card_range) {
        cell.userInteractionEnabled = YES;
    } else {
        cell.userInteractionEnabled = NO;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DaKaListModel *model = self.dataArray[indexPath.row];
    self.model = model;
    self.groupId = model.group_id;
    self.nameStr=model.group_name;
    //获取当前时间
    [self getNowTimestamp];
    
    //    1:上班打卡2:下班打卡（早退）3:上班迟到打卡 4:午休开始打卡 5:午休结束打卡 6:下班打卡（早退）7：下班打卡
    if ([model.clockin_type intValue] == 1) {
        [self.shoudongBtn setTitle:@"上班打卡" forState:UIControlStateNormal];
        self.type = 1;
        
    } else if ([model.clockin_type intValue] == 2) {
        if ([model.gooffwork intValue] == 1) {
            self.type = 2;
            [self.shoudongBtn setTitle:@"更新打卡（早退）" forState:UIControlStateNormal];
        } else {
            self.type = 2;
            [self.shoudongBtn setTitle:@"下班打卡（早退）" forState:UIControlStateNormal];
        }
    } else if ([model.clockin_type intValue] == 3) {
        self.type = 1;
        [self.shoudongBtn setTitle:@"上班迟到打卡" forState:UIControlStateNormal];
    } else if ([model.clockin_type intValue] == 4) {
        self.type = 3;
        [self.shoudongBtn setTitle:@"午休开始打卡" forState:UIControlStateNormal];
    } else if ([model.clockin_type intValue] == 5) {
        self.type = 3;
        [self.shoudongBtn setTitle:@"午休结束打卡 " forState:UIControlStateNormal];
    } else if ([model.clockin_type intValue] == 6) {
        self.type = 2;
        [self.shoudongBtn setTitle:@"下班打卡（早退）" forState:UIControlStateNormal];
    } else if ([model.clockin_type intValue] == 7) {
        self.type = 2;
        [self.shoudongBtn setTitle:@"下班打卡" forState:UIControlStateNormal];
    }
    self.currentLocation = [[CLLocation alloc] initWithLatitude:model.lat longitude:model.lng];
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = self.currentLocation.coordinate; //设置地图的定位中心点坐标
    self.map.centerCoordinate = self.currentLocation.coordinate;
    ; //将点添加到地图上，即所谓的大头针
    [self.map addAnnotation:pointAnnotation];
   
    
    //******************************根据时间判断打卡类型*********************************//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//        // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
//
//        [formatter setDateFormat:@"YYYY-MM-dd"];
//
//        //现在时间,你可以输出来看下是什么格式
//
//        NSDate *datenow = [NSDate date];
//
//        //----------将nsdate按formatter格式转成nsstring
//
//        NSString *currentTimeString = [formatter stringFromDate:datenow];
//        NSString *time=[NSString stringWithFormat:@"%@ %@:00",currentTimeString,model.clockin_time];
//
//        NSInteger timeTamp=[self timeSwitchTimestamp:time andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];
//        NSString *lateTime=[NSString stringWithFormat:@"%@ %@:00",currentTimeString,model.gooff_time];
//        NSInteger laterTime=[self timeSwitchTimestamp:lateTime andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];
//
//        NSString *afteTime=[NSString stringWithFormat:@"%@ %@:00",currentTimeString,model.noon_start];
//        NSInteger afterTime=[self timeSwitchTimestamp:afteTime andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];
//
//        NSString *noonTime=[NSString stringWithFormat:@"%@ %@:00",currentTimeString,model.noon_end];
//        NSInteger noonrTime=[self timeSwitchTimestamp:noonTime andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];
//
    //    self.nameStr=model.group_name;
    //
    
    //    //根据时间的不同设置为签到或者签退
    //    //设置签到
    //    if (timeTamp>currenttimeTamp) {
    //
    //        self.isQiandao = YES;
    //        self.type = 1;
    //    }else{//签退
    //        self.type = 2;
    //        self.isQiandao = NO;
    //
    //    }
    //    //设置签到
    //    if (currenttimeTamp > afterTime) {
    //         self.type = 3;
    //
    //    }else{//签退
    //         self.type = 3;
    //
    //    }
    //    if (currenttimeTamp<noonrTime) {//中午签到
    //        self.type = 3;
    //
    //    }else{
    //        self.type = 3;
    //
    //    }
    //
    //    if(laterTime<currenttimeTamp){//签退
    //        self.isQiandao=YES;
    //        self.type = 2;
    //
    //    }else{
    //        self.type = 2;
    //        self.isQiandao=NO;
    //
    //    }
    //******************************根据时间判断打卡类型*********************************//
}
#pragma mark - 将某个时间转化成 时间戳

- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate

    //时间转时间戳的方法:

    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];

    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld", (long) timeSp); //时间戳的值

    return timeSp;
}
//获取现在时间
- (NSInteger)getNowTimestamp {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date]; //现在时间

    NSLog(@"设备当前的时间:%@", [formatter stringFromDate:datenow]);
    self.timeStr = [NSString stringWithFormat:@"%@", [formatter stringFromDate:datenow]];
    //时间转时间戳的方法:

    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];

    NSLog(@"设备当前的时间戳:%ld", (long) timeSp); //时间戳的值

    return timeSp;
}
//计算两点之间的距离
- (double)distanceBetweenOrderBy:(double)lat1:(double)lat2:(double)lng1:(double)lng2 {

    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];

    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];

    double distance = [curLocation distanceFromLocation:otherLocation];

    return distance;
}

//自动/手动打卡按钮的事件
- (IBAction)dakaBtnClick:(id)sender {

    if (self.zidongDakaBtn.selected) {

        self.zidongDakaBtn.selected = !self.zidongDakaBtn.selected;
        self.shoudongDakaBtn.selected = YES;

    } else {
        self.shoudongDakaBtn.selected = !self.shoudongDakaBtn.selected;
        self.zidongDakaBtn.selected = YES;
    }
}

#pragma mark--XibFunction
//手动签退事件
- (IBAction)shoudongQtBtnClick:(id)sender {
    if (self.nameStr.length == 0) {
        [DZTools showNOHud:@"请选择您的群" delay:2];
        return;
    }
    if (self.timeStr.length == 0) {
        [DZTools showNOHud:@"请选择您的群" delay:2];
        return;
    }
    //弹出信息设置
    NSString *message = [NSString stringWithFormat:@"群组名称：%@\n打卡时间：%@", self.nameStr, self.timeStr];
    [self showAlert:message];
}
//显示信息
- (void)showAlert:(NSString *)messageMsg {

    if (self.groupId == 0) {
        [DZTools showNOHud:@"请选择群以后再打卡" delay:2];
        return;
    }
    // 1.弹框提醒
    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定打卡" message:messageMsg preferredStyle:UIAlertControllerStyleAlert];
    //添加点击事件
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           double latitude = [DZTools getAppDelegate].latitude;
                                                           double longitude = [DZTools getAppDelegate].longitude;

                                                           NSDictionary *dict = @{
                                                               @"lng": @(longitude),
                                                               @"lat": @(latitude),
                                                               @"group_id": @(self.groupId),
                                                               @"type": @(self.type)
                                                           };
                                                           [DZNetworkingTool postWithUrl:kClockIn
                                                               params:dict
                                                               success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                   if ([responseObject[@"code"] intValue] == SUCCESS) {
                                                                       [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                                                       if (self.zidongDakaBtn.selected) {
                                                                           [DaKaListModel saveDakaInfo:self.model];
                                                                       } else {
                                                                           [DaKaListModel deledakaInfo];
                                                                       }

                                                                       NSDictionary *dict = responseObject[@"data"];
                                                                       NSString *urlStr = dict[@"data"];
                                                                       NSURL *url = [NSURL URLWithString:urlStr];
                                                                       //
                                                                       //                //播放声音
                                                                       //                AVAudioSession *session = [AVAudioSession sharedInstance];
                                                                       //                [session setCategory:AVAudioSessionCategoryPlayback error:nil];
                                                                       //                [session setActive:YES error:nil];

                                                                       //                //播放器设置为全局变量，以免没有外音
                                                                       //                self.songItem = [[AVPlayerItem alloc]initWithURL:url];
                                                                       //                self.player = [[AVPlayer alloc]initWithPlayerItem:self.songItem];
                                                                       //播放声音
                                                                       //                [self.player play];

                                                                       ///代测试
                                                                       [self.player playAudioWithURL:url];
                                                                   } else {
                                                                       [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                                                   }

                                                               }
                                                               failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                                                   [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                                               }
                                                               IsNeedHub:NO];
                                                       }];

    [alert addAction:sureAction];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
    
}

@end
