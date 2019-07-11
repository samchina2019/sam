//
//  GuiZeSetViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/27.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GuiZeSetViewController.h"
#import "ReLayoutButton.h"
#import  "GuizeNextViewController.h"
#import "WSDatePickerView.h"
#import "SoundReminderViewController.h"

@interface GuiZeSetViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewLayout;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
//日班12点  tag==1
@property (weak, nonatomic) IBOutlet ReLayoutButton *timeBtn12;
//日班13点 tag==2
@property (weak, nonatomic) IBOutlet ReLayoutButton *timeBtn13;
//午休12点 tag==3
@property (weak, nonatomic) IBOutlet ReLayoutButton *timeBtnAF12;
//午休13点 tag==4
@property (weak, nonatomic) IBOutlet ReLayoutButton *timeBtnAF13;
//加班13点 tag==5
@property (weak, nonatomic) IBOutlet ReLayoutButton *timeBtn17;
//提前上班时间 tag==6
@property (weak, nonatomic) IBOutlet ReLayoutButton *timePre;
//提前下班时间 tag==7
@property (weak, nonatomic) IBOutlet ReLayoutButton *timeAfterBtn;
//补时是
@property (weak, nonatomic) IBOutlet UIButton *sureBushiBtn;
//补时否
@property (weak, nonatomic) IBOutlet UIButton *noBushiBtn;
//签到是
@property (weak, nonatomic) IBOutlet UIButton *sureQiandaoBtn;
//签退是
@property (weak, nonatomic) IBOutlet UIButton *sureQiantuiBtn;
//签退否
@property (weak, nonatomic) IBOutlet UIButton *noQiantuiBtn;
//签到否
@property (weak, nonatomic) IBOutlet UIButton *noQiandaoBtn;
//迟到
@property (weak, nonatomic) IBOutlet UIButton *chidaoBtn;
//离岗
@property (weak, nonatomic) IBOutlet UIButton *ligangBtn;
//早退
@property (weak, nonatomic) IBOutlet UIButton *zaotuiBtn;
//未到卡
@property (weak, nonatomic) IBOutlet UIButton *weidakaBtn;
@property (weak, nonatomic) IBOutlet UITextField *dakaFanweiText;
@property (weak, nonatomic) IBOutlet UITextField *jiabanTextField;

@property(nonatomic,strong)NSMutableArray *timeArray;
@property(nonatomic,strong)NSMutableArray *exceArray;

@property(nonatomic,assign)int late_time;
@property(nonatomic,assign)int automatic_clockin;
@property(nonatomic,assign)int automatic_signback;
@property(nonatomic,assign)int exception_prompt;

@property(nonatomic,strong)NSString *is_advance;
@property(nonatomic,strong)NSString *is_postpone;
@end

@implementation GuiZeSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"规则设置";

    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    if (@available(iOS 11.0, *)) {
        self.scrollview.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    
    self.late_time=1;
    self.is_postpone=@"1";
    self.is_advance=@"1";
    self.automatic_clockin=1;
    self.automatic_signback=1;
 
    self.timeArray=[NSMutableArray arrayWithObjects:@"10", @"20",@"30",@"40",@"50",@"60",nil];
    self.exceArray=[NSMutableArray array];

    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"跳过" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x101010) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];

    
    self.scrollview.contentSize=CGSizeMake(320, 647);

    //设置圆角
       self.bgView.layer.cornerRadius = 3;
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);

    
    // 下划线
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:self.jiabanTextField.text attributes:attribtDic];
    
    //赋值
    self.jiabanTextField.attributedText = attribtStr;
 
}

