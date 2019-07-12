//
//  BangDingZhangHuViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "BangDingZhangHuViewController.h"

@interface BangDingZhangHuViewController ()

@property (weak, nonatomic) IBOutlet UITextField *weixinTF;
@property (weak, nonatomic) IBOutlet UITextField *zhifubaoTF;

@end

@implementation BangDingZhangHuViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//当支付宝，微信已经 绑定的时候
    [self loadData];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"绑定";
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"保存" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
}
- (void)loadData {
    [DZNetworkingTool postWithUrl:kAccountInfo
                           params:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  
                                  self.zhifubaoTF.text = dict[@"alipay"];
                                  self.weixinTF.text = dict[@"weixin"];
                                  
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:responseObject[@"msg"] delay:2];
                           }
                        IsNeedHub:nil];
}
#pragma mark -- Function
//保存
- (void)rightBarButtonItemClicked
{
    [self.view endEditing:YES];
//
    if (self.weixinTF.text.length==0||self.zhifubaoTF.text.length==0) {
        [DZTools showNOHud:@"微信或者支付宝账号不能为空" delay:2];
        return;
    }

    NSDictionary *dict=@{
                         @"weixin":self.weixinTF.text,
                         @"alipay":self.zhifubaoTF.text
                         };
    [DZNetworkingTool postWithUrl:kSetAliWechat params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            
            self.tabBarController.selectedIndex = 4;
            [self.navigationController popToRootViewControllerAnimated:YES];

        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:nil];
    
    
}
#pragma mark -- xibFunction
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}


@end
