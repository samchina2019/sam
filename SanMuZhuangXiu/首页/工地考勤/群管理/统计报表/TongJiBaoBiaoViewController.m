//
//  TongJiBaoBiaoViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/4.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "TongJiBaoBiaoViewController.h"
#import "MyCalendar.h"
#import "MyCollectionViewCell.h"
#import "CalendarDateView.h"
#import "BaoBiaoDetailViewController.h"
#import "ReLayoutButton.h"

@interface TongJiBaoBiaoViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nowMouth;                   // 日历标题
@property (weak, nonatomic) IBOutlet UIView *weekView;                    // 周日到周六
@property (nonatomic, strong) IBOutlet MyCalendar *calendar;              // 日历
/// 日历高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewConstHeight;
@property (weak, nonatomic) IBOutlet UILabel *selectDate;                 // 显示选中的label
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
///工种
@property (weak, nonatomic) IBOutlet ReLayoutButton *gognzhongBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *gongzhongText;
@property (weak, nonatomic) IBOutlet UILabel *tongjiRigongLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongjiJiabanLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongjiTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *chidaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zaotuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuanggongLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *yuetongjiBtn;

// 选中的DatePicker
@property (nonatomic, copy) NSString *selectDatePicker;

@property (nonatomic, strong) NSArray *weekArray;
@property (nonatomic, strong) NSArray *tongjiArray;
@property (nonatomic, strong) NSMutableArray *monthArray;
@property(nonatomic,strong)NSMutableArray *gongzhongArray;
@end

@implementation TongJiBaoBiaoViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //日历说白了就是一个CollectionView
    [self initCollectionView];
    self.monthArray = [NSMutableArray array];
    self.gongzhongArray = [NSMutableArray array];
    [self initRecognizer];
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.calendar.layer.cornerRadius = 3;
    [self dakaDetail];
    [self loadGongzhong];
    self.tongjiArray = @[@"月统计", @"年统计"];
}

#pragma mark – UI

