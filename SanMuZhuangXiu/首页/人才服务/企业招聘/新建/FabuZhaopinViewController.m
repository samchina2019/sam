//
//  FabuZhaopinViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FabuZhaopinViewController.h"
#import "UIButton+Code.h"
#import "ReLayoutButton.h"
#import "WSDatePickerView.h"
#import "AddressPickerView.h"

@interface FabuZhaopinViewController () <AddressPickerViewDelegate>
//公司名称
@property (weak, nonatomic) IBOutlet UITextField *gognsiName;
//统一社会代码
@property (weak, nonatomic) IBOutlet UITextField *shehuiDaimatextField;
//招聘岗位
@property (weak, nonatomic) IBOutlet ReLayoutButton *zhaopinGangweiBtn;

@property (weak, nonatomic) IBOutlet UITextField *peopleText;
@property (weak, nonatomic) IBOutlet UITextField *xueliText;
@property (weak, nonatomic) IBOutlet ReLayoutButton *xueliBtn;
@property (weak, nonatomic) IBOutlet UITextField *jingyanText;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jingyanBtn;
@property (weak, nonatomic) IBOutlet UITextField *timeText;
@property (weak, nonatomic) IBOutlet ReLayoutButton *workTimeBtn;
@property (weak, nonatomic) IBOutlet UITextField *xinziText;
@property (weak, nonatomic) IBOutlet ReLayoutButton *xinziBtn;
//单双休
@property (weak, nonatomic) IBOutlet ReLayoutButton *danshuangXiuBtn;
//食宿情况
@property (weak, nonatomic) IBOutlet ReLayoutButton *shiSuBtn;
//电子邮箱
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
//五险一金
@property (weak, nonatomic) IBOutlet ReLayoutButton *wuxianyjBtn;
//区域
@property (weak, nonatomic) IBOutlet ReLayoutButton *quyuBtn;
//电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
//验证码
@property (weak, nonatomic) IBOutlet UIButton *hqyzmBtn;
//招聘简介
@property (weak, nonatomic) IBOutlet UITextView *jianjieTextView;
//验证码
@property (weak, nonatomic) IBOutlet UITextField *CodeTextField;

@property (nonatomic, strong) NSMutableArray *gangweiArray;
@property (nonatomic, strong) NSMutableArray *peopleArray;
@property (nonatomic, strong) NSMutableArray *xiuxiArray;
@property (nonatomic, strong) NSMutableArray *shisuArray;
@property (nonatomic, strong) NSMutableArray *wuxianArray;
@property (nonatomic, strong) NSArray *xueliArray;
@property (nonatomic, strong) NSArray *jingyanArray;
@property (nonatomic, strong) NSArray *worktimeArray;
@property (nonatomic, strong) NSArray *xinziArray;
///是否双休
@property (nonatomic, strong) NSString *is_rest;
///五险一金
@property (nonatomic, strong) NSString *risks_gold;
///食宿
@property (nonatomic, strong) NSString *putup;
///岗位
@property (nonatomic, strong) NSString *gangwei;

@property (nonatomic, strong) AddressPickerView *pickerView;

@end

@implementation FabuZhaopinViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([DZTools islogin]) {
        [self loadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self.hqyzmBtn cancelCountdownWithEndString:@"获取验证码"];
    self.gangweiArray = [NSMutableArray arrayWithObjects:@"Java工程师", @"木工", @"架构师", nil];

    self.xiuxiArray = [NSMutableArray arrayWithObjects:@"双休", @"单休", nil];
    self.shisuArray = [NSMutableArray arrayWithObjects:@"包食宿", @"不包食宿", nil];
    self.wuxianArray = [NSMutableArray arrayWithObjects:@"五险一金", @"无五险一金", nil];
    self.xinziArray = @[@"3K以下", @"3K-5k", @"5K-10K", @"10K-30K",
                        @"30K-50K", @"50K以上"];
    self.jingyanArray = @[@"应届生", @"1年以内", @"1-3年", @"3-5年", @"5-10年",
                          @"10年以上"];
    self.xueliArray = @[@"初中以下", @"中专/中技", @"高中", @"大专", @"本科",
                        @"硕士", @"博士"];
    self.worktimeArray = @[@"白班", @"夜班"];

    if (self.isEdit) {
        [self loadDetailData];
        self.navigationItem.title = @"编辑";
    } else {
        self.navigationItem.title = @"发布招聘";
    }

    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.cornerRadius = 3;
     //设置边框颜色
    self.jianjieTextView.layer.borderColor = UIColorWithRGB(245, 245, 245, 1).CGColor; //设置边框颜色
    self.jianjieTextView.layer.borderWidth = 1.0f;
}
#pragma mark – Network

