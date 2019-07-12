//
//  FindFabujianliController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FindFabujianliController.h"
#import "ReLayoutButton.h"
#import "WSDatePickerView.h"
#import "AddressPickerView.h"

//#import "JYBDIDCardVC.h"
#import "FrontViewController.h"


@interface FindFabujianliController () <AddressPickerViewDelegate>
///工人姓名
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
//工种
@property (weak, nonatomic) IBOutlet ReLayoutButton *gongzhongBtn;
//特长
@property (weak, nonatomic) IBOutlet UITextField *techangTF;
//期望工作地
@property (weak, nonatomic) IBOutlet UITextField *workAddressTF;
//工龄
@property (weak, nonatomic) IBOutlet ReLayoutButton *jingyanBtn;
//工作区域
@property (weak, nonatomic) IBOutlet ReLayoutButton *quyuBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextView *textView;
//日工
@property (weak, nonatomic) IBOutlet UIButton *rigongBtn;
//包工
@property (weak, nonatomic) IBOutlet UIButton *baogongBtn;
//均可
@property (weak, nonatomic) IBOutlet UIButton *otherBtn;
//年龄
@property (weak, nonatomic) IBOutlet UITextField *ageTF;
//薪资
@property (weak, nonatomic) IBOutlet UITextField *rixinTF;
@property (weak, nonatomic) IBOutlet ReLayoutButton *xinziBtn;
//结账周期
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiezhangBtn;
//中途透支
@property (weak, nonatomic) IBOutlet ReLayoutButton *touzhiBtn;
//是否住工地
@property (weak, nonatomic) IBOutlet ReLayoutButton *zhusubtn;
//工龄
@property (weak, nonatomic) IBOutlet UITextField *gognlingTF;
//籍贯
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiguanBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@property (nonatomic, strong) AddressPickerView *pickerView;

@property (nonatomic, strong) NSArray *gongzhongArray;
@property (nonatomic, strong) NSArray *zhouqiArray;
@property (nonatomic, strong) NSArray *touzhiArray;
@property (nonatomic, strong) NSArray *zhugongdiArray;
@property (nonatomic, strong) NSArray *jiguanArray;
@property (nonatomic, strong) NSArray *xinziArray;
@property (nonatomic, strong) NSArray *jingyanArray;
//薪资计算方式10=日工,20=包工,30=均可
@property (nonatomic, strong) NSString *hezuofangshi;
@property (nonatomic, assign) int gongzhongID;

@end

@implementation FindFabujianliController


- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.isEdit) {
        [self loadData];
        self.navigationItem.title = @"编辑";
    } else {
        self.navigationItem.title = @"发布简历";
    }

    [self getSearchData];
    self.hezuofangshi = @"10";
    self.xinziArray = @[@"3K以下", @"3K-5k", @"5K-10K", @"10K-30K",
                        @"30K-50K", @"50K以上", @"面议"];
    self.jingyanArray = @[@"应届生", @"1年以内", @"1-3年", @"3-5年", @"5-10年", @"10年以上"];
    self.touzhiArray = [NSMutableArray arrayWithObjects:@"需要", @"不需要", nil];
    self.zhugongdiArray = [NSMutableArray arrayWithObjects:@"需要", @"不需要", nil];
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.cornerRadius = 3;

    self.textView.layer.borderColor = UIColorWithRGB(245, 245, 245, 1).CGColor; //设置边框颜色
    self.textView.layer.borderWidth = 1.0f;
    //设置边框颜色
}
#pragma mark – Network
//详细信息
- (void)loadData {
    [DZNetworkingTool postWithUrl:kjianliDetail
        params:@{ @"id": @(self.fabuId) }
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                [self.gongzhongBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"name"]] forState:UIControlStateNormal];
                self.techangTF.text = [NSString stringWithFormat:@"%@", dict[@"speciality"]];
                [self.quyuBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"work_address"]] forState:UIControlStateNormal];
                [self.jingyanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"work_year"]] forState:UIControlStateNormal];
                //薪资计算方式10=日工,20=包工,30=均可
                self.hezuofangshi = [NSString stringWithFormat:@"%@", dict[@"salary_money"]];
                if ([dict[@"salary_money"] intValue] == 10) {
                    self.baogongBtn.selected = NO;
                    self.otherBtn.selected = NO;
                    self.rigongBtn.selected = YES;
                } else if ([dict[@"salary_money"] intValue] == 20) {
                    self.baogongBtn.selected = YES;
                    self.otherBtn.selected = NO;
                    self.rigongBtn.selected = NO;
                } else if ([dict[@"salary_money"] intValue] == 30) {
                    self.baogongBtn.selected = NO;
                    self.otherBtn.selected = YES;
                    self.rigongBtn.selected = NO;
                }
                [self.xinziBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"salary"]] forState:UIControlStateNormal];
                [self.jiezhangBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"settlement_time"]] forState:UIControlStateNormal];
                if ([dict[@"advance"] intValue] == 10) {
                    [self.touzhiBtn setTitle:@"可以" forState:UIControlStateNormal];
                } else if ([dict[@"advance"] intValue] == 20) {
                    [self.touzhiBtn setTitle:@"不可以" forState:UIControlStateNormal];
                }
                if ([dict[@"putup"] intValue] == 10) {
                    [self.zhusubtn setTitle:@"提供" forState:UIControlStateNormal];
                } else if ([dict[@"putup"] intValue] == 20) {
                    [self.zhusubtn setTitle:@"不提供" forState:UIControlStateNormal];
                }
                self.ageTF.text = [NSString stringWithFormat:@"%@", dict[@"age"]];
                self.textView.text = [NSString stringWithFormat:@"%@", dict[@"brief"]];
                [self.jiguanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"native_place"]] forState:UIControlStateNormal];

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

