//
//  ForgetPasswordViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/24.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "UIButton+Code.h"

@interface ForgetPasswordViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;

@property (strong, nonatomic) NSString *code;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"忘记密码";
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    if (ViewHeight + 1 - NavAndStatusHight > 470) {
        _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
    }else{
        self.layOutheigth.constant = 470;
    }
}

#pragma mark -- xib Action
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
                         @"event":@"resetpwd"};//事件名称，注册register，短信登录mobilelogin，重置密码resetpwd
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
//确定提交
- (IBAction)commitBtnClicked:(id)sender {
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
        [DZTools showNOHud:@"新密码不能为空" delay:2];
        return;
    }
    if (self.confirmTF.text.length == 0) {
        [DZTools showNOHud:@"确认新密码不能为空" delay:2];
        return;
    }
    if (![self.passwordTF.text isEqualToString: self.confirmTF.text]) {
        [DZTools showNOHud:@"两次输入的新密码不一致" delay:2];
        return;
    }
    NSDictionary *params = @{
                             @"mobile":self.phoneTF.text,
                             @"captcha":self.codeTF.text,
                             @"newpassword":self.passwordTF.text
                             
                             };
    [DZNetworkingTool postWithUrl:kForgetPasswordURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            self.block(self.phoneTF.text, self.passwordTF.text);
            [self.navigationController popViewControllerAnimated:YES];
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
