//
//  WodeKaoqinViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "WodeKaoqinViewController.h"
#import "MyCalendar.h"
#import "CalendarDateView.h"
#import "BaoBiaoDetailViewController.h"
#import "WodeDakaModel.h"
#import "ReLayoutButton.h"

@interface WodeKaoqinViewController ()
@property (weak, nonatomic) IBOutlet ReLayoutButton *selectGongdiBtn;
@property (weak, nonatomic) IBOutlet UIView *dakaView;
@property (weak, nonatomic) IBOutlet UIView *kaoqingView;
@property (weak, nonatomic) IBOutlet UIView *tongjiView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIScrollView *shensuView;
@property (weak, nonatomic) IBOutlet UILabel *wuxiuAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *yichangLabel;
@property (weak, nonatomic) IBOutlet UIButton *xiabanYichangBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *yuetongjiBtn;
@property (weak, nonatomic) IBOutlet UIButton *shangbanYichangBtn;
@property (weak, nonatomic) IBOutlet UILabel *nowMouth;      // 日历标题
@property (weak, nonatomic) IBOutlet UIView *weekView;       // 周日到周六
@property (nonatomic, strong) IBOutlet MyCalendar *calendar; // 日历
@property (weak, nonatomic) IBOutlet UILabel *wuxiuLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstHeight; // 日历高度
@property (weak, nonatomic) IBOutlet UILabel *selectDate;                 // 显示选中的label

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *tongjiTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuxiudaoAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuxiuTuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *wuxiuTuiAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongjiriLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiabanDakaLabel;
@property (weak, nonatomic) IBOutlet UIButton *wuxiuyichangBtn;

@property (weak, nonatomic) IBOutlet UIButton *wuxiuTuiyichangBtn;
@property (weak, nonatomic) IBOutlet UILabel *tongjijiabanLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuanggongLabel;
@property (weak, nonatomic) IBOutlet UILabel *zaotuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *chidaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *dakashangLabel;
@property (weak, nonatomic) IBOutlet UILabel *dakaTimeLabel;

@property (weak, nonatomic) IBOutlet UILabel *dakaAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiantuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *qiantuiAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiabanLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiabanAddressLabel;
@property (weak, nonatomic) IBOutlet UITextField *shensuReasionText;
@property (weak, nonatomic) IBOutlet UILabel *wuxiuDaoLabel;

@property (weak, nonatomic) IBOutlet ReLayoutButton *shnsuYYBtn;
@property (weak, nonatomic) IBOutlet UITextView *yuanyinTextView;

@property (nonatomic, strong) NSMutableArray *monthArray;
@property (nonatomic, strong) NSMutableArray *listArray;
@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSArray *tongjiArray;

@property (nonatomic, copy) NSString *selectDatePicker;
///是否月统计 yes是月统计
@property (nonatomic, assign) BOOL isYueTongji;
///群ID
@property (nonatomic, assign) int groupId;
///上班打卡 ID
@property (nonatomic, assign) NSInteger clockinS_id;
///打卡ID
@property (nonatomic, assign) NSInteger clockinId;
///下班打卡ID
@property (nonatomic, assign) NSInteger clockinX_id;
///中午打上班卡ID
@property (nonatomic, assign) NSInteger clockinWS_id;
///中午打下班卡ID
@property (nonatomic, assign) NSInteger clockinWT_id;

@end

