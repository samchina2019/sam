//
//  RegisterSuccessViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/24.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "RegisterSuccessViewController.h"
#import "LoginViewController.h"
@interface RegisterSuccessViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@end

@implementation RegisterSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"注册成功";

    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
}
- (IBAction)backItemClicked:(id)sender
{
    //返回到登录界面
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginViewController class]])
        {
             [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
- (void)backItemClicked{
    //返回到登录界面
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[LoginViewController class]])
        {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}
#pragma mark -- xib Action
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