- (void)loadDetailData {
    NSDictionary *params = @{ @"id": @(self.fabuId) };
    [DZNetworkingTool postWithUrl:kQiyeWorkInfo
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                //赋值
                self.gognsiName.text = [NSString stringWithFormat:@"%@", dict[@"companyName"]];
                [self.zhaopinGangweiBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"recruitment_post"]] forState:UIControlStateNormal];
                ;
                self.peopleText.text = [NSString stringWithFormat:@"%@", dict[@"recruitment_number"]];
                self.phoneTextField.text = [NSString stringWithFormat:@"%@", dict[@"telephone"]];
              
                [self.xueliBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"education"]] forState:UIControlStateNormal];
              
                [self.jingyanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"work_year"]] forState:UIControlStateNormal];
                [self.xinziBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"salary"]] forState:UIControlStateNormal];

                self.is_rest = [NSString stringWithFormat:@"%@", dict[@"is_rest"]];
                if ([dict[@"is_rest"] intValue] == 10) {
                    [self.danshuangXiuBtn setTitle:@"双休" forState:UIControlStateNormal];
                } else if ([dict[@"is_rest"] intValue] == 20) {
                    [self.danshuangXiuBtn setTitle:@"单休" forState:UIControlStateNormal];
                }
                self.putup = [NSString stringWithFormat:@"%@", dict[@"putup"]];
                if ([dict[@"putup"] intValue] == 10) {
                    [self.shiSuBtn setTitle:@"包食宿" forState:UIControlStateNormal];
                } else if ([dict[@"putup"] intValue] == 20) {
                    [self.shiSuBtn setTitle:@"不包食宿" forState:UIControlStateNormal];
                }
                self.risks_gold = [NSString stringWithFormat:@"%@", dict[@"risks_gold"]];
                if ([dict[@"risks_gold"] intValue] == 10) {
                    [self.wuxianyjBtn setTitle:@"五险一金" forState:UIControlStateNormal];
                } else if ([dict[@"risks_gold"] intValue] == 20) {
                    [self.wuxianyjBtn setTitle:@"无五险一金" forState:UIControlStateNormal];
                }
                self.jianjieTextView.text = [NSString stringWithFormat:@"%@", dict[@"brief"]];
                self.shehuiDaimatextField.text = [NSString stringWithFormat:@"%@", dict[@"social_code"]];
                self.emailTextField.text = [NSString stringWithFormat:@"%@", dict[@"email"]];
                [self.quyuBtn setTitle:dict[@"work_region"] forState:UIControlStateNormal];
                [self.workTimeBtn setTitle:dict[@"work_time"] forState:UIControlStateNormal];
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

    [DZNetworkingTool postWithUrl:kQiyeEducatione
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                //            [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.gangweiArray removeAllObjects];
                [self.gangweiArray addObjectsFromArray:responseObject[@"data"]];

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
- (void)cancelBtnClick{
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
    
}
//选择地址
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area{
    [self.quyuBtn setTitle:[NSString stringWithFormat:@"%@",area] forState:UIControlStateNormal];
    [self.pickerView hide];
}
//工作时间
-(void)alertworkTimeClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.worktimeArray.count) {
        [self.workTimeBtn setTitle:self.worktimeArray[rowInteger] forState:UIControlStateNormal];
        self.workTimeBtn.imageView.hidden=YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//薪资
- (void)alertxinziClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xinziArray.count) {
        [self.xinziBtn setTitle:self.xinziArray[rowInteger] forState:UIControlStateNormal];
        self.xinziBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//经验
- (void)alertjingyanClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.jingyanArray.count) {
        [self.jingyanBtn setTitle:self.jingyanArray[rowInteger] forState:UIControlStateNormal];
        self.jingyanBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//新建
- (void)sendMesessage {
    
    [self.bgView endEditing:YES];
    //    kQiyeRecruitMan
    if (self.gognsiName.text.length <= 0) {
        [DZTools showNOHud:@"公司名称不能为空！" delay:2];
        return;
    }
    if (self.shehuiDaimatextField.text.length <= 0) {
        [DZTools showNOHud:@"统一社会代码不能为空！" delay:2];
        return;
    }
    if ([self.zhaopinGangweiBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择招聘岗位" delay:2];
        return;
    }
    if (self.peopleText.text.length <= 0) {
        [DZTools showNOHud:@"招聘人数不能为空！" delay:2];
        return;
    }
    if ([self.xueliBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择学历" delay:2];
        return;
    }
    if ([self.jingyanBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择工作经验" delay:2];
        return;
    }
    if ([self.workTimeBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择工作时间" delay:2];
        return;
    }
    if ([self.danshuangXiuBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择单休双休" delay:2];
        return;
    }
    if ([self.shiSuBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择食宿情况" delay:2];
        return;
    }
    if (self.CodeTextField.text.length <= 0) {
        [DZTools showNOHud:@"验证码不能为空！" delay:2];
        return;
    }
    if (self.emailTextField.text.length <= 0) {
        [DZTools showNOHud:@"邮箱不能为空！" delay:2];
        return;
    }
    if ([self.xinziBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择薪酬" delay:2];
        return;
    }
    if ([self.wuxianyjBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择五险一金" delay:2];
        return;
    }
    if ([self.quyuBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择区域" delay:2];
        return;
    }
    if (self.jianjieTextView.text.length <= 0) {
        [DZTools showNOHud:@"招聘简介不能为空！" delay:2];
        return;
    }
    NSDictionary *dict = @{ @"token": [User getToken],
                            @"recruitment_post": self.zhaopinGangweiBtn.titleLabel.text,
                            @"recruitment_number": self.peopleText.text,
                            @"education": self.xueliBtn.titleLabel.text,
                            @"work_year": self.jingyanBtn.titleLabel.text,
                            @"work_time": self.workTimeBtn.titleLabel.text,
                            @"is_rest": self.is_rest,
                            @"putup": self.putup,
                            @"salary": self.xinziBtn.titleLabel.text,
                            @"risks_gold": self.risks_gold,
                            @"brief": self.jianjieTextView.text,
                            @"companyName": self.gognsiName.text,
                            @"social_code": self.shehuiDaimatextField.text,
                            @"telephone": self.phoneTextField.text,
                            @"email": self.emailTextField.text,
                            @"captcha": self.CodeTextField.text,
                            @"work_region": self.quyuBtn.titleLabel.text
                            };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if (self.isEdit) {
        [params setValue:@(self.fabuId) forKey:@"id"];
    }
    [DZNetworkingTool postWithUrl:self.isEdit ? kQiyeZhaoPinEdit : kQiyeRecruitMan
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
//岗位
- (void)alertgangweiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.gangweiArray.count) {
        
        [self.zhaopinGangweiBtn setTitle:self.gangweiArray[rowInteger] forState:UIControlStateNormal];
        self.zhaopinGangweiBtn.imageView.hidden = YES;
        self.gangwei = self.gangweiArray[rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//双休
- (void)alertXiuxiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xiuxiArray.count) {
        if (rowInteger == 0) {
            self.is_rest = @"10";
        } else if (rowInteger == 1) {
            self.is_rest = @"20";
        }
        
        [self.danshuangXiuBtn setTitle:self.xiuxiArray[rowInteger] forState:UIControlStateNormal];
        self.danshuangXiuBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//食宿
- (void)alertShisuClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.shisuArray.count) {
        
        if (rowInteger == 0) {
            self.putup = @"10";
        } else if (rowInteger == 1) {
            self.putup = @"20";
        }
        [self.shiSuBtn setTitle:self.shisuArray[rowInteger] forState:UIControlStateNormal];
        self.shiSuBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//学历
- (void)alertxueliClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xueliArray.count) {
        [self.xueliBtn setTitle:self.xueliArray[rowInteger] forState:UIControlStateNormal];
        self.xueliBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//五险
- (void)alertWuxinClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.wuxianArray.count) {
        //        typeId=@"";
        if (rowInteger == 0) {
            self.risks_gold = @"10";
        } else if (rowInteger == 1) {
            self.risks_gold = @"20";
        }
        [self.wuxianyjBtn setTitle:self.wuxianArray[rowInteger] forState:UIControlStateNormal];
        self.wuxianyjBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark – XibFunction

//验证验证码
- (IBAction)sureBtnClick:(id)sender {
    [self sendMesessage];
}

//获取验证码
- (IBAction)huoquYzmBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length == 0) {
        [DZTools showNOHud:@"手机号不能为空" delay:2];
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

    [sender setCountdown:60 WithStartString:@"" WithEndString:@"获取验证码"];
    NSDictionary *params = @{ @"mobile": self.phoneTextField.text,
                              @"event": @"recruit" };
    [DZNetworkingTool postWithUrl:kGetCodeURL
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
}

- (IBAction)endEditing:(id)sender {
    [self.bgView endEditing:YES];
}
//岗位
- (IBAction)gangweiBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择招聘岗位" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.gangweiArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.gangweiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertgangweiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertgangweiClick:self.gangweiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//双休
- (IBAction)xiuxiBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择单双休情况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.xiuxiArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.xiuxiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXiuxiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertXiuxiClick:self.xiuxiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//食宿
- (IBAction)shisuBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择食宿情况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.shisuArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.shisuArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertShisuClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertShisuClick:self.shisuArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


- (IBAction)wuxianBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择五险一金" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.wuxianArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.wuxianArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertWuxinClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertWuxinClick:self.wuxianArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//学历
- (IBAction)xueliBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择学历要求" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.xueliArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.xueliArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertxueliClick:i];
                                                }]];
    }
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

//薪资
- (IBAction)xinziBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择薪酬" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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

//工作时间
- (IBAction)workTimeBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工作时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.worktimeArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.worktimeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertworkTimeClick:i];
                                                }]];
    }
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//区域
- (IBAction)quyuBtnClick:(id)sender {
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}
#pragma mark – 懒加载
- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}

@end
