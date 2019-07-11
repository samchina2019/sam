//
//  ReverseViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "ReverseViewController.h"

@interface ReverseViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation ReverseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"身份证信息";
    
    
    self.resetBtn.layer.borderWidth = 1;
    self.resetBtn.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
    
    self.nameLabel.text = self.IDInfo.name;
    self.sexLabel.text = self.IDInfo.gender;
    self.idCardNumLabel.text = self.IDInfo.num;
    self.timeLabel.text = self.IDInfo.valid;
}
#pragma mark - XibFunction

- (IBAction)finishBtnClicked:(id)sender {
//    kAddAuth
    NSString *dateOpen=self.IDInfo.valid;
    NSArray *array = [dateOpen componentsSeparatedByString:@"-"]; //从字符A中分隔成2个元素的数组
    NSLog(@"array:%@",array); //结果是adfsfsfs和dfsdf
    NSString *date_open=array[0];
    NSString *date_end=array[1];
    NSString *sex=@"";
    if ([self.IDInfo.gender isEqualToString:@"男"] ) {
        sex=@"1";
    }else{
         sex=@"0";
    }
    NSDictionary *dict=@{
                         @"true_name":self.IDInfo.name,
                         @"date_open":date_open,
                         @"date_end":date_end,
                         @"card_code":self.IDInfo.num,
                         @"sex":sex
                         };
    [DZNetworkingTool postWithUrl:kAddAuth params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        
       
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            
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
- (IBAction)resetBtnClicked:(id)sender {
    //返回到指定的控制器，要保证前面有入栈。
    int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
    if (index>3) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index-3)] animated:YES];
    }else
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}


@end
