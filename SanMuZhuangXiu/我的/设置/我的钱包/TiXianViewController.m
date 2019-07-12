//
//  TiXianViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/26.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "TiXianViewController.h"
#import "TiXianJinDuViewController.h"
#import "BangDingZhangHuViewController.h"

@interface TiXianViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *moneyTF;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (weak, nonatomic) IBOutlet UILabel *moneyNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *bangdingBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifuaboBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (strong, nonatomic) IBOutlet UIView *tixianBgView;
@property (weak, nonatomic) IBOutlet UILabel *tixianTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *zhanghuBtn;

@property (nonatomic, strong) NSString *alipay;
@property (nonatomic, strong) NSString *weixin;

@property (nonatomic, assign) float cashMoney;

@end

@implementation TiXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"提现";

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;

    _bangdingBtn.layer.cornerRadius = 5;
    _bangdingBtn.layer.borderColor = TabbarColor.CGColor;
    _bangdingBtn.layer.borderWidth = 1;
    [self loadData];
}
- (void)loadData {
    //
    [DZNetworkingTool postWithUrl:kAccountInfo
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.alipay = dict[@"alipay"];
                self.weixin = dict[@"weixin"];
                self.cashMoney = [dict[@"can_cash_money"] floatValue];
                self.moneyNumLabel.text = [NSString stringWithFormat:@"%@", dict[@"can_cash_money"]];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:nil];
}
#pragma mark-- xibFunction
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}
//选中提现方式
- (IBAction)selectChongzhiType:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = YES;
    if (sender.tag == 1) {
        _weixinBtn.selected = NO;
    } else {
        _zhifuaboBtn.selected = NO;
    }
}
//绑定账户
- (IBAction)bangdingzhanghuBtnClicked:(id)sender {
    [self.view endEditing:YES];
    BangDingZhangHuViewController *viewController = [BangDingZhangHuViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//申请提现
- (IBAction)shengqingTiXianBtnClicked:(id)sender {
    [self.view endEditing:YES];
    self.tixianTitleLabel.text = [NSString stringWithFormat:@"即将提现¥%@元至%@账户", self.moneyTF.text, _zhifuaboBtn.selected ? @"支付宝" : @"微信"];

    [self.zhanghuBtn setTitle:[NSString stringWithFormat:@"%@", _zhifuaboBtn.selected ? self.alipay : self.weixin] forState:UIControlStateNormal];
    [self.zhanghuBtn setImage:[UIImage imageNamed:_zhifuaboBtn.selected ? @"icon_zhifubao" : @"icon_weixin"] forState:UIControlStateNormal];
    self.tixianBgView.frame = [DZTools getAppWindow].bounds;
    [[DZTools getAppWindow] addSubview:self.tixianBgView];
}
- (IBAction)hiddentixianBgView:(id)sender {
    [self.tixianBgView removeFromSuperview];
}
//确定提现
- (IBAction)querentixian:(id)sender {
    [self.tixianBgView removeFromSuperview];

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入提现密码" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.frame = CGRectMake(15, 64, 240, 30);
        textField.placeholder = @"请输入提现密码";
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
                  [DZTools showNOHud:@"提现密码不能为空" delay:2.0];
                  return;
              }
                                                          
              NSDictionary *dict = @{
                  @"money": self.moneyTF.text,
                  @"pay_password": textField.text,
                  @"cash_type": self.zhifuaboBtn.selected ? @"1" : @"2"
              };
              [DZNetworkingTool postWithUrl:kAddCash
                  params:dict
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if ([responseObject[@"code"] intValue] == SUCCESS) {
                          [DZTools showOKHud:responseObject[@"msg"] delay:2];

                          TiXianJinDuViewController *viewController = [TiXianJinDuViewController new];
                          self.hidesBottomBarWhenPushed = YES;
                          [self.navigationController pushViewController:viewController animated:YES];

                      } else {
                          [DZTools showNOHud:responseObject[@"msg"] delay:2];
                      }
                  }
                  failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                      [DZTools showNOHud:responseObject[@"msg"] delay:2];
                  }
                  IsNeedHub:nil];
          }]];
    [self presentViewController:alertController animated:true completion:nil];
}



@end
