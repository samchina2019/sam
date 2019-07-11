//
//  JiFenGoodsDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiFenGoodsDetailViewController.h"
#import "PPNumberButton.h"
#import "JiFenOrderDetailViewController.h"
#import "ChangePasswordViewController.h"
#import "SDCycleScrollView.h"
#import "AddressManagerViewController.h"
#import "AddressModel.h"
#import "ReLayoutButton.h"
#import "ZhiFuSelectTypeView.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface JiFenGoodsDetailViewController () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutContentheigth;
@property (weak, nonatomic) IBOutlet UILabel *jifenNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *shichangPriceLabel;
@property (weak, nonatomic) IBOutlet PPNumberButton *ppnumberBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressBtn;

@property (strong, nonatomic) ZhiFuSelectTypeView *zhiFuSelectView;

@property (nonatomic, strong) NSString *order_no;
@property (nonatomic, assign) int addressId;

@end

@implementation JiFenGoodsDetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = [NSString stringWithFormat:@"%@", self.title];
    [self loadData];
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth) delegate:self placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    self.cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [SDCycleScrollView clearImagesCache]; // 清除缓存。
    [self.imageBgView addSubview:self.cycleScrollView];

    CGSize size = [DZTools sizeForString:@"道道工序精心调配，只为追求纯正口感。餐间零嘴，小饿小馋，补充能量。办公乐享，一口一个，甜而不腻。午后甜点，搭配咖啡，妙享美味。" withSize:CGSizeMake(ViewWidth - 30, 1000) withFontSize:14];
    self.layOutContentheigth.constant = size.height + 50;

    self.layOutheigth.constant = self.layOutContentheigth.constant + ViewWidth + 195 + 10;

    self.ppnumberBtn.currentNumber = 1;
    self.ppnumberBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {

    };
}

#pragma mark – Network

