//
//  MyWalletViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/25.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MyWalletViewController.h"
#import "TiXianViewController.h"
#import "TransactionRecordViewController.h"

#import "APOrderInfo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"



@interface MyWalletViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *quxianBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifuaboBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
//支付方式
@property(nonatomic,strong)NSString *payType;

@end

@implementation MyWalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"充值";
    self.payType=@"alipay";
    
    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
    
    _quxianBtn.layer.cornerRadius = 5;
    _quxianBtn.layer.borderColor = TabbarColor.CGColor;
    _quxianBtn.layer.borderWidth = 1;
    self.moneyNumLabel.text=[NSString stringWithFormat:@"%@",self.money];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
//    [button setTitle:@"交易记录" forState:UIControlStateNormal];
//    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
}

#pragma mark-- function
- (void)rightBarButtonItemClicked
{
    TransactionRecordViewController *viewController = [TransactionRecordViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
///支付宝支付
-(void)payByZhifubao{
    NSDictionary *dict=@{
                         @"money":self.moneyTF.text,
                         @"paytype":self.payType,
                         @"order_type":@(1)
                         };
    [DZNetworkingTool postWithUrl:kSubmit params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            [self.navigationController popViewControllerAnimated:YES];
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [[AlipaySDK defaultService] payOrder:responseObject[@"data"][@"sign"] fromScheme:@"SanMuZhuangXiu" callback:^(NSDictionary* resultDic) {
                NSLog(@"-------%@",resultDic);
            }];
            
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
}
///微信支付
-(void)payByWeixin{
    if([WXApi isWXAppInstalled]){ // 判断 用户是否安装微信
        NSDictionary *dict=@{
                             @"money":self.moneyTF.text,
                             @"paytype":self.payType,
                             @"order_type":@(1)
                             };
        [DZNetworkingTool postWithUrl:kSubmit params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue]==SUCCESS) {
                [self.navigationController popViewControllerAnimated:YES];
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                NSDictionary *dict = responseObject[@"data"];
                NSString *sign = dict[@"sign"];
                ///字符串转为字典
                NSDictionary *dic = [self stringToDictionaryWithString:sign];
                ///微信支付参数设置
                PayReq *request = [[PayReq alloc] init];
                request.openID = dic[@"appid"];
                request.partnerId = dic[@"partnerid"];
                request.prepayId = dic[@"prepayid"];
                request.nonceStr = dic[@"noncestr"];
                request.timeStamp = [dic[@"timestamp"] intValue];
                request.package = dic[@"package"];
                request.sign = dic[@"sign"];
                [WXApi sendReq:request];
                
            }else{
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        } IsNeedHub:NO];
        
    }
}
- (NSDictionary *)stringToDictionaryWithString:(NSString *)string {
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *dict = nil;
    
    if (!data) return nil;
    
    dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    if (![dict isKindOfClass:[NSDictionary class]]) return nil;
    
    return dict;
}
#pragma mark-- xibFunction
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
- (IBAction)selectChongzhiType:(UIButton *)sender {
    sender.selected = YES;
    if (sender.tag == 1) {
        _weixinBtn.selected = NO;
        self.payType=@"alipay";
        
    }else{
        _zhifuaboBtn.selected = NO;
        self.payType=@"wechat";
    }
}
- (IBAction)tixianBtnClicked:(id)sender {

    TiXianViewController *viewController = [TiXianViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (IBAction)lijichongzhiBtnClicked:(id)sender {
    if (self.zhifuaboBtn.selected) {
        [self payByZhifubao];
    }else if(self.weixinBtn.selected){
        [self payByWeixin];
    }

}



@end
