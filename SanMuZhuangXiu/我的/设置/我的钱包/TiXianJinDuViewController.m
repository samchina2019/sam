//
//  TiXianJinDuViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "TiXianJinDuViewController.h"

@interface TiXianJinDuViewController ()

@property (weak, nonatomic) IBOutlet UILabel *status1Label;
@property (weak, nonatomic) IBOutlet UILabel *status2Label;
@property (weak, nonatomic) IBOutlet UILabel *status3Label;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhanghuLabel;

@end

@implementation TiXianJinDuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"进度";
    [self loadData];
}
//查看提现状态
-(void)loadData{
    [DZNetworkingTool postWithUrl:kNearRecharge params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            self.moneyLabel.text=[NSString stringWithFormat:@"¥%@",dict[@"amount"]];
            if ([dict[@"cash_type"] isEqualToString:@"1"] ) {
                self.zhanghuLabel.text=[NSString stringWithFormat:@"%@%@",@"支付宝",dict[@"cash_account"]];
            }else if ([dict[@"cash_type"] isEqualToString:@"2"]){
                 self.zhanghuLabel.text=[NSString stringWithFormat:@"%@%@",@"微信",dict[@"cash_account"]];
            }
          
            
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
}

#pragma mark - XibFunction

- (IBAction)quedingBtnClicked:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}



@end
