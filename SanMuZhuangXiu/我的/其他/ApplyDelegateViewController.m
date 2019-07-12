//
//  ApplyDelegateViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ApplyDelegateViewController.h"
#import "UIButton+Code.h"
#import "ReLayoutButton.h"
#import "AddressPickerView.h"

@interface ApplyDelegateViewController ()<AddressPickerViewDelegate>
///地址按钮
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressButton;
//背景图片
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *addressTF;
@property (weak, nonatomic) IBOutlet UITextField *hangyeTF;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
///地址pickerView
@property (nonatomic, strong) AddressPickerView *pickerView;
@property (strong, nonatomic) NSString *code;
@property (weak, nonatomic) IBOutlet ReLayoutButton *hangyeButton;
@property(nonatomic,strong)NSMutableArray *hangyeArray;

@end

@implementation ApplyDelegateViewController

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.codeBtn cancelCountdownWithEndString:@"获取验证码"];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadHangyeData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"申请代理";
    
    self.hangyeArray=[NSMutableArray array];
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 5;
}
#pragma mark – Network

-(void)loadHangyeData{
//   kArticleInfo
    [DZNetworkingTool postWithUrl:kIndustryList params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [self.hangyeArray removeAllObjects];
            NSArray *array=responseObject[@"data"][@"value"];
            for (NSDictionary *dict in array) {
                [self.hangyeArray addObject:dict];
            }
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
    
}
#pragma mark - AddressPickerViewDelegate
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [self.addressButton setTitle:[NSString stringWithFormat:@"%@%@%@", province, city, area] forState:UIControlStateNormal];
    [self.pickerView hide];
}
//取消选中
- (void)cancelBtnClick {
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
#pragma mark - XibFunction
//获取验证码
- (IBAction)codeBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneTF.text.length == 0) {
        [DZTools showNOHud:@"手机号不能为空" delay:2];
        return;
    }
    NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTF.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    [sender setCountdown:60 WithStartString:@"" WithEndString:@"获取验证码"];
    NSDictionary *params = @{@"mobile":self.phoneTF.text,
                             @"event":@"getcheck"
                             };//TODO: 事件ID未填
    [DZNetworkingTool postWithUrl:kGetCodeURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
//提交
- (IBAction)commitBtnClcked:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneTF.text.length == 0) {
        [DZTools showNOHud:@"手机号不能为空" delay:2];
        return;
    }
    //电话号码非法验证
      NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTF.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [DZTools showNOHud:@"验证码不能为空" delay:2];
        return;
    }
    if (self.nameTF.text.length==0) {
        
    [DZTools showNOHud:@"姓名不能为空" delay:2];
    return;
    }
    if ([self.addressButton.titleLabel.text isEqualToString:@"请选择地址"]) {
        
        [DZTools showNOHud:@"地区不能为空" delay:2];
        return;
    }
    if (self.moneyTF.text.length==0) {
        
        [DZTools showNOHud:@"投资金额不能为空" delay:2];
        return;
    }
    if ([self.hangyeButton.titleLabel.text isEqualToString:@"请选择您所从事的行业"]) {
        
        [DZTools showNOHud:@"从事行业不能为空" delay:2];
        return;
    }
    NSDictionary *dict=@{
                         @"user_name":self.nameTF.text,
                         @"mobile":self.phoneTF.text,
                         @"address":self.addressButton.titleLabel.text,
                         @"industry":self.hangyeButton.titleLabel.text,
                         @"investment_amount":self.moneyTF.text,
                         @"captcha":self.codeTF.text,
                    
                         };
    [DZNetworkingTool postWithUrl:kAddAgentApply params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {

            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            self.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
    
}
//地区的选择
- (IBAction)addrssBtnClick:(id)sender {
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}

//行业
- (IBAction)selectHangYe:(id)sender {
    [self.view endEditing:YES];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择行业" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.hangyeArray.count; i++) {
        NSDictionary *dict = self.hangyeArray[i];
        NSString *name=dict[@"k"];
        
        [alert addAction:[UIAlertAction actionWithTitle:name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXinziClick:i];
                                                }]];
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertXinziClick:self.hangyeArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)alertXinziClick:(NSInteger)rowInteger
{
    
    if (rowInteger < self.hangyeArray.count) {
        //
        NSDictionary *dict = self.hangyeArray[rowInteger];
        [self.hangyeButton setTitle:[NSString stringWithFormat:@"%@",dict[@"k"]] forState:UIControlStateNormal];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
//结束编辑
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark – 懒加载
- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
       
    }
    return _pickerView;
}

@end
