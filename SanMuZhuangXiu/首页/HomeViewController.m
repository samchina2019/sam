//
//  HomeViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "CaiLiaoYuSuanViewController.h"
#import "RenCaiFuWuViewController.h"
#import "GongDiKaoQinViewController.h"
#import "JiFenStoreViewController.h"
#import "GongchengfuwuViewController.h"
#import "WebViewViewController.h"
#import "StoreDetailViewController.h"
#import <UShareUI/UShareUI.h>

@interface HomeViewController ()<SDCycleScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *lunboView;
@property (weak, nonatomic) IBOutlet UILabel *numLabel1;
@property (weak, nonatomic) IBOutlet UILabel *numLabel2;
@property (weak, nonatomic) IBOutlet UILabel *numLabel3;
@property (weak, nonatomic) IBOutlet UILabel *numLabel4;
@property (weak, nonatomic) IBOutlet UILabel *numLabel5;
@property (weak, nonatomic) IBOutlet UILabel *numLabel6;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property (nonatomic, strong) NSArray *lunboArray;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if ([DZTools islogin]) {
        [self getDataFromServer];
    }
   
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth/375.0*225) imageNamesGroup: @[@"home_pic_banner1",@"home_pic_banner2",@"home_pic_banner3"]];
    self.cycleScrollView.delegate = self;
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [SDCycleScrollView clearImagesCache]; 
    [self.lunboView addSubview:self.cycleScrollView];
    
    self.numLabel1.hidden = YES;
    self.numLabel2.hidden = YES;
    self.numLabel3.hidden = YES;
    self.numLabel4.hidden = YES;
    self.numLabel5.hidden = YES;
    self.numLabel6.hidden = YES;
}

#pragma mark – Network

- (void)getDataFromServer
{
    [DZNetworkingTool postWithUrl:kHomeData params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            NSMutableArray *titleArray = [NSMutableArray arrayWithCapacity:0];
            NSMutableArray *imgArray = [NSMutableArray arrayWithCapacity:0];
            self.lunboArray = dict[@"bannerList"];
            for (NSDictionary *bannerDic in self.lunboArray) {
                [imgArray addObject:bannerDic[@"image"]];
                [titleArray addObject:bannerDic[@"title"]];
                
            }
            self.cycleScrollView.imageURLStringsGroup = imgArray;
//            self.cycleScrollView.titlesGroup = titleArray;
            
            NSDictionary *gongdiDict = dict[@"index_menus"][1];
            if ([gongdiDict[@"nwes"] intValue] == 0) {
                self.numLabel2.hidden = YES;
            }else{
                self.numLabel2.hidden = NO;
                self.numLabel2.text = [NSString stringWithFormat:@"%@",gongdiDict[@"nwes"]];
            }
            
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    } IsNeedHub:NO];
}
#pragma mark - XibFunction
//材料预算
- (IBAction)cailiaoyusuan:(id)sender {
    self.numLabel1.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    CaiLiaoYuSuanViewController *viewController = [CaiLiaoYuSuanViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//工地考勤
- (IBAction)gongdikaoqin:(id)sender {
    self.numLabel2.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    GongDiKaoQinViewController *viewController = [GongDiKaoQinViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//人才服务
- (IBAction)rencaifuwu:(id)sender {
    self.numLabel3.hidden = YES;
    self.hidesBottomBarWhenPushed = YES;
    RenCaiFuWuViewController *viewController = [RenCaiFuWuViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//工程服务
- (IBAction)gongchengfuwu:(id)sender {
    
    self.numLabel4.hidden = YES;
    
    self.hidesBottomBarWhenPushed = YES;
    GongchengfuwuViewController  *viewController = [[GongchengfuwuViewController alloc]init];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}
//积分兑换
- (IBAction)jifenduihuan:(id)sender {
    self.numLabel5.hidden = YES;
   
    self.hidesBottomBarWhenPushed = YES;
     JiFenStoreViewController *viewController = [ JiFenStoreViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//推荐有礼
- (IBAction)tuijianyouli:(id)sender {
    self.numLabel6.hidden = YES;
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        NSString *phone = [User getUser].mobile;
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"推荐有礼" thumImage:[UIImage imageNamed:@"AppIcon"]];
        //设置网页地址
        shareObject.webpageUrl = [NSString stringWithFormat:@"%@?group=%@&token=%@",kShareRegister,@(1),phone];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self
                                               completion:^(id data, NSError *error) {
                                                   if (error) {
                                                       NSLog(@"************Share fail with error %@*********", error);
                                                   } else {
                                                       [DZTools showOKHud:@"分享成功" delay:2];
                                                   }
                                               }];
    }];
    
    
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
