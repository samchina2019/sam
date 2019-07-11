//
//  WorkZhaogongrenController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "WorkZhaogongrenController.h"
#import "WSDatePickerView.h"
#import "ReLayoutButton.h"

@interface WorkZhaogongrenController ()
//计薪方式 是
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
//计薪方式 否
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
//上岗日期
@property (weak, nonatomic) IBOutlet ReLayoutButton *shanggangDateBtn;
@property (weak, nonatomic) IBOutlet UITextField *gongqiText;
///日工标题
@property (weak, nonatomic) IBOutlet UILabel *rigongLabel;
///结算标题
@property (weak, nonatomic) IBOutlet UILabel *jiesuanLabel;
///隐藏view
@property (weak, nonatomic) IBOutlet UIView *hiddleView;
///隐藏view高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hiddleHeight;

//日工时间
@property (weak, nonatomic) IBOutlet ReLayoutButton *rigongDateBtn;
//结算时间
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiesuanDateBtn;
//工地名称
@property (weak, nonatomic) IBOutlet UITextField *gongdiName;
@property (weak, nonatomic) IBOutlet UITextField *gongdiAddressText;
@property (weak, nonatomic) IBOutlet UITextField *renshuText;
@property (weak, nonatomic) IBOutlet UITextField *techangText;

//招聘工种
@property (weak, nonatomic) IBOutlet ReLayoutButton *gongzhongBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiguanBtn;

//电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

//是否中途预算
@property (weak, nonatomic) IBOutlet ReLayoutButton *zhongtuYusuanBtn;
//是否提供住宿
@property (weak, nonatomic) IBOutlet ReLayoutButton *zhusuBtn;
//期望薪资
@property (weak, nonatomic) IBOutlet ReLayoutButton *xinziBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jingyanBtn;
@property (weak, nonatomic) IBOutlet UITextView *jianjieTextView;

///工种ID
@property (nonatomic, strong) NSString *gongId;
///计薪
@property (nonatomic, strong) NSString *jixinStr;
///日工
@property (nonatomic, strong) NSString *rigongStr;
///结算
@property (nonatomic, strong) NSString *jiesuanStr;
///是否支持预支：10:是；20：否；
@property (nonatomic, strong) NSString *advanceStr;
///是否提供住宿：10：是；20：否
@property (nonatomic, strong) NSString *putupStr;

@property (nonatomic, strong) NSMutableArray *jiguanArray;
@property (nonatomic, strong) NSMutableArray *touzhiArray;
@property (nonatomic, strong) NSMutableArray *zhusuArray;
@property (nonatomic, strong) NSMutableArray *gongzhongArray;
@property (nonatomic, strong) NSMutableArray *constrTimeArray;
@property (nonatomic, strong) NSMutableArray *dayworkTimeArray;
@property (nonatomic, strong) NSMutableArray *settlementTimeArray;
@property (nonatomic, strong) NSArray *xinziArray;
@property (nonatomic, strong) NSArray *jingyanArray;

@end

@implementation WorkZhaogongrenController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    //请求详情
    if (self.isEdited) {

        [self loadDetailData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"发布招聘";

    [self initData];
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);

    self.bgView.layer.cornerRadius = 3;

    self.textView.layer.borderColor = UIColorWithRGB(245, 245, 245, 1).CGColor; //设置边框颜色
    self.textView.layer.borderWidth = 1.0f;                                     //设置边框颜色
}
#pragma mark – Network

