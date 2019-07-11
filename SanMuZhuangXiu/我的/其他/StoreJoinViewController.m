//
//  StoreJoinViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreJoinViewController.h"
#import "SGQRCodeGenerateManager.h"

@interface StoreJoinViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *erweimaImgV;

@end

@implementation StoreJoinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"商家入驻";
    [self loadData];
}
-(void)loadData{
    [DZNetworkingTool postWithUrl:kStoreQCode params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSString *urlStr = responseObject[@"data"][@"img_url"];
            if (![urlStr containsString:@"http"]) {
                urlStr = [NSString stringWithFormat:@"%@%@",kIMageUrl,urlStr];
                
            }
            //自定生成二维码
            UIImage *image=[SGQRCodeGenerateManager generateWithDefaultQRCodeData:urlStr imageViewWidth:self.erweimaImgV.bounds.size.width];
            self.erweimaImgV.image=image;
            
            [DZTools hideHud];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
        [self.navigationController popViewControllerAnimated:YES];
    } IsNeedHub:YES];
}


@end
