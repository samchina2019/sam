//
//  GongZhangRenZhengViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "GongZhangRenZhengViewController.h"
#import "UITextView+ZWPlaceHolder.h"

@interface GongZhangRenZhengViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextView *addressTV;
///提交button
@property (weak, nonatomic) IBOutlet UIButton *tijaioButton;

@end

@implementation GongZhangRenZhengViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"工长认证";
    self.tijaioButton.userInteractionEnabled = YES;
    
    self.addressTV.layer.cornerRadius = 8;
    self.addressTV.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    self.addressTV.layer.borderWidth = 1;
    
     [self loadBasicData];
}
-(void)loadBasicData{
    [DZNetworkingTool postWithUrl:kMyForemanAuth params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            if ([dict[@"is_auth_foreman"] isEqualToString:@"0"]) {
                [DZTools showNOHud:@"您暂时没有申请，请填写工长信息" delay:2];
            }else if ([dict[@"is_auth_foreman"] isEqualToString:@"1"]){
                [DZTools showNOHud:@"认证申请中，请耐心等待" delay:2];
                self.tijaioButton.userInteractionEnabled = NO;
                NSDictionary *temp=dict[@"auth_info"];
                self.nameTF.text=[NSString stringWithFormat:@"%@",temp[@"engineering_name"]];
                self.phoneTF.text=[NSString stringWithFormat:@"%@",temp[@"phone"]];
                self.addressTV.text=[NSString stringWithFormat:@"%@",temp[@"address"]];
            }else{
                 self.tijaioButton.userInteractionEnabled = NO;
                NSDictionary *temp=dict[@"auth_info"];
                self.nameTF.text=[NSString stringWithFormat:@"%@",temp[@"engineering_name"]];
                self.phoneTF.text=[NSString stringWithFormat:@"%@",temp[@"phone"]];
                self.addressTV.text=[NSString stringWithFormat:@"%@",temp[@"address"]];
                
            }
            
        }else
        {
//            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
#pragma mark-- XibFunction
//提交
- (IBAction)commitBtnClicked:(id)sender {
    [self.view endEditing:YES];
    if (self.nameTF.text.length == 0) {
        [DZTools showNOHud:@"工长名不能为空" delay:2];
        return;
    }
    if (self.addressTV.text.length == 0) {
        [DZTools showNOHud:@"工地地址不能为空" delay:2];
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
    
    NSDictionary *dict=@{
                         @"engineering_name":self.nameTF.text,
                         @"phone":self.phoneTF.text,
                         @"address":self.addressTV.text,
                         @"describe":@""
                         };
    [DZNetworkingTool postWithUrl:kAddForemanAuth params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            //返回到指定的控制器，要保证前面有入栈。
            int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
            if (index>4) {
                [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-4)] animated:YES];
            }else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
    
}
//取消编辑
- (IBAction)endEdit:(id)sender {
    [self.view endEditing:YES];
}

@end
