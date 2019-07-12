//
//  MemberGradeViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MemberGradeViewController.h"
#import "ChangePasswordViewController.h"
#import "ZhiFuSelectTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface MemberGradeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *chaojiHuiyuanLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImgView;
@property (weak, nonatomic) IBOutlet UILabel *currentPai;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftPai;
@property (weak, nonatomic) IBOutlet UILabel *rightPai;
@property (weak, nonatomic) IBOutlet UILabel *leftnum;
@property (weak, nonatomic) IBOutlet UILabel *rightnum;
@property (weak, nonatomic) IBOutlet UILabel *currentnum;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *jifenBtn;
@property (weak, nonatomic) IBOutlet UIButton *moneyBtn;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentnumX;
@property (weak, nonatomic) IBOutlet UIButton *buyNowBtn;

@property (strong, nonatomic) ZhiFuSelectTypeView *zhiFuSelectView;

@property (strong, nonatomic) NSArray *imgArray;

@property (strong, nonatomic) NSString *chaojiPrice;

@end

@implementation MemberGradeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.imgArray = @[@"bgs_putong", @"bgs_tongpai", @"bgs_yinpai", @"bgs_jinpai", @"bgs_zhuanshi", @"bgs_zhuanshi"];
    [self getDataFromServer];
}
- (void)getDataFromServer {
    [DZNetworkingTool postWithUrl:kBuyLevelDetail
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                if ([dict[@"level_end_time_text"] length] == 0) {
                    self.timeLabel.hidden = YES;
                } else {
                    self.timeLabel.hidden = NO;
                    self.timeLabel.text = [NSString stringWithFormat:@"有效期至:%@", dict[@"level_end_time_text"]];
                }
                NSInteger level = [dict[@"level"] integerValue] - 1;
                if (level == 5) { //超级会员
                    self.currentPai.text = @"超级会员";
                    self.currentnum.hidden = YES;
                    self.leftnum.hidden = YES;
                    self.leftPai.hidden = YES;
                    self.rightnum.hidden = YES;
                    self.rightPai.hidden = YES;
                    self.progressView.hidden = YES;
                    self.buyNowBtn.userInteractionEnabled = NO;
                } else {
                    self.currentnum.hidden = NO;
                    self.leftnum.hidden = NO;
                    self.leftPai.hidden = NO;
                    self.rightnum.hidden = NO;
                    self.rightPai.hidden = NO;
                    self.progressView.hidden = NO;
                    self.buyNowBtn.userInteractionEnabled = YES;
                }
                self.bgImgView.image = [UIImage imageNamed:self.imgArray[level]];
                NSInteger current_buy = [dict[@"current_buy"] integerValue];
                NSInteger next_buy = [dict[@"next_buy"] integerValue];
                NSInteger have_buy_num = [dict[@"have_buy_num"] integerValue];
                self.currentPai.text = dict[@"current_buy_name"];
                self.currentnum.text = [NSString stringWithFormat:@"%ld", (long) have_buy_num];
                self.leftnum.text = [NSString stringWithFormat:@"%ld", (long) current_buy];
                self.leftPai.text = dict[@"current_buy_name"];
                self.rightnum.text = [NSString stringWithFormat:@"%ld", (long) next_buy];
                self.rightPai.text = dict[@"next_buy_name"];
                self.progressView.progress = [dict[@"rate"] floatValue];

                self.currentnumX.constant = (ViewWidth - 120) * [dict[@"rate"] floatValue] + 60 - ViewWidth / 2.0;

                self.textView.text = dict[@"membership_rules"];
                self.chaojiHuiyuanLabel.text = [NSString stringWithFormat:@"超级会员%@元/年", dict[@"super_level_money"]];
                self.chaojiPrice = [NSString stringWithFormat:@"%@", dict[@"super_level_money"]];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

        }
        IsNeedHub:NO];
}
#pragma mark - XibFunction
//返回
- (IBAction)backBtnClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//充值方式选择
- (IBAction)selectChongzhiType:(UIButton *)sender {
    sender.selected = YES;
    if (sender.tag == 1) {
        _moneyBtn.selected = NO;
    } else {
        _jifenBtn.selected = NO;
    }
}
//立即开通超级会员
- (IBAction)openSuperHuiYuan:(id)sender {
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
    NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", [self.chaojiPrice floatValue]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", [self.chaojiPrice floatValue]]];
    [attrStr setAttributes:attributeDict range:range];
    //转场动画
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.25;
    [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];
    
    self.zhiFuSelectView.moneyLabel.attributedText = attrStr;
    [[DZTools getAppWindow] addSubview:self.zhiFuSelectView];
}
//立即充值
- (IBAction)lijichongzhiBtnClicked:(id)sender {
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
    NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", [self.chaojiPrice floatValue]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", [self.chaojiPrice floatValue]]];
    [attrStr setAttributes:attributeDict range:range];
    //转场动画
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.25;
    [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];
    
    self.zhiFuSelectView.moneyLabel.attributedText = attrStr;
    [[DZTools getAppWindow] addSubview:self.zhiFuSelectView];
    return;
    //暂时隐藏积分购买超级会员
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"请选择购买会员的方式"
                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"积分"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self jifenbuyHuiYuan:@""];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"余额或现金"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
    NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", [self.chaojiPrice floatValue]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", [self.chaojiPrice floatValue]]];
    [attrStr setAttributes:attributeDict range:range];
    
    //转场动画
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.25;
    [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];
    
    self.zhiFuSelectView.moneyLabel.attributedText = attrStr;
    [[DZTools getAppWindow] addSubview:self.zhiFuSelectView];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action){
                                            }]];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)jifenbuyHuiYuan:(NSString *)to_level {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.frame = CGRectMake(15, 64, 240, 30);
        textField.placeholder = @"请输入支付密码";
    }];
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action){

                                                      }]];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *_Nonnull action) {
    UITextField *textField = alertController.textFields.firstObject;
    if (textField.text.length == 0) {
      [DZTools showNOHud:@"支付密码不能为空" delay:2.0];
      return;
    }
    NSDictionary *dict = @{ @"pay_password": textField.text,
                          @"to_level": @"6" };
    [DZNetworkingTool postWithUrl:kCoinGetLevel
      params:dict
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([responseObject[@"code"] intValue] == SUCCESS) {
              [DZTools showOKHud:responseObject[@"msg"] delay:2];
              [self.navigationController popViewControllerAnimated:YES];
          } else {
              [DZTools showNOHud:responseObject[@"msg"] delay:2];
          }
      }
      failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
          [DZTools showNOHud:RequestServerError delay:2];
      }
      IsNeedHub:NO];
                                                      }]];
    [self presentViewController:alertController animated:true completion:nil];
}
//支付
- (void)zhifufounction:(int)type password:(NSString *)password {
    if (type == 1) { //1余额 2支付宝 3微信
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.frame = CGRectMake(15, 64, 240, 30);
            textField.placeholder = @"请输入支付密码";
            textField.secureTextEntry = YES;
        }];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action){

                                                          }]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
              UITextField *textField = alertController.textFields.firstObject;
              if (textField.text.length == 0) {
                  [DZTools showNOHud:@"支付密码不能为空" delay:2.0];
                  return;
              }
              [self payByYueWithPassword:textField.text];
          }]];
        [self presentViewController:alertController animated:true completion:nil];

    } else if (type == 2) { //2支付宝
        NSDictionary *dict = @{
                               @"money": self.chaojiPrice,
                                @"paytype": @"alipay",
                                @"order_type": @(3)
                                };
        [DZNetworkingTool postWithUrl:kSubmit
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"sign"]
                                              fromScheme:@"SanMuZhuangXiu"
                                                callback:^(NSDictionary *resultDic) {
                                                    NSLog(@"-------%@", resultDic);
                                                }];

                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];
    } else if (type == 3) {             //3微信
        if ([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
            NSDictionary *dict = @{ @"money": self.chaojiPrice,
                                    @"paytype": @"wechat",
                                    @"order_type": @(3)
                                    
                                    };
            [DZNetworkingTool postWithUrl:kSubmit
                params:dict
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];
                        NSDictionary *dict = responseObject[@"data"];
                        NSString *sign = [dict objectForKey:@"sign"];
                        NSDictionary *dic = [self stringToDict:sign];
                      
                        
                        PayReq *request = [[PayReq alloc] init];
                        
                        request.openID = dic[@"appid"];
                        request.partnerId = dic[@"partnerid"];
                        request.prepayId = dic[@"prepayid"];
                        request.nonceStr = dic[@"noncestr"];
                        request.timeStamp = [dic[@"timestamp"] intValue];
                        request.package = dic[@"package"];
                        request.sign = dic[@"sign"];
                        [WXApi sendReq:request];

                    } else {
                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    }
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
                IsNeedHub:NO];
        }
    }
}

