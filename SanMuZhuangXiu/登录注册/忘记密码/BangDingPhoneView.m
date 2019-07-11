//
//  BangDingPhoneView.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BangDingPhoneView.h"

@implementation BangDingPhoneView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"BangDingPhoneView" owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}
#pragma mark-- xib Action
//获取验证码
- (IBAction)codeBtnClicked:(UIButton *)sender {
    [self endEditing:YES];
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
      [sender setCountdown:60 WithStartString:@"" WithEndString:@"获取验证码"];
    NSDictionary *params = @{ @"mobile": self.phoneTF.text,
                              @"event": @"mobilelogin" }; //事件名称，注册register，短信登录mobilelogin，重置密码resetpwd
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
- (IBAction)quedingBtnClicked:(id)sender {
    [self endEditing:YES];
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
    NSDictionary *params = @{
                             @"mobile": self.phoneTF.text,
                              @"unionid": self.openid,
                              @"type": self.type,
                              @"captcha": self.codeTF.text,
                              @"nickname":self.nickname
                             };
    [DZNetworkingTool postWithUrl:kMessageLoginURL
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([responseObject[@"code"] intValue] == SUCCESS) {
              User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"userinfo"]];
              [User saveUser:user];
              NSString *imToken = responseObject[@"data"][@"im"][@"token"];
              [[NSUserDefaults standardUserDefaults] setObject:imToken forKey:IMToken];
              [[NSUserDefaults standardUserDefaults] synchronize];
              
              [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld",(long)user.user_id] name:user.nickname portrait:user.avatar];
              [[RCIM sharedRCIM] connectWithToken:imToken
                                          success:^(NSString *userId) {
                                              NSLog(@"登录成功========");
                                          }
                                            error:^(RCConnectErrorCode status) {
                                                NSLog(@"connect error %ld", (long) status);
                                                dispatch_async(dispatch_get_main_queue(), ^{
                                                    
                                                });
                                            }
                                   tokenIncorrect:^{
                                       //token过期或者不正确。
                                       //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                                       //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                                       NSLog(@"token错误");
                                       
                                   }];
              [DZTools showOKHud:responseObject[@"msg"] delay:2];
              self.block();
              [self removeFromSuperview];
          } else {
              [DZTools showNOHud:responseObject[@"msg"] delay:2];
          }
      }
       failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
           [DZTools showNOHud:RequestServerError delay:2.0];
       }
    IsNeedHub:YES];
}
- (IBAction)cancelBtnClicked:(id)sender {
    [self endEditing:YES];
    [self removeFromSuperview];
}
- (IBAction)endEdit:(id)sender {
    [self endEditing:YES];
}

@end