@implementation WodeKaoqinViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadListData];
    
    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的考勤";
    
    self.monthArray = [NSMutableArray array];
    self.listArray = [NSMutableArray array];
    self.tongjiArray = @[@"月统计", @"年统计"];

    [self initCollectionView];
    [self initBasicView];
    self.calendar.layer.cornerRadius = 3;

    //信息获取不到的时候的设置
    self.dakashangLabel.text = @"";
    self.dakaAddressLabel.text = @"";
    self.shangbanYichangBtn.hidden = YES;
    self.xiabanDakaLabel.text = @"";
    self.qiantuiAddressLabel.text = @"";
    self.xiabanYichangBtn.hidden = YES;
    self.wuxiuDaoLabel.text = @"";
    self.wuxiudaoAddressLabel.text = @"";
    self.wuxiuyichangBtn.hidden = YES;
    self.wuxiuTuiLabel.text = @"";
    self.wuxiuTuiAddressLabel.text = @"";
    self.wuxiuTuiyichangBtn.hidden = YES;
    self.jiabanLabel.text = @"";
    self.jiabanAddressLabel.text = @"";
    self.qiantuiLabel.text = @"";
    
    self.tongjiriLabel.text = [NSString stringWithFormat:@"总计日工：0"];
    self.tongjijiabanLabel.text = [NSString stringWithFormat:@"累计加班工时：0"];
    self.chidaoLabel.text = [NSString stringWithFormat:@"迟到次数：0"];
    self.zaotuiLabel.text = [NSString stringWithFormat:@"早退次数：0"];
    self.kuanggongLabel.text = [NSString stringWithFormat:@"旷工次数：0"];
    
}
#pragma mark – UI

- (void)initBasicView {
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);

    //阴影的颜色
    self.kaoqingView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.kaoqingView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.kaoqingView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.kaoqingView.layer.shadowOffset = CGSizeMake(0, 0);

    //阴影的颜色
    self.tongjiView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.tongjiView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.tongjiView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.tongjiView.layer.shadowOffset = CGSizeMake(0, 0);
    __weak typeof(self) weakSelf = self;
    _calendar.returnTitleValueBlock = ^(NSString *strValue) {
        weakSelf.nowMouth.text = strValue;
    };
}

- (void)initCollectionView {

    [_calendar registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];
    self.calendar.isComeBaobiao = NO;
    [_calendar initDataSource];

    _weekArray = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    for (int i = 0; i < self.weekArray.count; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(((ViewWidth - 60) / 7) * i + 10, 10, (ViewWidth - 60) / 7, 30)];
        label.text = self.weekArray[i];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"Helvetica-Bold" size:(15)];
        if (i == 0 || i == self.weekArray.count - 1) {
            label.textColor = UIColorFromRGB(0xFC5458);
        } else {
            label.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
        }
        [self.weekView addSubview:label];
    }

    __weak typeof(self) weakSelf = self;
    _calendar.returnValueBlock = ^(NSString *strValue) {
        weakSelf.selectDate.text = [NSString stringWithFormat:@"%@", strValue];
        [weakSelf loadDataForDay];
    };

    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", (long)_calendar.year, (long)_calendar.month];
    //    // 今天是今年的第多少周

    self.selectDate.text = [NSString stringWithFormat:@"%ld-%ld-%ld ", (long) _calendar.year, (long) _calendar.month, (long)_calendar.day];
}