//跳过按钮的点击事件
- (void)rightBarButtonItemClicked
{
    self.hidesBottomBarWhenPushed=YES;
    GuizeNextViewController *nxetViewController=[[GuizeNextViewController alloc]init];
    nxetViewController.groupId = self.groupId;
    [self.navigationController pushViewController:nxetViewController animated:YES];
    self.hidesBottomBarWhenPushed=YES;
}
//根据tag不同，设置不同的时间
- (IBAction)timeListBtnClick:(UIButton *)sender {
    NSDate *scrollToDate =nil;
    
    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    [minDateFormater setDateFormat:@"HH:mm"];
    
    if(sender.tag==1){
        scrollToDate = [minDateFormater dateFromString:self.timeBtn12.titleLabel.text];
    }else if (sender.tag==2){
        scrollToDate = [minDateFormater dateFromString:self.timeBtn13.titleLabel.text];
    }else if (sender.tag==3){
        scrollToDate = [minDateFormater dateFromString:self.timeBtnAF12.titleLabel.text];
    }else if (sender.tag==4){
        scrollToDate = [minDateFormater dateFromString:self.timeBtnAF13.titleLabel.text];
    }else if (sender.tag==5){
        scrollToDate = [minDateFormater dateFromString:self.timeBtn17.titleLabel.text];
    }
  
    
    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowHourMinute
          scrollToDate:scrollToDate
       CompleteBlock:^(NSDate *selectDate) {
                                                                     
           NSString *date = [selectDate stringWithFormat:@"HH:mm"];
      NSLog(@"选择的日期：%@", date);
           if(sender.tag==1){
               [self.timeBtn12 setTitle:date forState:UIControlStateNormal];
               self.timeBtn12.imageView.hidden = YES;
           }else if (sender.tag==2){
               [self.timeBtn13 setTitle:date forState:UIControlStateNormal];
               self.timeBtn13.imageView.hidden = YES;
           }else if (sender.tag==3){
               [self.timeBtnAF12 setTitle:date forState:UIControlStateNormal];
               self.timeBtnAF12.imageView.hidden = YES;
           }else if (sender.tag==4){
               [self.timeBtnAF13 setTitle:date forState:UIControlStateNormal];
               self.timeBtnAF13.imageView.hidden = YES;
           }else if (sender.tag==5){
               [self.timeBtn17 setTitle:date forState:UIControlStateNormal];
               self.timeBtn17.imageView.hidden = YES;
           }
           
       
        }];
    datepicker.dateLabelColor = TabbarColor;           //年-月-日-时-分 颜色
    datepicker.datePickerColor = [UIColor blackColor]; //滚轮日期颜色
    datepicker.doneButtonColor = TabbarColor;          //确定按钮的颜色
    datepicker.yearLabelColor = [UIColor clearColor];  //大号年份字体颜色
    [datepicker show];
}

