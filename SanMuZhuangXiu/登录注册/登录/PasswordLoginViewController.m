//
//  PasswordLoginViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/24.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "PasswordLoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import <UMShare/UMShare.h>
#import "BangDingPhoneView.h"

@interface PasswordLoginViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;

@property (strong, nonatomic) BangDingPhoneView *bangDingPhoneView;
///用户名
@property (nonatomic, strong) NSString *loginUserName;
///用户ID
@property (nonatomic, strong) NSString *loginUserId;
///用户token
@property (nonatomic, strong) NSString *loginToken;
///用户密码
@property (nonatomic, strong) NSString *loginPassword;
///登录失败时间
@property (nonatomic) int loginFailureTimes;


@end

@implementation PasswordLoginViewController

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

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"新用户注册" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x101010) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

#pragma mark-- xib Action
- (IBAction)loginBtnClcked:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneTF.text.length == 0) {
        [DZTools showNOHud:@"手机号不能为空" delay:2];
        return;
    }
    //正则表达式
     NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTF.text];
    if (!isMatch) {
        
         [DZTools showNOHud:@"手机号格式不正确" delay:1.0];
        return;
    }

    if (self.passwordTF.text.length == 0) {
        [DZTools showNOHud:@"密码不能为空" delay:2];
        return;
    }
    
    [DZTools showHud];
    NSDictionary *params = @{ @"account": self.phoneTF.text,
                              @"password": self.passwordTF.text };
    [DZNetworkingTool postWithUrl:kPasswordLoginURL
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [DZTools hideHud];
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"userinfo"]];
                [User saveUser:user];
                
                NSString *imToken = responseObject[@"data"][@"im"][@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:imToken forKey:IMToken];
                [[NSUserDefaults standardUserDefaults] synchronize];

                [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[NSString stringWithFormat:@"%ld", (long) user.user_id] name:user.nickname portrait:user.avatar];
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
                NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//忘记密码
- (IBAction)forgetPasswordBtnClicked:(id)sender {
    ForgetPasswordViewController *viewController = [ForgetPasswordViewController new];
    self.hidesBottomBarWhenPushed = YES;
    viewController.block = ^(NSString *_Nonnull mobile, NSString *_Nonnull password) {
        self.phoneTF.text = mobile;
        self.passwordTF.text = password;
    };
    [self.navigationController pushViewController:viewController animated:YES];
}
//快捷登录
- (IBAction)quicklyLoginBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
- (void)rightBarButtonItemClicked {
    RegisterViewController *viewController = [RegisterViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)passwordError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"您输入的账号密码不正确" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"您输入的账号密码不正确"];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, 10)];
    [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action){
                                                         
                                                     }];
    [okAction setValue:UIColorFromRGB(0x333333) forKey:@"titleTextColor"];
    [alertController addAction:okAction];
    UIAlertAction *forgetAction = [UIAlertAction actionWithTitle:@"找回密码"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
         ForgetPasswordViewController *viewController = [ForgetPasswordViewController new];
         self.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:viewController animated:YES];
                                                         }];
    [forgetAction setValue:UIColorFromRGB(0x333333) forKey:@"titleTextColor"];
    [alertController addAction:forgetAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)regiterWith:(NSString *)openID token:(NSString*)token nickName:(NSString*)nick sex:(NSInteger)sex face:(NSString*)face type:(NSString*)type{
    NSDictionary *params =@{
                            @"unionid":openID,
                            @"type":type,
                            };
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
            NSInteger index = [[self.navigationController viewControllers] indexOfObject:self];
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
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
            NSInteger index = [[weakSelf.navigationController viewControllers] indexOfObject:weakSelf];
            [weakSelf.navigationController popToViewController:[weakSelf.navigationController.viewControllers objectAtIndex:index - 2] animated:YES];
        }; //1余额 2支付宝 3微信
    }
    return _bangDingPhoneView;
}
@end