- (void)loadData {

    NSDictionary *dict = @{
                           @"goods_id": @(self.goodsId),
                           };
    [DZNetworkingTool postWithUrl:kGoodsDetails
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  NSArray *array = dict[@"images"];
                                  self.cycleScrollView.imageURLStringsGroup = array;
                                  CGSize size = [DZTools sizeForString:dict[@"goods_introduce"] withSize:CGSizeMake(ViewWidth - 30, 1000) withFontSize:14];
                                  self.layOutContentheigth.constant = size.height + 50;
                                  
                                  self.layOutheigth.constant = self.layOutContentheigth.constant + ViewWidth + 195 + 10;
                                  self.contentLabel.text = [NSString stringWithFormat:@"%@", dict[@"goods_introduce"]];
                                  
                                  self.jifenNumLabel.text = [NSString stringWithFormat:@"%@", dict[@"goods_score"]];
                                  self.moneyNumLabel.text = [NSString stringWithFormat:@"+¥%@", dict[@"goods_price"]];
                                  self.shichangPriceLabel.text = [NSString stringWithFormat:@"%@", dict[@"line_price"]];
                                  
                                  NSArray *imageStr = dict[@"contentimages"];
                                  if ([imageStr[0] containsString:@"http"]) {
                                      
                                      NSString *imgStr = @"";
                                      for (int i = 0; i < imageStr.count; i++) {
                                          imgStr = [NSString stringWithFormat:@"%@<img src=\"%@\" width=\"100%%\">", imgStr, imageStr[i]];
                                      }
                                      NSString *content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title></title></head><body><div>%@</div></body></html>", imgStr];
                                      
                                      [self.webView loadHTMLString:content baseURL:nil];
                                      
                                  } else {
                                      
                                      NSString *imgStr = @"";
                                      for (int i = 0; i < imageStr.count; i++) {
                                          imgStr = [NSString stringWithFormat:@"%@<img src=\"%@%@\" width=\"100%%\">", imgStr, kIMageUrl, imageStr[i]];
                                      }
                                      NSString *content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title></title></head><body><div>%@</div></body></html>", imgStr];
                                      
                                      [self.webView loadHTMLString:content baseURL:nil];
                                  }
                                  
                                  [self.view layoutIfNeeded];
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

- (void)payBtnCLickWithPay_price:(float)pay_price order_no:(NSString *)order_no {
    self.order_no = order_no;
    if (pay_price == 0) {//积分支付
        [self zhifufounction:4];
    } else {
        
        NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
        NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", pay_price];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
        NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", pay_price]];
        [attrStr setAttributes:attributeDict range:range];
        
        //转场动画
        CATransition *animation = [CATransition animation];
        animation.type = kCATransitionMoveIn;
        animation.subtype = kCATransitionFromTop;
        animation.duration = 0.25;
        [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];
        
        self.zhiFuSelectView.moneyLabel.attributedText = attrStr;
        [[DZTools getAppWindow]  addSubview:self.zhiFuSelectView];
    }
}
-(void)payByYueWithPassword:(NSString *)password{
    NSDictionary *params = @{
                             @"type": @"money",
                             @"order_no": self.order_no,
                             @"pay_password":password
                             };
    [DZNetworkingTool postWithUrl:kJiFenPay
                           params:params
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
                                                                                               [self.navigationController popViewControllerAnimated:YES];
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
-(void)zhifufounction:(int)type withPassword:(NSString *)password{
     [self.zhiFuSelectView removeFromSuperview];
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
                                                              [textField resignFirstResponder];
                                                              
                                                              [self payByYueWithPassword:textField.text];
                                                              
                                                          }]];
        [self  presentViewController:alertController animated:true completion:nil];
    }else if (type == 2) {
        NSDictionary *params = @{
                                 @"type": @"ailpay",
                                 @"order_no": self.order_no,
//                                 @"pay_password":password
                                 };
        
        [DZNetworkingTool postWithUrl:kJiFenPay
                               params:params
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
          [self.navigationController popViewControllerAnimated:YES];
          [DZTools showOKHud:responseObject[@"msg"] delay:2];
          [[AlipaySDK defaultService] payOrder:responseObject[@"data"]
                                    fromScheme:@"SanMuZhuangXiu"
                                      callback:^(NSDictionary *resultDic) {
                                          NSLog(@"-------%@", resultDic);
                                      }];
              } else {
                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
              }
          }
           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
               [DZTools showNOHud:RequestServerError delay:2.0];
           }
        IsNeedHub:NO];
    }else if (type == 3){
        NSDictionary *dict = @{
                               @"type": @"wechat",
                               @"order_no": self.order_no,
//                               @"pay_password":password
                               };
        [DZNetworkingTool postWithUrl:kJiFenPay
                               params:dict
                              success:^(NSURLSessionDataTask *task, id responseObject) {
              if ([responseObject[@"code"] intValue] == SUCCESS) {
                  [self.navigationController popViewControllerAnimated:YES];
                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                  NSDictionary *dict = responseObject[@"data"];
                  PayReq *request = [[PayReq alloc] init];
                  request.openID = dict[@"appid"];
                  request.partnerId = dict[@"partnerid"];
                  request.prepayId = dict[@"prepayid"];
                  request.nonceStr = dict[@"noncestr"];
                  request.timeStamp = [dict[@"timestamp"] intValue];
                  request.package = dict[@"package"];
                  request.sign = dict[@"sign"];
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
//支付
- (void)zhifufounction:(int)type {

     if (type == 4) {
        NSDictionary *params = @{@"order_no": self.order_no
                                 };
        
        [DZNetworkingTool postWithUrl:kJiFenPay
                               params:params
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
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
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 获取webView的高度
    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    
    
    self.layOutheigth.constant = self.layOutContentheigth.constant + ViewWidth + 230+ webViewHeight;
}
#pragma mark - XibFunction
//选择收获地址
- (IBAction)selectAddressBtnClicked:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
    vc.block = ^(AddressModel *_Nonnull model) {

        
        
        self.addressLabel.text=@"";
        [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail] forState:UIControlStateNormal];
        self.addressId = model.address_id;

    };
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//立即兑换
- (IBAction)querenshouhuoBtnClicked:(id)sender {
    if (self.addressId==0) {
        [DZTools showNOHud:@"地址不能为空" delay:2];
        return;
    }
    //    kExchange

    NSDictionary *dict = @{
        @"goods_id": @(self.goodsId),
        @"goods_num": @(self.ppnumberBtn.currentNumber),
        @"addres_id": @(self.addressId)
    };
    [DZNetworkingTool postWithUrl:kExchange
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"%@", responseObject[@"msg"]] message:@"请确认支付" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"确认支付"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
                [self payBtnCLickWithPay_price:[dict[@"pay_price"] floatValue] order_no:[NSString stringWithFormat:@"%@", dict[@"order_no"]]];
                                                         }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"返回"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
                 [self.navigationController popViewControllerAnimated:YES];
                                                         }]];
                //弹出提示框；
                [self presentViewController:alertC animated:true completion:nil];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];

    //    NSLog(@"点击了。。。。");
    //    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"兑换成功" message:@"您已消费 59积分" preferredStyle:UIAlertControllerStyleAlert];
    //    [alertC addAction:[UIAlertAction actionWithTitle:@"查看订单" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        self.hidesBottomBarWhenPushed = YES;
    //        JiFenOrderDetailViewController *viewController = [JiFenOrderDetailViewController new];
    //        [self.navigationController pushViewController:viewController animated:YES];
    //        self.hidesBottomBarWhenPushed = YES;
    //    }]];
    //    [alertC addAction:[UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        [self.navigationController popViewControllerAnimated:YES];
    //    }]];
    //    //弹出提示框；
    //    [self presentViewController:alertC animated:true completion:nil];
}


#pragma mark – 懒加载
- (ZhiFuSelectTypeView *)zhiFuSelectView {
    if (!_zhiFuSelectView) {
        _zhiFuSelectView = [[ZhiFuSelectTypeView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(self) weakSelf = self;
        _zhiFuSelectView.block = ^(int type) {
            
            [weakSelf zhifufounction:type withPassword:nil];
        }; //1余额 2支付宝 3微信
    }
    return _zhiFuSelectView;
}

@end
