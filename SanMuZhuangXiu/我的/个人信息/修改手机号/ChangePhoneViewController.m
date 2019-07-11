//
//  ChangePhoneViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "UIButton+Code.h"

@interface ChangePhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *oldPhoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UITextField *xinPhoneTF;
@property (weak, nonatomic) IBOutlet UIButton *yanzhengmaBtn;
@end

@implementation ChangePhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"修改手机号";
    self.oldPhoneTF.text = [User getUser].mobile;
    self.oldPhoneTF.userInteractionEnabled = NO;
}

#pragma mark-- XibFunction
- (IBAction)commitBtnClicked:(id)sender {
    if (self.oldPhoneTF.text.length == 0) {
        [DZTools showNOHud:@"原手机号不能为空" delay:2];
        return;
    }
    if (self.codeTF.text.length == 0) {
        [DZTools showNOHud:@"验证码不能为空" delay:2];
        return;
    }
    if (self.xinPhoneTF.text.length == 0) {
        [DZTools showNOHud:@"新手机号不能为空" delay:2];
        return;
    }
    //电话号码非法验证
      NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.xinPhoneTF.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    
    NSDictionary *params = @{ @"mobile": self.xinPhoneTF.text,
                              @"sms": self.codeTF.text };
    [DZNetworkingTool postWithUrl:kChangeMobile
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS)
            {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"userinfo"]];
                [User saveUser:user];
                self.block();
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:YES];
}
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)yanzhengmaBtnCLick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.oldPhoneTF.text.length == 0) {
        [DZTools showNOHud:@"原手机号不能为空" delay:2];
        return;
    }
    //电话号码非法验证
      NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.oldPhoneTF.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
      [sender setCountdown:60 WithStartString:@"" WithEndString:@"获取验证码"];
    NSDictionary *params = @{ @"mobile": self.oldPhoneTF.text,
                            @"event": @"change" };
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
        IsNeedHub:YES];
}

@end
