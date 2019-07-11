//
//  RegisterViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/24.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "RegisterViewController.h"
#import "UIButton+Code.h"
#import "WebViewViewController.h"
#import "RegisterSuccessViewController.h"

@interface RegisterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UITextField *yaoqingmaTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (strong, nonatomic) NSString *code;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新用户注册";
 
    
    self.scrollView.contentInset = UIEdgeInsetsMake(NavAndStatusHight, 0, 0, 0);
    
    if (ViewHeight + 1 - NavAndStatusHight > 550) {
        _layOutheigth.constant = ViewHeight + 1 -NavAndStatusHight ;
    }else{
        self.layOutheigth.constant = 550;
    }
}
#pragma mark -- xib Action
//获取验证码
- (IBAction)codeBtnClicked:(UIButton *)sender {
//    sender.selected = !sender.selected;
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
                             @"event":@"register"};//事件名称，注册register，短信登录mobilelogin，重置密码resetpwd
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
//同意协议
- (IBAction)agreeBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
}
//协议详情
- (IBAction)xieyiBtnClicked:(UIButton *)sender {
    [self.view endEditing:YES];
    
    NSDictionary *dict=@{
                         @"keywords":@"registration_agreement"
                         };
    [DZNetworkingTool postWithUrl:kArticleInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *temp=responseObject[@"data"];
            NSString *urlStr=[NSString stringWithFormat:@"%@",temp[@"url"]];
            
            WebViewViewController *viewController = [WebViewViewController new];
            viewController.urlStr = urlStr;
            viewController.titleStr = @"用户注册协议";
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
  
}
//注册
- (IBAction)registerBtnClicked:(id)sender {
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
    
    if (self.codeTF.text.length == 0) {
        [DZTools showNOHud:@"验证码不能为空" delay:2];
        return;
    }
    if (self.passwordTF.text.length == 0) {
        [DZTools showNOHud:@"密码不能为空" delay:2];
        return;
    }
    if (self.confirmTF.text.length == 0) {
        [DZTools showNOHud:@"确认密码不能为空" delay:2];
        return;
    }
    if (![self.passwordTF.text isEqualToString:self.confirmTF.text]) {
        [DZTools showNOHud:@"两次输入的密码不一致" delay:2];
        return;
    }
    if (self.agreeBtn.selected == NO) {
        [DZTools showNOHud:@"请先阅读并同意《用户注册协议》" delay:2];
        return;
    }
    NSDictionary *params = @{@"mobile":self.phoneTF.text,
                             @"captcha":self.codeTF.text,
                             @"password":self.passwordTF.text,
                             @"invite":self.yaoqingmaTF.text.length == 0 ? @"" : self.yaoqingmaTF.text,
                             @"group":@"1"};//用户分组，1用户，2商家
    [DZNetworkingTool postWithUrl:kRegisterURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"userinfo"]];
            [User saveUser:user];
            RegisterSuccessViewController *viewController = [RegisterSuccessViewController new];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
//结束编辑
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
