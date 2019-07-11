//
//  LoginViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "LoginViewController.h"
#import "UIButton+Code.h"
#import "RegisterViewController.h"
#import "PasswordLoginViewController.h"
#import <UMShare/UMShare.h>
#import "BangDingPhoneView.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (strong, nonatomic) BangDingPhoneView *bangDingPhoneView;

@end

@implementation LoginViewController



- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.codeBtn cancelCountdownWithEndString:@"获取验证码"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"登录";
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
   self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
}
#pragma mark-- xib Action
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
    NSDictionary *params = @{ @"mobile": self.phoneTF.text,
                            @"event": @"mobilelogin"
                            
                              }; //事件名称，注册register，短信登录mobilelogin，重置密码resetpwd
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
//登录
- (IBAction)loginBtnClcked:(id)sender {
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
    [DZTools showHud];
    NSDictionary *params = @{ @"mobile": self.phoneTF.text,
                            @"captcha": self.codeTF.text
                              
                              };
    [DZNetworkingTool postWithUrl:kMessageLoginURL
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [DZTools hideHud];
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
                        [[RCIM sharedRCIM] refreshUserInfoCache:[RCIM sharedRCIM].currentUserInfo withUserId:[NSString stringWithFormat:@"%ld",(long)user.user_id]];
                        
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
//注册
- (IBAction)registerBtnClicked:(id)sender {
    RegisterViewController *viewController = [RegisterViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//密码登录
- (IBAction)passwordLoginBtnClicked:(id)sender {
    PasswordLoginViewController *viewController = [PasswordLoginViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//结束编辑
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
//qq登录
- (IBAction)qqLogin:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [DZTools showNOHud:@"授权失败" delay:2.0];
        } else {
            UMSocialUserInfoResponse *resp = result;
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            [weakSelf regiterWith:resp.openid token:resp.accessToken nickName:resp.name sex:[resp.originalResponse[@"sex"] integerValue] face:resp.iconurl type:@"qq"];
        }
    }];
    
}
//微信登录
- (IBAction)wxLogin:(id)sender {
    __weak typeof(self) weakSelf = self;
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_WechatSession currentViewController:nil completion:^(id result, NSError *error) {
        if (error) {
            [DZTools showNOHud:@"授权失败" delay:2.0];
        } else {
            UMSocialUserInfoResponse *resp = result;
            
            // 授权信息
            NSLog(@"Wechat uid: %@", resp.uid);
            NSLog(@"Wechat openid: %@", resp.openid);
            NSLog(@"Wechat unionid: %@", resp.unionId);
            NSLog(@"Wechat accessToken: %@", resp.accessToken);
            NSLog(@"Wechat refreshToken: %@", resp.refreshToken);
            NSLog(@"Wechat expiration: %@", resp.expiration);
            
            // 用户信息
            NSLog(@"Wechat name: %@", resp.name);
            NSLog(@"Wechat iconurl: %@", resp.iconurl);
            NSLog(@"Wechat gender: %@", resp.unionGender);
            
            // 第三方平台SDK源数据
            NSLog(@"Wechat originalResponse: %@", resp.originalResponse);
            [weakSelf regiterWith:resp.openid token:resp.accessToken nickName:resp.name sex:[resp.originalResponse[@"sex"] integerValue] face:resp.iconurl type:@"wechat"];
        }
    }];
}

#pragma mark - Function

-(void)regiterWith:(NSString *)openID token:(NSString*)token nickName:(NSString*)nick sex:(NSInteger)sex face:(NSString*)face type:(NSString*)type{
    NSDictionary *params =@{@"unionid":openID, @"type":type};
    [DZNetworkingTool postWithUrl:kDiSanFangLoginURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        int code = [responseObject[@"code"] intValue];
        if (code == 1) {
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
            [self.navigationController popViewControllerAnimated:YES];
        }else if (code == 2) {//未绑定
            self.bangDingPhoneView.openid = openID;
            self.bangDingPhoneView.type = type;
            self.bangDingPhoneView.nickname = nick;
            [[DZTools getAppWindow] addSubview:self.bangDingPhoneView];
        }else{
            //服务器插入数据失败
        }
        [DZTools hideHud];
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:YES];
}

#pragma mark – 懒加载
- (BangDingPhoneView *)bangDingPhoneView {
    if (!_bangDingPhoneView) {
        _bangDingPhoneView = [[BangDingPhoneView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(self) weakSelf = self;
        _bangDingPhoneView.block = ^() {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }; //1余额 2支付宝 3微信
    }
    return _bangDingPhoneView;
}
@end