//上班时间  下班时间点击事件
- (IBAction)timeDakaBtnClick:(UIButton *)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请设置时间间隔" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < self.timeArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.timeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                  
                                                        [self alertTimeClick:i tag:sender.tag];
                                                   
                                                   
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertTimeClick:self.timeArray.count tag:sender.tag];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}
-(void)alertTimeClick:(NSInteger)index tag:(NSInteger)tag{
    if (index < self.timeArray.count) {
        if (tag==6) {
            [self.timePre setTitle:[NSString stringWithFormat:@"%@",self.timeArray[index]] forState:UIControlStateNormal];
        
        }else if (tag==7){
            [self.timeAfterBtn setTitle:[NSString stringWithFormat:@"%@",self.timeArray[index]] forState:UIControlStateNormal];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

//是否s迟到补时 tag 0是 1否
- (IBAction)bushiBtnClick:(id)sender {
    if ( self.sureBushiBtn.selected==YES) {
         self.sureBushiBtn.selected = !self.sureBushiBtn.selected;
        self.noBushiBtn.selected=YES;
        self.late_time=0;
        
    }else{
        
          self.late_time=1;
        self.noBushiBtn.selected=!self.noBushiBtn.selected;
        self.sureBushiBtn.selected=YES;
    }
   
    
}

//下一步
- (IBAction)nextBtnClick:(id)sender {
    if (self.exceArray.count==0) {
        [self.exceArray addObjectsFromArray:@[@(1),@(2),@(3),@(4)]];
    }
    
    if (self.dakaFanweiText.text.length==0) {
        [DZTools showNOHud:@"打卡范围不能为空" delay:2];
        return;
    }
    if (self.jiabanTextField.text.length==0) {
        [DZTools showNOHud:@"加班工时不能为空" delay:2];
        return;
    }
    
    //    kSetGroupRule
    NSString *timeWork=[NSString stringWithFormat:@"%@-%@",self.timeBtn12.titleLabel.text,self.timeBtn13.titleLabel.text];
    NSString *timeLunch=[NSString stringWithFormat:@"%@-%@",self.timeBtnAF12.titleLabel.text,self.timeBtnAF13.titleLabel.text];
    NSDictionary *dict=@{
                         @"group_id":@(self.groupId),
                         @"work_hours":timeWork,
                         @"lunch_break":timeLunch,
                         @"overtime":self.timeBtn17.titleLabel.text,
                         @"overtime_hours":self.jiabanTextField.text,
                         @"advance_time":self.timePre.titleLabel.text,
                         @"postpone_time":self.timeAfterBtn.titleLabel.text,
                         @"late_time":@(self.late_time),
                         @"card_range":self.dakaFanweiText.text,
//                         @"automatic_clockin":@(self.automatic_clockin),
//                         @"automatic_signback":@(self.automatic_signback),
                         @"exception_prompt":[self.exceArray componentsJoinedByString:@","],
                         @"is_advance":self.is_advance,
                         @"is_postpone":self.is_postpone
                         };
    
    [DZNetworkingTool postWithUrl:kSetGroupRule params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
           
            self.hidesBottomBarWhenPushed=YES;
            GuizeNextViewController *nxetViewController=[[GuizeNextViewController alloc]init];
            nxetViewController.groupId=self.groupId;
            [self.navigationController pushViewController:nxetViewController animated:YES];
            self.hidesBottomBarWhenPushed=YES;
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];

    
}



//开始签到 tag 2是 3否
- (IBAction)qiandaoBtnClick:(id)sender {
    if ( self.sureQiandaoBtn.selected==YES) {
        self.sureQiandaoBtn.selected = !self.sureQiandaoBtn.selected;
        self.noQiandaoBtn.selected=YES;
        self.automatic_clockin=0;
    }else{
        self.automatic_clockin=1;
        self.noQiandaoBtn.selected=!self.noQiandaoBtn.selected;
        self.sureQiandaoBtn.selected=YES;
    }
}
//开始签退 tag 4是 5否
- (IBAction)qiantuiBtnClick:(id)sender {
    if ( self.sureQiantuiBtn.selected==YES) {
        self.sureQiantuiBtn.selected = !self.sureQiantuiBtn.selected;
        self.noQiantuiBtn.selected=YES;
        self.automatic_signback=0;
    }else{
        self.automatic_signback=1;
        self.noQiantuiBtn.selected=!self.noQiantuiBtn.selected;
        self.sureQiantuiBtn.selected=YES;
    }
    
}
//异常报警：tag 0迟到 1离岗 2早退 3未打卡
- (IBAction)yichangbojingBtnClick:(UIButton *)sender {

    
    sender.selected=!sender.selected;
    
    if (sender.selected) {
        
        [self.exceArray addObject:@(sender.tag)];
    }else{
        [self.exceArray removeObject:@(sender.tag)];
    }
    
}
- (IBAction)dakaSetBtnClick:(UIButton *)sender {
    sender.selected=!sender.selected;
    if (sender.selected) {
        if (sender.tag==11) {
            self.is_advance=@"1";
        }
        if (sender.tag==22) {
            self.is_postpone=@"1";
        }
    }else{
        if (sender.tag==11) {
            self.is_advance=@"0";
        }
        if (sender.tag==22) {
            self.is_postpone=@"0";
        }
    }
    
}
//声音设置
- (IBAction)setBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SoundReminderViewController *viewController = [SoundReminderViewController new];
    
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed=YES;
}


@end
