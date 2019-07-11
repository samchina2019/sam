//
//  QuYuDaiLiViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QuYuDaiLiViewController.h"
#import "ApplyDelegateViewController.h"

@interface QuYuDaiLiViewController ()

@end

@implementation QuYuDaiLiViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor whiteColor];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"区域代理";
//kArticleInfo
//    self.webView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight - 80);
//    //            self.webView.backgroundColor=[UIColor whiteColor];
//    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?keywords=agent",kArticleInfo]];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [self.webView loadRequest:request];
}
-(void)loadData{
    //
    NSDictionary *dict=@{
                         @"keywords":@"agent"
                         };
    [DZNetworkingTool postWithUrl:kArticleInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *temp=responseObject[@"data"];
            self.webView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight - 64-NavAndStatusHight);
            NSURL *url = [NSURL URLWithString:temp[@"url"]];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            [self.webView loadRequest:request];
            [DZTools hideHud];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:YES];
    
    
    
}
#pragma mark - XibFunction
- (IBAction)applyBtnClicked:(id)sender {
    ApplyDelegateViewController *viewController = [ApplyDelegateViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}


@end