#pragma mark – Network
//获取群信息
- (void)loadListData {

    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *dict = @{
        @"lng": @(longitude),
        @"lat": @(latitude)
    };
    [DZNetworkingTool postWithUrl:kGetClockinGroup
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                NSArray *array = responseObject[@"data"];
                [self.listArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    WodeDakaModel *model = [WodeDakaModel mj_objectWithKeyValues:dict];
                    [self.listArray addObject:model];
                }
                WodeDakaModel *model = self.listArray[0];
                self.groupId = model.group_id;
                
                [self.shnsuYYBtn setTitle:model.group_name forState:UIControlStateNormal];
                [self.selectGongdiBtn setTitle:model.group_name forState:UIControlStateNormal];
                
                [self loadData];
                [self dakaDetail];
                [self loadDataForDay];
            } else {

                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
//获取群日历
- (void)loadData {
    if (self.groupId == 0) {
        [DZTools showNOHud:@"请选择下面的群" delay:2];
        return;
    }
    NSDictionary *dict = @{
        @"month_date": self.nowMouth.text,
        @"group_id": @(self.groupId)
    };
    NSLog(@",,,,,,,%@", dict);
    [DZNetworkingTool postWithUrl:kClockinCount
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];
                [self.monthArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    [self.monthArray addObject:dict];
                }
                self.calendar.titleArray = self.monthArray;
                [self.calendar reloadData];
            } else {

                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
//获取当月详情
- (void)dakaDetail {

    self.isYueTongji = YES;
    if (self.groupId == 0) {
        [DZTools showNOHud:@"请选择下面的群" delay:2];
        return;
    }
    NSDictionary *dict = @{
        @"month_date": self.nowMouth.text,
        @"group_id": @(self.groupId)
    };
    NSLog(@",,,,,,,%@", dict);
    [DZNetworkingTool postWithUrl:kMonthCount
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.tongjiriLabel.text = [NSString stringWithFormat:@"总计日工：%@", dict[@"total"]];
                self.tongjijiabanLabel.text = [NSString stringWithFormat:@"累计加班工时：%@", dict[@"cumulative"]];
                self.chidaoLabel.text = [NSString stringWithFormat:@"迟到次数：%@", dict[@"late"]];
                self.zaotuiLabel.text = [NSString stringWithFormat:@"早退次数：%@", dict[@"leave_early"]];
                self.kuanggongLabel.text = [NSString stringWithFormat:@"旷工次数：%@", dict[@"absenteeism"]];
            } else {

                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
//获取当天信息
- (void)loadDataForDay {
    //    kGetDateClockin
    if ([self.selectDate.text isKindOfClass:[NSNull class]]) {
        [DZTools showNOHud:@"请选择日期" delay:2];
        return;
    }
    NSDictionary *dict = @{
        @"month_date": self.selectDate.text,
        @"group_id": @(self.groupId)
    };
    NSLog(@",,,,,,,%@", dict);
    [DZNetworkingTool postWithUrl:kGetDateClockin
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                NSDictionary *dict = responseObject[@"data"][@"day_work"];
                
                self.dakaTimeLabel.text = [NSString stringWithFormat:@"%@日打卡%@次，工时共计%@工时", self.selectDate.text, responseObject[@"data"][@"second"], responseObject[@"data"][@"work_time"]];
                
                NSDictionary *day = dict[@"gowork"];//上班信息
                if ([day allKeys].count == 0) {
                    self.dakashangLabel.text = @"";
                    self.dakaAddressLabel.text = @"";
                    self.shangbanYichangBtn.hidden = YES;
                } else {
                    if ([day[@"status"] intValue] == 2) {
                        self.shangbanYichangBtn.hidden = NO;
                        self.dakashangLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day[@"clockin_time"], day[@"gowork_time"]];
                        self.dakaAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day[@"address"]];
                    } else if ([day[@"status"] intValue] == 3) {
                        self.dakashangLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day[@"clockin_time"], day[@"gowork_time"]];
                        self.dakaAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day[@"address"]];
                        self.shangbanYichangBtn.hidden = NO;
                    } else if ([day[@"status"] intValue] == 4) {
                        self.dakashangLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day[@"clockin_time"], day[@"gowork_time"]];
                        self.dakaAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day[@"address"]];
                        self.shangbanYichangBtn.hidden = NO;
                    } else if ([day[@"status"] intValue] == 5) {
                        self.dakashangLabel.text = @"缺卡";
                        self.dakaAddressLabel.text = @"";
                        self.shangbanYichangBtn.hidden = YES;
                    } else if ([day[@"status"] intValue] == 6) {
                        self.dakashangLabel.text = @"休息";
                        self.dakaAddressLabel.text = @"";
                        self.shangbanYichangBtn.hidden = YES;
                    } else {
                        self.dakashangLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day[@"clockin_time"], day[@"gowork_time"]];
                        self.dakaAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day[@"address"]];
                        self.shangbanYichangBtn.hidden = YES;
                    }
                    self.clockinS_id = [day[@"clockin_log_id"] integerValue];
                }

                NSDictionary *xiaban = dict[@"towork"];//下班信息
                if ([xiaban allKeys].count == 0) {
                    self.xiabanDakaLabel.text = @"";
                    self.qiantuiAddressLabel.text = @"";
                    self.xiabanYichangBtn.hidden = YES;
                } else {
                    if ([xiaban[@"status"] intValue] == 2) {
                        self.xiabanYichangBtn.hidden = NO;
                        self.xiabanDakaLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban[@"clockin_time"], xiaban[@"gowork_time"]];
                        self.qiantuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban[@"address"]];
                    } else if ([xiaban[@"status"] intValue] == 3) {
                        self.xiabanDakaLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban[@"clockin_time"], xiaban[@"gowork_time"]];
                        self.qiantuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban[@"address"]];
                        self.xiabanYichangBtn.hidden = NO;
                    } else if ([xiaban[@"status"] intValue] == 4) {
                        self.xiabanDakaLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban[@"clockin_time"], xiaban[@"gowork_time"]];
                        self.qiantuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban[@"address"]];
                        self.xiabanYichangBtn.hidden = NO;
                    } else if ([xiaban[@"status"] intValue] == 5) {
                        self.xiabanDakaLabel.text = @"缺卡";
                        self.qiantuiAddressLabel.text = @"";
                        self.xiabanYichangBtn.hidden = YES;
                    } else if ([xiaban[@"status"] intValue] == 6) {
                        self.xiabanDakaLabel.text = @"休息";
                        self.qiantuiAddressLabel.text = @"";
                        self.xiabanYichangBtn.hidden = YES;
                    } else {
                        self.xiabanDakaLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban[@"clockin_time"], xiaban[@"gowork_time"]];
                        self.qiantuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban[@"address"]];
                        self.xiabanYichangBtn.hidden = YES;
                    }
                    self.clockinX_id = [xiaban[@"clockin_log_id"] integerValue];
                }
                NSDictionary *noon = responseObject[@"data"][@"noon_break"];
                NSDictionary *day1 = noon[@"gowork"];//中午上班信息
                if ([day1 allKeys].count == 0) {
                    self.wuxiuDaoLabel.text = @"";
                    self.wuxiudaoAddressLabel.text = @"";
                    self.wuxiuyichangBtn.hidden = YES;
                } else {
                    if ([day1[@"status"] intValue] == 2) {
                        self.wuxiuyichangBtn.hidden = NO;
                        self.wuxiuDaoLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day1[@"clockin_time"], day1[@"gowork_time"]];
                        self.wuxiudaoAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day1[@"address"]];
                    } else if ([day1[@"status"] intValue] == 3) {
                        self.wuxiuDaoLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day1[@"clockin_time"], day1[@"gowork_time"]];
                        self.wuxiudaoAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day1[@"address"]];
                        self.wuxiuyichangBtn.hidden = NO;
                    } else if ([day1[@"status"] intValue] == 4) {
                        self.wuxiuDaoLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day1[@"clockin_time"], day1[@"gowork_time"]];
                        self.wuxiudaoAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day1[@"address"]];
                        self.wuxiuyichangBtn.hidden = NO;
                    } else if ([day1[@"status"] intValue] == 5) {
                        self.wuxiuDaoLabel.text = @"缺卡";
                        self.wuxiudaoAddressLabel.text = @"";
                        self.wuxiuyichangBtn.hidden = YES;
                    } else if ([day1[@"status"] intValue] == 6) {
                        self.wuxiuDaoLabel.text = @"休息";
                        self.wuxiudaoAddressLabel.text = @"";
                        self.wuxiuyichangBtn.hidden = YES;
                    } else {
                        self.wuxiuDaoLabel.text = [NSString stringWithFormat:@"打卡时间:%@(上班时间:%@)", day1[@"clockin_time"], day1[@"gowork_time"]];
                        self.wuxiudaoAddressLabel.text = [NSString stringWithFormat:@"地址:%@", day1[@"address"]];
                        self.wuxiuyichangBtn.hidden = YES;
                    }
                    self.clockinWS_id = [day1[@"clockin_log_id"] integerValue];
                }

                NSDictionary *xiaban1 = dict[@"towork"]; //中午下班信息
                if ([xiaban1 allKeys].count == 0) {
                    self.wuxiuTuiLabel.text = @"";
                    self.wuxiuTuiAddressLabel.text = @"";
                    self.wuxiuTuiyichangBtn.hidden = YES;
                } else {
                    if ([xiaban1[@"status"] intValue] == 2) {
                        self.wuxiuTuiyichangBtn.hidden = NO;
                        self.wuxiuTuiLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban1[@"clockin_time"], xiaban1[@"gowork_time"]];
                        self.wuxiuTuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban1[@"address"]];
                    } else if ([xiaban1[@"status"] intValue] == 3) {
                        self.wuxiuTuiLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban1[@"clockin_time"], xiaban1[@"gowork_time"]];
                        self.wuxiuTuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban1[@"address"]];
                        self.wuxiuTuiyichangBtn.hidden = NO;
                    } else if ([xiaban1[@"status"] intValue] == 4) {
                        self.wuxiuTuiLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban1[@"clockin_time"], xiaban1[@"gowork_time"]];
                        self.wuxiuTuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban1[@"address"]];
                        self.wuxiuTuiyichangBtn.hidden = NO;
                    } else if ([xiaban1[@"status"] intValue] == 5) {
                        self.wuxiuTuiLabel.text = @"缺卡";
                        self.wuxiuTuiAddressLabel.text = @"";
                        self.wuxiuTuiyichangBtn.hidden = YES;
                    } else if ([xiaban1[@"status"] intValue] == 6) {
                        self.wuxiuTuiLabel.text = @"休息";
                        self.wuxiuTuiAddressLabel.text = @"";
                        self.wuxiuTuiyichangBtn.hidden = YES;
                    } else {
                        self.wuxiuTuiLabel.text = [NSString stringWithFormat:@"打卡时间:%@(下班时间:%@)", xiaban1[@"clockin_time"], xiaban1[@"gowork_time"]];
                        self.wuxiuTuiAddressLabel.text = [NSString stringWithFormat:@"地址:%@", xiaban1[@"address"]];
                        self.wuxiuTuiyichangBtn.hidden = YES;
                    }
                    self.clockinWT_id = [xiaban1[@"clockin_log_id"] integerValue];
                }
                NSDictionary *overtime = responseObject[@"data"][@"overtime"];
                if ([overtime allKeys].count == 0) {
                    self.jiabanLabel.text = @"";
                    self.jiabanAddressLabel.text = @"";
                    self.qiantuiLabel.text = @"";
                } else {
                    self.jiabanLabel.text = [NSString stringWithFormat:@"(加班时间： %@以后)", overtime[@"overstart"]];
                    self.jiabanAddressLabel.text = [NSString stringWithFormat:@"地址:%@", overtime[@"address"]];
                    self.qiantuiLabel.text = [NSString stringWithFormat:@"签退时间:%@已加班%@小时", overtime[@"clockin_time"], overtime[@"overtime"]];
                }

            } else {
                //信息获取不到的时候的设置
                self.dakashangLabel.text = @"";
                self.dakaAddressLabel.text = @"";
                self.shangbanYichangBtn.hidden = YES;
                self.xiabanDakaLabel.text = @"";
                self.qiantuiAddressLabel.text = @"";
                self.xiabanYichangBtn.hidden = YES;
                self.wuxiuDaoLabel.text = @"";
                self.wuxiudaoAddressLabel.text = @"";
                self.wuxiuyichangBtn.hidden = YES;
                self.wuxiuTuiLabel.text = @"";
                self.wuxiuTuiAddressLabel.text = @"";
                self.wuxiuTuiyichangBtn.hidden = YES;
                self.jiabanLabel.text = @"";
                self.jiabanAddressLabel.text = @"";
                self.qiantuiLabel.text = @"";
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

#pragma mark - Function

- (void)tapGestureRecognizer:(UITapGestureRecognizer *)tap {

    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", (long) self.calendar.year, (long) self.calendar.month, (long) self.calendar.day];
    self.selectDate.text = [NSString stringWithFormat:@"%ld-%ld-%ld", (long) self.calendar.year, (long) self.calendar.month, (long) self.calendar.day];

    CalendarDateView *dateView = [CalendarDateView alterView];
    dateView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight + 400);
    dateView.stringDate = self.selectDatePicker;
    dateView.topView.backgroundColor = [UIColor clearColor];
    dateView.backgroundColor = [UIColor clearColor];
    [[DZTools getAppWindow] addSubview:dateView];

    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:0.3
                     animations:^{
                         dateView.top = -400;
                         dateView.topView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
                         dateView.blockSelectDate = ^(NSString *date) {

                             weakSelf.selectDatePicker = date;

                             NSLog(@"选中 %@", weakSelf.selectDatePicker);

                             NSArray *arrDate = [date componentsSeparatedByString:@"-"];
                             weakSelf.calendar.year = [arrDate[0] integerValue];
                             weakSelf.calendar.month = [arrDate[1] integerValue];

                             weakSelf.nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", (long) weakSelf.calendar.year, (long) weakSelf.calendar.month];

                             [weakSelf.calendar refreshMonth:[arrDate[0] integerValue] AndMonth:[arrDate[1] integerValue] AndDay:[arrDate[2] integerValue]];
                             [weakSelf.calendar selectDate:[NSString stringWithFormat:@"%@", date] showStatus:@"-1"];

                         };
                     }];
}
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"swipe left");
        [self NextClick:nil];
    }
    if (recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"swipe right");
        [self LastClick:nil];
    }
}