- (void)initCollectionView {

    [_calendar registerNib:[UINib nibWithNibName:@"MyCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"collectionCell"];

    self.calendar.isComeBaobiao = YES;
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

    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];
    // 今天是今年的第多少周
    NSInteger week = [_calendar.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitYear forDate:[NSDate date]];
    self.selectDate.text = [NSString stringWithFormat:@"公历：%ld年%ld月%ld日 第%ld周", (long) _calendar.year, _calendar.month, _calendar.day, week];
}
#pragma mark – Network
-(void)loadGongzhong{
    [DZNetworkingTool postWithUrl:kWorkList params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [self.gongzhongArray removeAllObjects];
            NSArray * array = responseObject[@"data"][@"list"];
            for (NSDictionary * dict in array) {
                [self.gongzhongArray addObject:dict];
            }
            
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
#pragma mark – UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSDictionary *dict = @{};
    if (textField == self.gongzhongText) {

        dict = @{
            @"month_date": self.nowMouth.text,
            @"group_id": @(self.group_id),
            @"work_type": self.gongzhongText.text,
            @"admin": @(1)
        };
    } else if (textField == self.nameText) {
        dict = @{
            @"month_date": self.nowMouth.text,
            @"group_id": @(self.group_id),
            @"name": self.nameText.text,
            @"admin": @(1)
        };
    }

    [DZNetworkingTool postWithUrl:kClockinCount
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.gongzhongText resignFirstResponder];
            [self.nameText resignFirstResponder];
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
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {

    [self.gongzhongText endEditing:YES];
    [self.nameText endEditing:YES];
}

#pragma mark – Network

- (void)loadData {
    NSDictionary *dict = @{
        @"month_date": self.nowMouth.text,
        @"group_id": @(self.group_id),
        @"admin": @(1)
    };
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
                [DZTools hideHud];
            } else {

                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:YES];
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
- (void)alertTongjiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.tongjiArray.count) {
        [self.yuetongjiBtn setTitle:self.tongjiArray[rowInteger] forState:UIControlStateNormal];
    }
    NSString *monthStr = @"";
    if ([self.tongjiArray[rowInteger] isEqualToString:@"月统计"]) {
        monthStr = self.nowMouth.text;
        self.tongjiTitleLabel.text = @"当月统计：";

    } else {
        monthStr = @"0";

        self.tongjiTitleLabel.text = @"当年统计：";
    }

    NSDictionary *dict = @{
        @"month_date": monthStr,
        @"group_id": @(self.group_id),
        @"admin":@(1)
    };
    NSLog(@",,,,,,,%@", dict);
    [DZNetworkingTool postWithUrl:kMonthCount
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.tongjiRigongLabel.text = [NSString stringWithFormat:@"总计日工：%@", dict[@"total"]];
                self.tongjiJiabanLabel.text = [NSString stringWithFormat:@"累计加班工时：%@", dict[@"cumulative"]];
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
//每天详情
- (void)dakaDetail {

    NSDictionary *dict = @{
        @"month_date": self.nowMouth.text,
        @"group_id": @(self.group_id),
        @"admin":@(1)
    };
    NSLog(@",,,,,,,%@", dict);
    [DZNetworkingTool postWithUrl:kMonthCount
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.tongjiRigongLabel.text = [NSString stringWithFormat:@"总计日工：%@", dict[@"total"]];
                self.tongjiJiabanLabel.text = [NSString stringWithFormat:@"累计加班工时：%@", dict[@"cumulative"]];
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
//工种刷新数据
-(void)refreshData{
    NSDictionary *dict = @{
                 @"month_date": self.nowMouth.text,
                 @"group_id": @(self.group_id),
                 @"work_type": self.gognzhongBtn.titleLabel.text,
                 @"admin": @(1)
                 };
    [DZNetworkingTool postWithUrl:kClockinCount
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                           [self.monthArray removeAllObjects];
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSArray *array = responseObject[@"data"];
                                  
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
#pragma mark – XibFunction
//下一月
- (IBAction)NextClick:(UIButton *)sender {
    [_calendar NextbuttonClick];

    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];
    [self loadData];
    [self dakaDetail];
    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];

    NSLog(@"下月 %@", self.selectDatePicker);
}
//上一月
- (IBAction)LastClick:(UIButton *)sender {
    [_calendar LastMonthClick];

    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];
    [self loadData];
    [self dakaDetail];

    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];

    NSLog(@"上月 %@", self.selectDatePicker);
}

// 返回今日
- (IBAction)toDayAction:(id)sender {
    [_calendar toDayClick];
    _nowMouth.text = [NSString stringWithFormat:@"%ld-%ld", _calendar.year, _calendar.month];

    self.selectDatePicker = [NSString stringWithFormat:@"%ld-%ld-%ld", self.calendar.year, self.calendar.month, self.calendar.day];

    NSLog(@"今日 %@", self.selectDatePicker);
}
//当月统计
- (IBAction)detailBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    BaoBiaoDetailViewController *vc = [BaoBiaoDetailViewController new];
    vc.groupId = self.group_id;
    
    if ([self.tongjiTitleLabel.text containsString:@"当月统计："]) {
           vc.month_date = self.nowMouth.text;
    }else{
         vc.month_date = @"0";
    }
    
 
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//月统计
- (IBAction)yuetongjiBtnCLick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"月统计" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.tongjiArray.count; i++) {
        //        WodeDakaModel *model=self.tongjiArray[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.tongjiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertTongjiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self alertTongjiClick:self.tongjiArray.count];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
    
}
//工种的选择
- (IBAction)gongzhongBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工种类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.gongzhongArray.count; i ++) {
        
        [alert addAction:[UIAlertAction actionWithTitle: self.gongzhongArray[i][@"workname"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self alertClick:i];
        }]];
        
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self alertClick:self.gongzhongArray.count];
    }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];

}
- (void)alertClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.gongzhongArray.count) {
        
        [self.gognzhongBtn setTitle:self.gongzhongArray[rowInteger][@"workname"] forState:UIControlStateNormal];
        self.gognzhongBtn.imageView.hidden=YES;
        
        [self refreshData];
        
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
    
}
@end
