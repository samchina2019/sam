//
//  ChangePasswordViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/25.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "ChangePasswordViewController.h"

#import "MQVerCodeImageView.h"
#import "PasswordLoginViewController.h"
#import "UIButton+Code.h"

@interface ChangePasswordViewController ()<FSSegmentTitleViewDelegate>
///验证码图片
@property (weak, nonatomic) IBOutlet MQVerCodeImageView *codeImgV;
///标题View
@property (weak, nonatomic) IBOutlet UIView *titleView;
///电话号码
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
///验证码
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
///密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
///确认密码
@property (weak, nonatomic) IBOutlet UITextField *confirmTF;
///验证码输入
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
///设置高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraintHeight;
///验证码label
@property (weak, nonatomic) IBOutlet UILabel *yuanmimaLabel;
///验证码Btn
@property (weak, nonatomic) IBOutlet UIButton *yanzhengmaBtn;



@property (copy, nonatomic) NSString *codeStr;

@property(nonatomic,assign)BOOL isLongin;
@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.title = @"密码修改";
    self.phoneTF.text=[NSString stringWithFormat:@"%@",self.phoneStr];
    self.phoneTF.userInteractionEnabled=NO;
    
//    _codeImgV.bolck = ^(NSString *imageCodeStr){
//        //打印生成的验证码
//        NSLog(@"imageCodeStr = %@",imageCodeStr);
//        self.codeStr = imageCodeStr;
//    };
//    //验证码字符是否可以斜着
//    _codeImgV.isRotation = YES;
//    [_codeImgV freshVerCode];
    
    //初始化界面
    self.isLongin=YES;
    self.yuanmimaLabel.text=@"验证码：";
    self.codeTF.hidden=YES;
    self.codeTextField.hidden=NO;
    self.yanzhengmaBtn.hidden=NO;
    
    [self initTitleView];
}
#pragma mark – UI

- (void)initTitleView
{
    self.segmentTitleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0, 0, ViewWidth, 50) titles:@[@"登录密码修改",@"支付密码修改"] delegate:self indicatorType:FSIndicatorTypeCustom];
    self.segmentTitleView.backgroundColor = [UIColor clearColor];
    self.segmentTitleView.titleNormalColor = UIColorFromRGB(0x333333);
    self.segmentTitleView.titleSelectColor = TabbarColor;
    self.segmentTitleView.indicatorExtension = 2;
    self.segmentTitleView.selectIndex=0;
    self.segmentTitleView.indicatorColor = TabbarColor;
    [self.titleView addSubview:self.segmentTitleView];
}
#pragma mark-- FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    NSLog(@"点击了%ld,%ld",(long)startIndex,(long)endIndex);
    if (titleView.selectIndex==0) {
        self.isLongin=YES;
        self.yuanmimaLabel.text=@"验证码：";
        self.codeTF.hidden=YES;
        self.codeTextField.hidden=NO;
        self.yanzhengmaBtn.hidden=NO;
    }else{
        self.yuanmimaLabel.text=@"验证码：";
        self.codeTF.hidden=YES;
        self.codeTextField.hidden=NO;
        self.yanzhengmaBtn.hidden=NO;
        
        self.isLongin=NO;
    }
}
#pragma mark-- XibFunction
- (IBAction)commitBtnClicked:(id)sender {
 
    if (self.passwordTF.text.length==0) {
        [DZTools showNOHud:@"新密码不能为空" delay:2];
        return;
    }
    if (self.confirmTF.text.length==0) {
        [DZTools showNOHud:@"确认密码不能为空" delay:2];
        return;
    }
    if (![self.confirmTF.text isEqualToString:self.passwordTF.text]) {
        [DZTools showNOHud:@"新密码和确认密码不相同，请重新设置" delay:2];
        return;
    }
    NSDictionary *dict=@{};
    NSString *url=@"";
    if (self.isLongin) {
        if (self.codeTextField.text.length==0) {
            [DZTools showNOHud:@"验证码不能为空" delay:2];
            return;
        }
                    dict=@{
                           @"mobile":self.phoneTF.text,
                           @"captcha":self.codeTextField.text,
                           @"newpassword":self.passwordTF.text
                             };
        
        url=kForgetPasswordURL;
    }else{
        if (self.codeTextField.text.length==0) {
            [DZTools showNOHud:@"验证码不能为空" delay:2];
            return;
        }
        dict=@{
               @"sms":self.codeTextField.text,
               @"pay_password":self.passwordTF.text
               };
        url=kEditPayPassword;
    }
    [DZNetworkingTool postWithUrl:url params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            if (self.isLongin) {
                ///重置之后token失效，然后需要重新设置用户信息及RCIM登录
                User *user = [User mj_objectWithKeyValues:responseObject[@"data"][@"userinfo"]];
                [User saveUser:user];
                //IM的信息设置及本地缓存
                NSString *imToken = responseObject[@"data"][@"im"][@"token"];
                [[NSUserDefaults standardUserDefaults] setObject:imToken forKey:IMToken];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //登录IM
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
               
            }
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
}

#pragma mark – XibFunction

- (IBAction)refreshCodeImage:(id)sender {
    [_codeImgV freshVerCode];
}
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)yanzhengmaBtnCLick:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.phoneTF.text.length == 0) {
        [DZTools showNOHud:@"手机号不能为空" delay:2];
        return;
    }
    //正则
      NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTF.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    //发送验证码
     [sender setCountdown:60 WithStartString:@"" WithEndString:@"获取验证码"];
    NSDictionary *params = @{
                            @"mobile":self.phoneTF.text,
                            @"event":self.isLongin ? @"resetpwd" : @"getcheck"
                             };//TODO: 事件ID未填
    [DZNetworkingTool postWithUrl:self.isLongin ? kGetCodeURL  : kGetCodeURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
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

@end
