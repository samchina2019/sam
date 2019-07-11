//
//  ChatViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ChatViewController.h"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"diandiandian"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClicked)];
    
    UIImage *image1 = [UIImage imageNamed:@"back"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:image1 style:UIBarButtonItemStyleDone target:self action:@selector(backBarButtonItemClicked)];
    
    [self.chatSessionInputBarControl.pluginBoardView removeItemWithTag:1003];
}
- (void)rightBarButtonItemClicked
{
    if (self.isShouhou) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"对此订单有疑问，确定进行申诉吗？" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDestructive
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self shensuOrderWithContent:@"订单有问题"];
                                                         }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                                 
                                                             }];
        [alert addAction:cancelAction];
        [alert addAction:okAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
    }
    
}
-(void)shensuOrderWithContent:(NSString *)string{
    NSDictionary *dict = @{
                           @"content":string,
                           @"type":@(4),
                           @"data":@(self.orderId)
                           };
    [DZNetworkingTool postWithUrl:kAddAppeal params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [self.navigationController  popViewControllerAnimated:YES];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
- (void)backBarButtonItemClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
