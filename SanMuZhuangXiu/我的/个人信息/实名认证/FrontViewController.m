//
//  FrontViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "FrontViewController.h"
#import "JYBDIDCardVC.h"
#import "ReverseViewController.h"

@interface FrontViewController ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
@property (weak, nonatomic) IBOutlet UILabel *idCardNumLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;

@end

@implementation FrontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"身份证信息";
    
    
    self.resetBtn.layer.borderWidth = 1;
    self.resetBtn.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
    
    self.nameLabel.text = self.IDInfo.name;
    self.sexLabel.text = self.IDInfo.gender;
    self.idCardNumLabel.text = self.IDInfo.num;
}
#pragma mark - XibFunction

- (IBAction)nextBtnClicked:(id)sender {
    JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
    AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image)
    {
        if (info.name != nil || info.num != nil) {
            [DZTools showText:@"请拍摄国徽面" delay:2];
        }else{
            self.IDInfo.valid = info.valid;
            ReverseViewController *viewController = [[ReverseViewController alloc]init];
            viewController.IDInfo = self.IDInfo;
            [DZTools topViewController].hidesBottomBarWhenPushed = YES;
            [[DZTools topViewController].navigationController pushViewController:viewController animated:YES];
        }
    };
    [self.navigationController pushViewController:AVCaptureVC animated:YES];
}
- (IBAction)resetBtnClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