- (void)loadDetailData {
    NSDictionary *dict = @{
        @"id": @(self.userId)
    };
    [DZNetworkingTool postWithUrl:kWorkInfo
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                //            [DZTools showOKHud:responseObject[@"msg"] delay:2];
                NSDictionary *dict = responseObject[@"data"];
                self.gongdiAddressText.text = [NSString stringWithFormat:@"%@", dict[@"work_address"]];
                self.gongdiName.text = [NSString stringWithFormat:@"%@", dict[@"name"]];

                self.gongqiText.text = [NSString stringWithFormat:@"%@", dict[@"project_time"]];

                [self.gongzhongBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"jobName"]] forState:UIControlStateNormal];
                self.renshuText.text = [NSString stringWithFormat:@"%@", dict[@"recruits_num"]];
                [self.shanggangDateBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"construction_time"]] forState:UIControlStateNormal];
                self.techangText.text = [NSString stringWithFormat:@"%@", dict[@"speciality"]];
                [self.jiguanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"native_place"]] forState:UIControlStateNormal];
                self.phoneTextField.text = [NSString stringWithFormat:@"%@", dict[@"telephone"]];
                self.jixinStr = [NSString stringWithFormat:@"%@", dict[@"salary_way"]]; //日工包工
                if ([dict[@"salary_way"] intValue] == 20) {
                    self.sureBtn.selected = NO;
                    self.noBtn.selected = YES;
                } else if ([dict[@"salary_way"] intValue] == 10) {
                    self.noBtn.selected = NO;
                    self.sureBtn.selected = YES;
                }
                [self.rigongDateBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"daywork_time"]] forState:UIControlStateNormal];
                [self.jiesuanDateBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"settlement_time"]] forState:UIControlStateNormal];
                self.advanceStr = [NSString stringWithFormat:@"%@", dict[@"advance"]];
                if ([dict[@"advance"] intValue] == 10) {
                    [self.zhongtuYusuanBtn setTitle:@"可以" forState:UIControlStateNormal];
                } else if ([dict[@"advance"] intValue] == 20) {
                    [self.zhongtuYusuanBtn setTitle:@"不可以" forState:UIControlStateNormal];
                }
                self.putupStr = [NSString stringWithFormat:@"%@", dict[@"putup"]];
                if ([dict[@"putup"] intValue] == 10) {
                    [self.zhusuBtn setTitle:@"提供" forState:UIControlStateNormal];
                } else if ([dict[@"putup"] intValue] == 20) {
                    [self.zhusuBtn setTitle:@"不提供" forState:UIControlStateNormal];
                }
                [self.jingyanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"work_year"]] forState:UIControlStateNormal];
                self.jianjieTextView.text = [NSString stringWithFormat:@"%@", dict[@"brief"]];
                self.gongId = [NSString stringWithFormat:@"%@", dict[@"stuff_work_id"]];
                [self.xinziBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"salary"]] forState:UIControlStateNormal];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)loadData {

    [DZNetworkingTool postWithUrl:kArrayRecruit
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                [self.constrTimeArray addObjectsFromArray:dict[@"construction_time"]];
                [self.jiguanArray addObjectsFromArray:dict[@"native_place"]];
                [self.dayworkTimeArray addObjectsFromArray:dict[@"daywork_time"]];
                [self.settlementTimeArray addObjectsFromArray:dict[@"settlement_time"]];
                NSArray *tempArray = dict[@"stuff_work"];
                for (NSDictionary *temp in tempArray) {
                    [self.gongzhongArray addObject:temp];
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

#pragma mark - Function
- (void)initData {
    self.touzhiArray = [NSMutableArray arrayWithObjects:@"可以", @"不可以", nil];
    self.zhusuArray = [NSMutableArray arrayWithObjects:@"提供", @"不提供", nil];
    self.constrTimeArray = [NSMutableArray array];
    self.dayworkTimeArray = [NSMutableArray array];
    self.settlementTimeArray = [NSMutableArray array];
    self.jiguanArray = [NSMutableArray array];
    self.gongzhongArray = [NSMutableArray array];
    self.xinziArray = @[@"3K以下", @"3K-5k", @"5K-10K", @"10K-30K",
                        @"30K-50K", @"50K以上"];
    self.jingyanArray = @[@"应届生", @"1年以内", @"1-3年", @"3-5年", @"5-10年",
                          @"10年以上"];

    self.jixinStr = @"10";
    self.rigongStr = @"";
}
- (void)alertgongZhongClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.gongzhongArray.count) {

        //        typeId=@"";
        NSDictionary *dict = self.gongzhongArray[rowInteger];
        self.gongId = dict[@"id"];
        NSString *name = dict[@"name"];
        [self.gongzhongBtn setTitle:name forState:UIControlStateNormal];

        self.gongzhongBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)alertzhongTuClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.touzhiArray.count) {
        [self.zhongtuYusuanBtn setTitle:self.touzhiArray[rowInteger] forState:UIControlStateNormal];

        self.zhongtuYusuanBtn.imageView.hidden = YES;
        if (rowInteger == 0) {
            self.advanceStr = @"10";
        } else {
            self.advanceStr = @"20";
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertJiguanClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.jiguanArray.count) {

        //        typeId=@"";
        [self.jiguanBtn setTitle:self.jiguanArray[rowInteger] forState:UIControlStateNormal];

        self.jiguanBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertjingyanClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.jingyanArray.count) {
        [self.jingyanBtn setTitle:self.jingyanArray[rowInteger] forState:UIControlStateNormal];
        self.jingyanBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertJiesuanClick:(NSInteger)rowInteger {
    if (rowInteger < self.settlementTimeArray.count) {
        [self.jiesuanDateBtn setTitle:self.settlementTimeArray[rowInteger] forState:UIControlStateNormal];
        self.jiesuanStr = self.settlementTimeArray[rowInteger];
        self.jiesuanDateBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertxinziClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xinziArray.count) {
        [self.xinziBtn setTitle:self.xinziArray[rowInteger] forState:UIControlStateNormal];
        self.xinziBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertDayTimeClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.dayworkTimeArray.count) {

        //        typeId=@"";
        [self.rigongDateBtn setTitle:self.dayworkTimeArray[rowInteger] forState:UIControlStateNormal];
        self.rigongStr = self.dayworkTimeArray[rowInteger];
        self.rigongDateBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertShanggangClick:(NSInteger)rowInter {
    if (rowInter < self.constrTimeArray.count) {

        [self.shanggangDateBtn setTitle:self.constrTimeArray[rowInter] forState:UIControlStateNormal];

        self.shanggangDateBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertzhusuClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.zhusuArray.count) {

        if (rowInteger == 0) {
            self.putupStr = @"10";
        } else {
            self.putupStr = @"20";
        }
        //        typeId=@"";
        [self.zhusuBtn setTitle:self.zhusuArray[rowInteger] forState:UIControlStateNormal];

        self.zhusuBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark – XibFunction

- (IBAction)endEditing:(id)sender {
    [self.bgView endEditing:YES];
}

- (IBAction)jixinBtnClick:(id)sender {
    if (self.sureBtn.selected == YES) {
         self.hiddleHeight.constant = 0;
        self.sureBtn.selected = !self.sureBtn.selected;
        self.jixinStr = @"10";
        self.jiesuanDateBtn.hidden = YES;
        self.rigongDateBtn.hidden = YES;
        self.rigongLabel.hidden = YES;
        self.jiesuanLabel.hidden = YES;
        self.noBtn.selected = YES;

    } else {
        self.hiddleHeight.constant = 90.0;
        self.jiesuanDateBtn.hidden = NO;
        self.rigongDateBtn.hidden = NO;
        self.rigongLabel.hidden = NO;
        self.jiesuanLabel.hidden = NO;
        self.jixinStr = @"20";
        self.noBtn.selected = !self.noBtn.selected;
        self.sureBtn.selected = YES;
    }
}

//选择工种
- (IBAction)gongzhongBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择招聘工种" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.gongzhongArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        NSDictionary *dict = self.gongzhongArray[i];
        NSString *name = dict[@"name"];
        [alert addAction:[UIAlertAction actionWithTitle:name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertgongZhongClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertgongZhongClick:self.gongzhongArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//透支
- (IBAction)touzhiBtnCLick:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择透支情况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.touzhiArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.touzhiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertzhongTuClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertzhongTuClick:self.touzhiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//上岗时间
- (IBAction)shanggangClick:(id)sender {

    //    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    //    [minDateFormater setDateFormat:@"yyyy-MM-dd "];
    //    NSDate *scrollToDate = [minDateFormater dateFromString:self.shanggangDateBtn.titleLabel.text];
    //
    //    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay
    //                                                                  scrollToDate:scrollToDate
    //                                                                 CompleteBlock:^(NSDate *selectDate) {
    //
    //                                                                     NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd "];
    //                                                                     NSLog(@"选择的日期：%@", date);
    //                                                                     [self.shanggangDateBtn setTitle:date forState:UIControlStateNormal];
    //                                                                     self.shanggangDateBtn.imageView.hidden = YES;
    //                                                                 }];
    //    datepicker.dateLabelColor = TabbarColor;           //年-月-日-时-分 颜色
    //    datepicker.datePickerColor = [UIColor blackColor]; //滚轮日期颜色
    //    datepicker.doneButtonColor = TabbarColor;          //确定按钮的颜色
    //    datepicker.yearLabelColor = [UIColor clearColor];  //大号年份字体颜色
    //    [datepicker show];

    ///  修改
    // constrTimeArray
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择上岗日期" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.constrTimeArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.constrTimeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertShanggangClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertShanggangClick:self.constrTimeArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    ///
}

- (IBAction)jiguanBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择籍贯要求" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.jiguanArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.jiguanArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertJiguanClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertJiguanClick:self.jiguanArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//住宿
- (IBAction)zhusuBtnClick:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择住宿情况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.zhusuArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.zhusuArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertzhusuClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertzhusuClick:self.zhusuArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)rigongTimeClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择日工时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.dayworkTimeArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.dayworkTimeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertDayTimeClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertzhusuClick:self.dayworkTimeArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//薪资
- (IBAction)xinziBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择期望薪资" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.xinziArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.xinziArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertxinziClick:i];
                                                }]];
    }
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)jisuanClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择结算方式" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.settlementTimeArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.settlementTimeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertJiesuanClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertJiesuanClick:self.settlementTimeArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//工作经验
- (IBAction)jingyanBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工作经验" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.jingyanArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.jingyanArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertjingyanClick:i];
                                                }]];
    }
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)sureFabuBtnClick:(id)sender {

    [self.bgView endEditing:YES];
    if (self.gongdiName.text.length == 0) {
        [DZTools showNOHud:@"工地名称不能为空" delay:2];
        return;
    }
    if (self.gongdiAddressText.text.length == 0) {
        [DZTools showNOHud:@"工地区域不能为空" delay:2];
        return;
    }
    if (self.gongqiText.text.length == 0) {
        [DZTools showNOHud:@"工期不能为空" delay:2];
        return;
    }
    if (self.renshuText.text.length == 0) {
        [DZTools showNOHud:@"人数不能为空" delay:2];
        return;
    }
    if ([self.shanggangDateBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择上岗日期" delay:2];
        return;
    }
    if (self.techangText.text.length == 0) {
        [DZTools showNOHud:@"特长要求不能为空" delay:2];
        return;
    }
    if ([self.jiguanBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择籍贯要求" delay:2];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [DZTools showNOHud:@"电话不能为空" delay:2];
        return;
    }
    //电话号码非法验证
    NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTextField.text];
    if (!isMatch) {

        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    if ([self.rigongDateBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择日工时间" delay:2];
        return;
    }
    if ([self.jiesuanDateBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择结算方式" delay:2];
        return;
    }
    if ([self.zhongtuYusuanBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择中途是否预支" delay:2];
        return;
    }
    if ([self.zhusuBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择是否提供住宿" delay:2];
        return;
    }
    if ([self.xinziBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择期望薪资" delay:2];
        return;
    }
    if ([self.xinziBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择工作经验" delay:2];
        return;
    }
    if (self.jianjieTextView.text.length == 0) {
        [DZTools showNOHud:@"请输入招聘简介" delay:2];
        return;
    }
    if (self.jianjieTextView.text.length <= 20) {
        [DZTools showNOHud:@"请输入20字以上说明" delay:2];
        return;
    }

    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *dict = @{ @"name": self.gongdiName.text,
                            @"work_address": self.gongdiAddressText.text,
                            @"project_time": self.gongqiText.text,
                            @"stuff_work_id": self.gongId,
                            @"recruits_num": self.renshuText.text,
                            @"native_place": self.jiguanBtn.titleLabel.text,
                            @"telephone": self.phoneTextField.text,
                            @"salary_way": self.jixinStr,
                            @"daywork_time": self.rigongDateBtn.titleLabel.text,
                            @"settlement_time": self.jiesuanDateBtn.titleLabel.text,
                            @"advance": self.advanceStr,
                            @"putup": self.putupStr,
                            @"brief": self.jianjieTextView.text,
                            @"salary": self.xinziBtn.titleLabel.text,
                            @"speciality": self.techangText.text,
                            @"work_year": self.jingyanBtn.titleLabel.text,
                            @"work_addressInfo": @"",
                            @"longitude": @(latitude),
                            @"latitude": @(longitude),
                            @"construction_time": self.shanggangDateBtn.titleLabel.text };

    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if (self.isEdited) {
        [params setValue:@(self.userId) forKey:@"id"];
    }
    [DZNetworkingTool postWithUrl:self.isEdited ? kEditRecruitMan : kRecruitMan
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];
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
