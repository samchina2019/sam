//
//  RenCaiFuWuViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/10.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "RenCaiFuWuViewController.h"
#import "SDCycleScrollView.h"
#import "QiyeZhaopinViewController.h"
#import "FindWorkerViewController.h"
#import "WebViewViewController.h"
#import "StoreDetailViewController.h"
@interface RenCaiFuWuViewController () <SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *lunboView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel1;
@property (weak, nonatomic) IBOutlet UILabel *numLabel2;
@property (weak, nonatomic) IBOutlet UILabel *numLabel3;
@property (weak, nonatomic) IBOutlet UILabel *numLabel4;

@property (nonatomic, strong) NSArray *lunboArray;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation RenCaiFuWuViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DZTools islogin]) {
        [self loadData];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"人才服务";
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth / 375.0 * 225) imageNamesGroup:@[@"home_pic_banner1", @"home_pic_banner2", @"home_pic_banner3"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    self.lunboArray = [NSArray array];
    [self.lunboView addSubview:self.cycleScrollView];
}
#pragma mark – Network

- (void)loadData {
    [DZNetworkingTool postWithUrl:kRencaiIndex
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.lunboArray = responseObject[@"data"];
                NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
                NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:0];

                for (NSDictionary *bannerDic in self.lunboArray) {
                    [imgArray addObject:bannerDic[@"image"]];
                    [titleArray addObject:bannerDic[@"title"]];
                }
                self.cycleScrollView.imageURLStringsGroup = imgArray;
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

        }
        IsNeedHub:NO];
}
#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSDictionary *dict = self.lunboArray[index];
    if ([dict[@"to_type"] integerValue] == 1) {
        self.hidesBottomBarWhenPushed = YES;
        WebViewViewController *viewController = [[WebViewViewController alloc] init];
        viewController.urlStr = dict[@"to_url"];
        viewController.titleStr = dict[@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if ([dict[@"to_type"] integerValue] == 2) {
        self.hidesBottomBarWhenPushed = YES;
        StoreDetailViewController *viewController = [[StoreDetailViewController alloc] init];
        viewController.seller_id = [dict[@"to_url"] integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
}
#pragma mark - XibFunction
//工地找工人
- (IBAction)gongdizhaogongren:(id)sender {
    self.numLabel1.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    FindWorkerViewController *findWorkViewController = [[FindWorkerViewController alloc] init];
    findWorkViewController.selectIndex = 0;
    [self.navigationController pushViewController:findWorkViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//工地找工作
- (IBAction)gongdizhaogongzhu:(id)sender {
    self.numLabel2.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    FindWorkerViewController *findWorkViewController = [[FindWorkerViewController alloc] init];
    findWorkViewController.selectIndex = 1;
    [self.navigationController pushViewController:findWorkViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//企业招聘
- (IBAction)qiyezhaopin:(id)sender {
    self.numLabel3.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    QiyeZhaopinViewController *qiyeViewController = [[QiyeZhaopinViewController alloc] init];
    qiyeViewController.selectIndex = 0;
    [self.navigationController pushViewController:qiyeViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//员工求职
- (IBAction)yuangongqiuzhi:(id)sender {
    self.numLabel4.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    QiyeZhaopinViewController *qiyeViewController = [[QiyeZhaopinViewController alloc] init];
    qiyeViewController.selectIndex = 1;
    [self.navigationController pushViewController:qiyeViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}



@end
