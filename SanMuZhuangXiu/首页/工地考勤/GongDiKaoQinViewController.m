//
//  GongDiKaoQinViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/10.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GongDiKaoQinViewController.h"
#import "JianQunDaKaViewController.h"
#import "SDCycleScrollView.h"
#import "DakaViewController.h"
#import "QunGuanliViewController.h"
#import "WodeKaoqinViewController.h"
#import "WebViewViewController.h"
#import "StoreDetailViewController.h"

@interface GongDiKaoQinViewController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (weak, nonatomic) IBOutlet UILabel *numLabel1;
@property (weak, nonatomic) IBOutlet UILabel *numLabel2;
@property (weak, nonatomic) IBOutlet UILabel *numLabel3;
@property (weak, nonatomic) IBOutlet UILabel *numLabel4;
@property (weak, nonatomic) IBOutlet UIView *lunBoView;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (nonatomic, strong) NSArray *lunboArray;

@end

@implementation GongDiKaoQinViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DZTools islogin]) {
        [self getDataFromServer];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"工地考勤";
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth/375.0*225) imageNamesGroup: @[@"home_pic_banner1",@"home_pic_banner2",@"home_pic_banner3"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    
    [self.lunBoView addSubview:self.cycleScrollView];
    
    if (@available(iOS 11.0, *))
    {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets =NO;
    }
    //scrollview的contentView高度
    if (ViewHeight + 1 - NavAndStatusHight > 730) {
        _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
    }else{
        self.layOutheigth.constant = 730;
    }
    
    self.numLabel1.hidden = YES;
    self.numLabel2.hidden = YES;
    self.numLabel3.hidden = YES;
    self.numLabel4.hidden = YES;
}
#pragma mark – Network

- (void)getDataFromServer
{
    [DZNetworkingTool postWithUrl:kGongDiKaoQinHome params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:0];
            self.lunboArray = dict[@"list"];
            for (NSDictionary *bannerDic in self.lunboArray) {
                [imgArray addObject:bannerDic[@"image"]];
                [titleArray addObject:bannerDic[@"title"]];
            }
            self.cycleScrollView.imageURLStringsGroup = imgArray;
            //            self.cycleScrollView.titlesGroup = titleArray;
            
            if ([dict[@"admin_news"] intValue] == 0) {
                self.numLabel2.hidden = YES;
            }else{
                self.numLabel2.hidden = NO;
                self.numLabel2.text = [NSString stringWithFormat:@"%@",dict[@"admin_news"]];
            }
            if ([dict[@"work_rews"] intValue] == 0) {
                self.numLabel4.hidden = YES;
            }else{
                self.numLabel4.hidden = NO;
                self.numLabel4.text = [NSString stringWithFormat:@"%@",dict[@"work_rews"]];
            }
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    } IsNeedHub:NO];
}
#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dict = self.lunboArray[index];
    if ([dict[@"to_url"] integerValue] == 1) {
        self.hidesBottomBarWhenPushed = YES;
        WebViewViewController *viewController=[[WebViewViewController alloc]init];
        viewController.urlStr = dict[@"to_url"];
        viewController.titleStr = dict[@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"to_url"] integerValue] == 2) {
        self.hidesBottomBarWhenPushed = YES;
        StoreDetailViewController *viewController=[[StoreDetailViewController alloc]init];
        viewController.seller_id = [dict[@"to_url"] integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}
#pragma mark - XibFunction
//建群
- (IBAction)jianqun:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.numLabel1.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    JianQunDaKaViewController *viewController = [JianQunDaKaViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}
//群管理
- (IBAction)qunguanli:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    
    self.numLabel2.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    QunGuanliViewController *viewController=[[QunGuanliViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    
}
//打卡
- (IBAction)daka:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.numLabel3.hidden = YES;
     self.hidesBottomBarWhenPushed=YES;
    DakaViewController *viewController=[[DakaViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
     self.hidesBottomBarWhenPushed=YES;
    
}
//我的考勤
- (IBAction)wodekaoqin:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.numLabel4.hidden = YES;
    self.hidesBottomBarWhenPushed=YES;
    WodeKaoqinViewController *vc=[[WodeKaoqinViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=YES;
}

@end
