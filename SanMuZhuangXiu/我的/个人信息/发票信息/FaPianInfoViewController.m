//
//  FaPianInfoViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "FaPianInfoViewController.h"

@interface FaPianInfoViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *shuihaoTF;
@property (weak, nonatomic) IBOutlet UITextField *kaihuhangTF;
@property (weak, nonatomic) IBOutlet UITextField *zhanghaoTF;

@end

@implementation FaPianInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"发票信息";
    [self loadBasicData];
    
}
-(void)loadBasicData{

    [DZNetworkingTool postWithUrl:kMyInvoice params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
  
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            self.nameTF.text=[NSString stringWithFormat:@"%@",dict[@"invoice_company"]];
            self.shuihaoTF.text=[NSString stringWithFormat:@"%@",dict[@"duty_paragraph"]];
            self.kaihuhangTF.text=[NSString stringWithFormat:@"%@",dict[@"bank_name"]];
            self.zhanghaoTF.text=[NSString stringWithFormat:@"%@",dict[@"bank_code"]];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
#pragma mark-- XibFunction
//保存
- (IBAction)saveBtnClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    if (self.nameTF.text.length==0) {
        [DZTools showNOHud:@"公司名称不能为空" delay:2];
        return;
    }
    if (self.shuihaoTF.text.length==0) {
        [DZTools showNOHud:@"纳税人识别号不能为空" delay:2];
        return;
    }
    if (self.kaihuhangTF.text.length==0) {
        [DZTools showNOHud:@"开户行名称不能为空" delay:2];
        return;
    }
    if (self.zhanghaoTF.text.length==0) {
        [DZTools showNOHud:@"开户行帐号不能为空" delay:2];
        return;
    }
    

    NSDictionary *dict=@{
                         @"invoice_company":self.nameTF.text,
                         @"duty_paragraph":self.shuihaoTF.text,
                         @"bank_name":self.kaihuhangTF.text,
                         @"bank_code":self.zhanghaoTF.text
                         };
    [DZNetworkingTool postWithUrl:kEditInvoice params:dict success:^(NSURLSessionDataTask *task, id responseObject) {

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