- (void)initRecognizer {

    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizer:)];
    [self.nowMouth addGestureRecognizer:recognizer];

    UISwipeGestureRecognizer *recognizer2;
    recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.calendar addGestureRecognizer:recognizer2];

    recognizer2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
    [recognizer2 setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.calendar addGestureRecognizer:recognizer2];
}
//申诉原因
- (void)alertWuxinClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.listArray.count) {
        WodeDakaModel *model = self.listArray[rowInteger];
        [self.selectGongdiBtn setTitle:model.group_name forState:UIControlStateNormal];
        [self.shnsuYYBtn setTitle:model.group_name forState:UIControlStateNormal];
        self.groupId = model.group_id;
        [self loadData];
        [self dakaDetail];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//申诉原因
- (void)alertGongDiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.listArray.count) {
        WodeDakaModel *model = self.listArray[rowInteger];
        [self.shnsuYYBtn setTitle:model.group_name forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//统计信息
- (void)alertTongjiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.tongjiArray.count) {
        [self.yuetongjiBtn setTitle:self.tongjiArray[rowInteger] forState:UIControlStateNormal];
    }
    NSString *monthStr = @"";
    if ([self.tongjiArray[rowInteger] isEqualToString:@"月统计"]) {
        monthStr = self.nowMouth.text;
        self.tongjiTitleLabel.text = @"当月统计：";
        self.isYueTongji = YES;
    } else {
        monthStr = @"0";
        self.isYueTongji = NO;
        self.tongjiTitleLabel.text = @"当年统计：";
    }
    if (self.groupId == 0) {

        [DZTools showNOHud:@"请选择下面的群" delay:2];
        return;
    }
    NSDictionary *dict = @{
        @"month_date": monthStr,
        @"group_id": @(self.groupId)
    };
    NSLog(@",,,,,,,%@", dict);
    [DZNetworkingTool postWithUrl:kMonthCount
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.tongjiriLabel.text = [NSString stringWithFormat:@"总计日工：%@", dict[@"total"]];
                self.tongjijiabanLabel.text = [NSString stringWithFormat:@"累计加班工时：%@", dict[@"cumulative"]];
                self.chidaoLabel.text = [NSString stringWithFormat:@"迟到次数：%@", dict[@"late"]];
                self.zaotuiLabel.text = [NSString stringWithFormat:@"早退次数：%@", dict[@"leave_early"]];
                self.kuanggongLabel.text = [NSString stringWithFormat:@"旷工次数：%@", dict[@"absenteeism"]];
            } else {

                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];

    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark – XibFunction

- (IBAction)NextClick:(UIButton *)sender {
    [_calendar NextbuttonClick];
    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];
    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];
    [self loadData];
    [self dakaDetail];
    [self loadDataForDay];
    NSLog(@"下月 %@", self.selectDatePicker);
}

