//
//  CaiLiaoYuSuanViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/10.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CaiLiaoYuSuanViewController.h"
#import "SDCycleScrollView.h"
#import "CaiLiaoFenLeiViewController.h"
#import "XiangmuFenleiViewController.h"
#import "CartPageViewController.h"
#import "ZIdongjisuanController.h"
#import "WebViewViewController.h"
#import "StoreDetailViewController.h"

@interface CaiLiaoYuSuanViewController ()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) NSArray *lunboArray;
@property (weak, nonatomic) IBOutlet UIView *lunboView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel1;
@property (weak, nonatomic) IBOutlet UILabel *numLabel2;
@property (weak, nonatomic) IBOutlet UILabel *numLabel3;
@property (weak, nonatomic) IBOutlet UILabel *numLabel4;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@end

@implementation CaiLiaoYuSuanViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"材料预算";
    
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth/375.0*225) imageNamesGroup: @[@"home_pic_banner1",@"home_pic_banner2",@"home_pic_banner3"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [self.lunboView addSubview:self.cycleScrollView];
}
-(void)loadData{
    [DZNetworkingTool postWithUrl:kCartIndex params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
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
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    } IsNeedHub:NO];
    
}
#pragma mark - XibFunction
//材料分类
- (IBAction)cailiaofenlei:(id)sender {
//    self.numLabel1.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    CaiLiaoFenLeiViewController *viewController = [CaiLiaoFenLeiViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//项目分类
- (IBAction)xiangmufenlei:(id)sender {
    self.numLabel2.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    XiangmuFenleiViewController *viewController = [XiangmuFenleiViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//材料单

- (IBAction)zidongjisuan:(id)sender {
    
    
    self.numLabel3.hidden = YES;
    self.tabBarController.selectedIndex=3;
    [self.navigationController popToRootViewControllerAnimated:NO];

    
}

- (IBAction)cailiaodan:(id)sender {
   self.numLabel4.hidden = YES;
    //    self.hidesBottomBarWhenPushed = YES;
    //    ZIdongjisuanController *viewController=[[ZIdongjisuanController alloc]init];
    //    [self.navigationController pushViewController:viewController animated:YES];
    //    self.hidesBottomBarWhenPushed = YES;
}


#pragma mark SDCycleScrollViewDelegate
/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSDictionary *dict = self.lunboArray[index];
    if ([dict[@"to_type"] integerValue] == 1) {
        self.hidesBottomBarWhenPushed = YES;
        WebViewViewController *viewController=[[WebViewViewController alloc]init];
        viewController.urlStr = dict[@"to_url"];
        viewController.titleStr = dict[@"title"];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }else if ([dict[@"to_type"] integerValue] == 2) {
        self.hidesBottomBarWhenPushed = YES;
        StoreDetailViewController *viewController=[[StoreDetailViewController alloc]init];
        viewController.seller_id = [dict[@"to_url"] integerValue];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    }
    
}


@end