-(NSDictionary *)stringToDict:(NSString *)string{
    if (string == nil) {
        return nil;
    }
    NSData *jsonData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}
- (void)payByYueWithPassword:(NSString *)password {
    NSDictionary *dict = @{ @"pay_password": password

    };
    [DZNetworkingTool postWithUrl:kBugSuperHuiYuan
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                NSString *mima = responseObject[@"msg"];
                if ([mima containsString:@"请先设置支付密码"]) {
                    //设置支付密码
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置支付密码，无法支付。是否现在去设置支付密码？" preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                    //跳转到设置支付密码界面
                     ChangePasswordViewController *vc = [[ChangePasswordViewController alloc]init];
                     vc.segmentTitleView.selectIndex = 1;
                     vc.phoneStr = [User getUser].mobile;
                     [self.navigationController pushViewController:vc animated:YES];
                                                                     }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *_Nonnull action){
                                                                             
                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];
                    
                    [self presentViewController:alert animated:YES completion:nil];
 
                }else{
                    
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

#pragma mark – 懒加载
- (ZhiFuSelectTypeView *)zhiFuSelectView {
    if (!_zhiFuSelectView) {
        _zhiFuSelectView = [[ZhiFuSelectTypeView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(self) weakSelf = self;
        _zhiFuSelectView.block = ^(int type) {
            //            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
            //            //定义第一个输入框；
            //            [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            //                textField.frame = CGRectMake(15, 64, 240, 30);
            //                textField.placeholder = @"请输入支付密码";
            //                textField.secureTextEntry = YES;
            //            }];
            //            //增加取消按钮；
            //            [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
            //                                                                style:UIAlertActionStyleDefault
            //                                                              handler:^(UIAlertAction *_Nonnull action){
            //
            //                                                              }]];
            //            //增加确定按钮；
            //            [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
            //                                                                style:UIAlertActionStyleDefault
            //                                                              handler:^(UIAlertAction *_Nonnull action) {
            //                                                                  UITextField *textField = alertController.textFields.firstObject;
            //                                                                  if (textField.text.length == 0) {
            //                                                                      [DZTools showNOHud:@"支付密码不能为空" delay:2.0];
            //                                                                      return;
            //                                                                  }
            [weakSelf zhifufounction:type password:nil];
            //                                                              }]];
            //            [weakSelf presentViewController:alertController animated:true completion:nil];
            [weakSelf.zhiFuSelectView removeFromSuperview];
        }; //1余额 2支付宝 3微信
    }
    return _zhiFuSelectView;
}
@end