- (IBAction)LastClick:(UIButton *)sender {
    [_calendar LastMonthClick];

    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];

    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];
    [self loadData];
    [self dakaDetail];
    [self loadDataForDay];
    NSLog(@"上月 %@", self.selectDatePicker);
}

// 返回今日
- (IBAction)toDayAction:(id)sender {
    [_calendar toDayClick];
    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];

    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];

    NSLog(@"今日 %@", self.selectDatePicker);
}

- (IBAction)detailBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;

    BaoBiaoDetailViewController *vc = [[BaoBiaoDetailViewController alloc] init];
    vc.groupId = self.groupId;
    vc.isYuetongji = self.isYueTongji;
    vc.month_date = self.nowMouth.text;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//异常按钮的点击
- (IBAction)yichangBtnClick:(UIButton *)sender {

    if (sender.tag == 1) { //上班异常
        self.clockinId = self.clockinS_id;

    } else if (sender.tag == 2) { //下班异常
        self.clockinId = self.clockinX_id;
    } else if (sender.tag == 3) {//中午 上班异常
        self.clockinId = self.clockinWS_id;
    } else {//中午下班异常
        self.clockinId = self.clockinWT_id;
    }
    self.shensuView.frame = self.view.bounds;

    [self.view addSubview:self.shensuView];
}

