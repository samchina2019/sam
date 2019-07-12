//
//  MyQiaoBaoViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/27.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyQiaoBaoViewController.h"
#import "MyWalletViewController.h"
#import "TiXianViewController.h"
#import "TransactionRecordViewController.h"
#import "BangDingZhangHuViewController.h"

@interface MyQiaoBaoViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;


@end

@implementation MyQiaoBaoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = @"我的钱包";
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

}
- (void)viewWillDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//
//    if (@available(iOS 11.0, *)) {
//        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets =NO;
//    }
//
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
    
    self.yueLabel.text=[NSString stringWithFormat:@"%@",self.money];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"交易明细" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x101010) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
  
    
}

#pragma mark - Function
- (void)rightBarButtonItemClicked
{
    TransactionRecordViewController *viewController = [TransactionRecordViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - XibFunction
//充值
- (IBAction)chongzhiBtnClicked:(id)sender {
    MyWalletViewController *viewController = [MyWalletViewController new];
    viewController.money=self.yueLabel.text;
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//提现
- (IBAction)tixianBtnClicked:(id)sender {
    TiXianViewController *viewController = [TiXianViewController new];
    viewController.money=[self.yueLabel.text floatValue];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//支付宝绑定
- (IBAction)zhifubaobangdingBtnClicked:(id)sender {
    [self.view endEditing:YES];
    BangDingZhangHuViewController *viewController = [BangDingZhangHuViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
//微信绑定
- (IBAction)weixinbangdingBtnClicked:(id)sender {
    [self.view endEditing:YES];
    BangDingZhangHuViewController *viewController = [BangDingZhangHuViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
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