- (void)getSearchData {
    [DZNetworkingTool postWithUrl:kArrayRecruit
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.jiguanArray = responseObject[@"data"][@"native_place"];
                self.gongzhongArray = responseObject[@"data"][@"stuff_work"];
                self.zhouqiArray = responseObject[@"data"][@"settlement_time"];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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
//薪资
- (void)alertxinziClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xinziArray.count) {
        [self.xinziBtn setTitle:self.xinziArray[rowInteger] forState:UIControlStateNormal];
        self.xinziBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//结账周期
- (void)alertJiezhangClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.zhouqiArray.count) {
        //        typeId=@"";
        [self.jiezhangBtn setTitle:self.zhouqiArray[rowInteger] forState:UIControlStateNormal];
        self.jiezhangBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//透支
- (void)alertTouzhiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.touzhiArray.count) {
        //        typeId=@"";
        [self.touzhiBtn setTitle:self.touzhiArray[rowInteger] forState:UIControlStateNormal];
        self.touzhiBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//住宿
- (void)alertZhusuClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.zhugongdiArray.count) {
        //        typeId=@"";
        [self.zhusubtn setTitle:self.zhugongdiArray[rowInteger] forState:UIControlStateNormal];
        self.zhusubtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)cancelBtnClick {
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
//地址
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [self.quyuBtn setTitle:[NSString stringWithFormat:@"%@%@%@", province, city, area] forState:UIControlStateNormal];
    [self.pickerView hide];
}
//工种
- (void)alertgongzhongClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.gongzhongArray.count) {
        
        //        typeId=@"";
        [self.gongzhongBtn setTitle:self.gongzhongArray[rowInteger][@"name"] forState:UIControlStateNormal];
        self.gongzhongBtn.imageView.hidden = YES;
        self.gongzhongID = [self.gongzhongArray[rowInteger][@"id"] intValue];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//籍贯
- (void)alertJiguangClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.jiguanArray.count) {
        //        typeId=@"";
        [self.jiguanBtn setTitle:self.jiguanArray[rowInteger] forState:UIControlStateNormal];
        self.jiguanBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark – XibFunction

- (IBAction)endEditing:(id)sender {
    [self.bgView endEditing:YES];
}
//合作方式
- (IBAction)hezuostyleBtnClick:(id)sender {

    UIButton *button = (UIButton *) sender;
    button.selected = YES;
    if (button.tag == 0) {
        self.baogongBtn.selected = NO;
        self.otherBtn.selected = NO;
        self.hezuofangshi = @"10";
    } else if (button.tag == 1) {
        self.rigongBtn.selected = NO;
        self.otherBtn.selected = NO;
        self.hezuofangshi = @"20";
    } else {
        self.baogongBtn.selected = NO;
        self.rigongBtn.selected = NO;
        self.hezuofangshi = @"30";
    }
}
//工种
- (IBAction)gongzhongBtnClick:(id)sender {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择住宿情况" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.gongzhongArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.gongzhongArray[i][@"name"]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertgongzhongClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertgongzhongClick:self.gongzhongArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//结账周期
- (IBAction)jezhangBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择结账周期" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.zhouqiArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.zhouqiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertJiezhangClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertJiezhangClick:self.zhouqiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (IBAction)touzhiBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择是否透支" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.touzhiArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.touzhiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertTouzhiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertTouzhiClick:self.touzhiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//住宿
- (IBAction)zhusuBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择是否住工地" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.zhugongdiArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.zhugongdiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertZhusuClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertZhusuClick:self.zhugongdiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//籍贯
- (IBAction)jigaunBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择籍贯" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.jiguanArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.jiguanArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertJiguangClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertJiguangClick:self.jiguanArray.count];
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


//薪资
- (IBAction)xinziBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择薪资要求" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
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


//区域
- (IBAction)quyuBtnClick:(id)sender {
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}

//确认发布
- (IBAction)faBuBtnClicked:(id)sender {
    if ([self.gongzhongBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择工种" delay:2];
        return;
    }
    if (self.techangTF.text.length == 0) {
        [DZTools showNOHud:@"请输入特长" delay:2];
        return;
    }
    if (self.quyuBtn.titleLabel.text.length == 0) {
        [DZTools showNOHud:@"请选择期望工作地" delay:2];
        return;
    }
    if ([self.ageTF.text isEqualToString:self.ageTF.placeholder]) {
        [DZTools showNOHud:@"请输入年龄" delay:2];
        return;
    }
    if (self.xinziBtn.titleLabel.text.length == 0) {
        [DZTools showNOHud:@"请选择期望薪资" delay:2];
        return;
    }
    if ([self.jiezhangBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择结账周期" delay:2];
        return;
    }
    if ([self.touzhiBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择中途透支情况" delay:2];
        return;
    }
    if ([self.zhusubtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择是否住工地" delay:2];
        return;
    }
    if (self.jingyanBtn.titleLabel.text.length == 0) {
        [DZTools showNOHud:@"请选择工龄" delay:2];
        return;
    }
    if ([self.jiguanBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择籍贯" delay:2];
        return;
    }
    if (self.textView.text.length == 0) {
        [DZTools showNOHud:@"请输入招聘简介" delay:2];
        return;
    }
    if (self.textView.text.length <= 20) {
        [DZTools showNOHud:@"请输入20字以上说明" delay:2];
        return;
    }
    if (self.nameLabel.text.length == 0) {
        [DZTools showNOHud:@"请输入工人姓名" delay:2];
        return;
    }
    
    self.commitBtn.userInteractionEnabled = NO;
    NSDictionary *dict = @{
                           @"find_user_name":self.nameLabel.text,
                           @"stuff_work_id": @(self.gongzhongID),
                            @"speciality": self.techangTF.text,
                            @"work_address": self.quyuBtn.titleLabel.text,
                            @"salary": self.xinziBtn.titleLabel.text,
                            @"salary_money": self.hezuofangshi, //薪资计算方式10=日工,20=包工,30=均可
                            @"settlement_time": self.jiezhangBtn.titleLabel.text,
                            @"advance": [self.touzhiBtn.titleLabel.text isEqualToString:@"是"] ? @"10" : @"20",
                            @"putup": [self.zhusubtn.titleLabel.text isEqualToString:@"是"] ? @"10" : @"20",
                            @"work_year": self.jingyanBtn.titleLabel.text,
                            @"native_place": self.jiguanBtn.titleLabel.text,
                            @"brief": self.textView.text,
                            @"longitude": @([DZTools getAppDelegate].longitude),
                            @"latitude": @([DZTools getAppDelegate].latitude),
                            @"images": @"",
                            @"age":self.ageTF.text
                            
                            };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if (self.isEdit) {
        [params setValue:@(self.fabuId) forKey:@"id"];
    }
    [DZNetworkingTool postWithUrl:self.isEdit ? kEditAddJob : kFindWorkAddJob
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];
            }  else {
                if ([responseObject[@"msg"] containsString:@"请先完成实名认证"]) {
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
//                  JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
//
//                  AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image) {
//                      if (info.name == nil || info.num == nil) {
//                          [[DZTools topViewController].navigationController popViewControllerAnimated:YES];
//                          [DZTools showText:@"请拍摄头像面" delay:2];
//                      } else {
//                          FrontViewController *viewController = [[FrontViewController alloc] init];
//                          viewController.IDInfo = info;
//                          [DZTools topViewController].hidesBottomBarWhenPushed = YES;
//                          [[DZTools topViewController].navigationController pushViewController:viewController animated:YES];
//                      }
//                  };
//                  self.hidesBottomBarWhenPushed = YES;
//                  [self.navigationController pushViewController:AVCaptureVC animated:YES];
                              }]];
            [alert addAction:[UIAlertAction
                              actionWithTitle:@"否"
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *_Nonnull action) {
                  [self.navigationController popViewControllerAnimated:YES];
            }]];
            //弹出提示框
            [self presentViewController:alert animated:true completion:nil];
                    
                }else if ([responseObject[@"msg"] containsString:@"实名认证中"]){
                    [DZTools showNOHud:@"实名认证中，不能发布招聘信息" delay:2];
                    
                }else{
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
                
            }
            self.commitBtn.userInteractionEnabled = YES;
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            self.commitBtn.userInteractionEnabled = YES;
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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