- (IBAction)errorBtnClick:(id)sender {
    [self.shensuView removeFromSuperview];
}
- (IBAction)cancelViewClick:(id)sender {
    [self.shensuView removeFromSuperview];
}
//选择工地
- (IBAction)selectGongdiClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工地" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.listArray.count; i++) {
        WodeDakaModel *model = self.listArray[i];
        [alert addAction:[UIAlertAction actionWithTitle:model.group_name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertWuxinClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertWuxinClick:self.listArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//提交异常
- (IBAction)yicahngCommitClick:(id)sender {
    [self.shensuView removeFromSuperview];
    [self.yuanyinTextView endEditing:YES];
    [self.shensuReasionText endEditing:YES];
    if (self.shensuReasionText.text.length == 0) {
        [DZTools showNOHud:@"原因不能为空" delay:2];
        return;
    }
    if (self.yuanyinTextView.text.length == 0) {
        [DZTools showNOHud:@"备注不能为空" delay:2];
        return;
    }
    NSDictionary *dict = @{
        @"group_id": @(self.groupId),
        @"clockinlog_id": @(self.clockinId),
        @"reason": self.shensuReasionText.text,
        @"remarks": self.yuanyinTextView.text
    };
    [DZNetworkingTool postWithUrl:kAbnormalAppeal
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

- (IBAction)shensuYYBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工地" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.listArray.count; i++) {
        WodeDakaModel *model = self.listArray[i];
        [alert addAction:[UIAlertAction actionWithTitle:model.group_name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertGongDiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertGongDiClick:self.listArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//月统计按钮的点击
- (IBAction)yuetongjiBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"月统计" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.tongjiArray.count; i ++) {
//        WodeDakaModel *model=self.tongjiArray[i];
        [alert addAction:[UIAlertAction actionWithTitle: self.tongjiArray[i] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertTongjiClick:i];
        }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self alertTongjiClick:self.tongjiArray.count];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    
}

@end
