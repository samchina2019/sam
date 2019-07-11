//
//  StoreDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreDetailViewController.h"
#import "StoreDetailGoodsViewController.h"
#import "StoreDetailCommentViewController.h"
#import "StoreDetailInfoViewController.h"
#import "FSScrollContentView.h"
#import "HYBStarEvaluationView.h"
#import "InputCaigoudanView.h"
#import "SellerModel.h"
#import "CartListModel.h"
#import "JieSuanViewController.h"
#import "ChatViewController.h"
#import "BaojiadanDetailViewController.h"

#import <UShareUI/UShareUI.h>
@interface StoreDetailViewController () <FSPageContentViewDelegate, FSSegmentTitleViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UILabel *pingjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *yimaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;
@property (weak, nonatomic) IBOutlet UIButton *focusBtn;
@property (weak, nonatomic) IBOutlet UIButton *addOrderBtn;
@property (weak, nonatomic) IBOutlet UIView *titleViewBgView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UILabel *carNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *guanzhuLabel;
//包邮
@property (weak, nonatomic) IBOutlet UILabel *baoyouLabel;
//同城
@property (weak, nonatomic) IBOutlet UILabel *tongchengLabel;
//货到付款
@property (weak, nonatomic) IBOutlet UILabel *fukuanLabel;
//积分专用
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
//普通发票
@property (weak, nonatomic) IBOutlet UILabel *fapiaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *kaidianTimeLabel;

@property (strong, nonatomic) UITextField *searchTF;

@property (strong, nonatomic) HYBStarEvaluationView *starView;
@property (strong, nonatomic) InputCaigoudanView *inputCaigoudanView;
@property (nonatomic, strong) FSSegmentTitleView *titleView;

@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSMutableArray *cartData;

@property (nonatomic, assign) BOOL isFollew;
@property (nonatomic, assign) int follow;

@property (nonatomic, strong) NSString *cart_id;
@property (nonatomic, strong) NSString *phoneStr;

@end

@implementation StoreDetailViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initNavHeaderCenterView];

    self.cartData = [NSMutableArray array];
    self.fukuanLabel.text = @"";
    self.jifenLabel.text = @"";
    
    [self initTitleView];
    [self initStarView];
  
    self.isFollew = NO;

//    注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"CartData" object:nil];
    
    [self initContentViewControllers];
}
#pragma mark – UI

- (void)initNavHeaderCenterView {
    UIView *bgSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth - 100, 30)];
    bgSearchView.layer.cornerRadius = 15;
    bgSearchView.backgroundColor = UIColorFromRGB(0xEEEEEE);
    
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 16, 16)];
    imgV.image = [UIImage imageNamed:@"icon_search"];
    [bgSearchView addSubview:imgV];
    
    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, ViewWidth - 160, 30)];
    self.searchTF.placeholder = @"搜索";
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [bgSearchView addSubview:self.searchTF];
    
    self.navigationItem.titleView = bgSearchView;
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    //    [button setImage:[UIImage imageNamed:@"fenxiang"] forState:UIControlStateNormal];
    //    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    //    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    //
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)initStarView {
    self.starView = [[HYBStarEvaluationView alloc] initWithFrame:self.starBgView.bounds numberOfStars:5 isVariable:NO];
    self.starView.actualScore = 4;
    self.starView.fullScore = 5;
    self.starView.isContrainsHalfStar = YES;
    [self.starBgView addSubview:self.starView];
}
- (void)initTitleView {
    self.titleArray = @[@"商品", @"评价", @"店铺详情"];
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(40, 0, ViewWidth - 80, 30) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x333333);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleFont = [UIFont boldSystemFontOfSize:14];
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:14];
    self.titleView.indicatorColor = TabbarColor;
    [self.titleViewBgView addSubview:self.titleView];
}
#pragma mark – Network

- (void)loadCartData {
    [DZNetworkingTool postWithUrl:kGetcartLists
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                [self.cartData removeAllObjects];
                NSArray *array = dict[@"lists"];
                if (array.count > 0) {
                    for (NSDictionary *dict in array) {
                        CartListModel *model = [CartListModel mj_objectWithKeyValues:dict];
                        [self.cartData addObject:model];
                    }
                    self.inputCaigoudanView.dataArray = [self.cartData copy];
                    [self.inputCaigoudanView.tableView reloadData];
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)initData {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        @"lat": [NSString stringWithFormat:@"%lf", latitude],
        @"seller_id": @(self.seller_id)
    };
    [DZNetworkingTool postWithUrl:kSellerDetails
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"][@"data"];
                NSDictionary *temp = dict[@"seller_details"];
                NSString *imgStr = @"";
                if ([temp[@"seller_imgs"] containsString:@"http://"]) {
                    imgStr = temp[@"seller_imgs"];
                }else{
                imgStr = [NSString stringWithFormat:@"%@%@",@"http://zhuang.tainongnongzi.com",temp[@"seller_imgs"]];
                }
                [self.imgView sd_setImageWithURL:[NSURL URLWithString:imgStr] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
                NSArray *huodong = dict[@"sales"];
                for (NSDictionary *temp in huodong) {
                    
                    if ([temp[@"type"] intValue] == 1) {
                       self.baoyouLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
                    }
                    if ([temp[@"type"] intValue] == 2) {
                        self.tongchengLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
                    }
                    if ([temp[@"type"] intValue] == 3) {
                       self.youhuiLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
                    }
                    
                    if ([temp[@"type"] intValue] == 4) {
                        if ([temp[@"content"] containsString:@"普通发票" ]) {
                            self.jifenLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
                        }else{
                        self.fapiaoLabel.text = [NSString stringWithFormat:@"%@", temp[@"content"]];
                        }
                    } 
                }
                self.storeNameLabel.text = dict[@"seller_name"];
                self.storeName = dict[@"seller_name"];
                self.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", [dict[@"distance"] floatValue]];

                self.starView.actualScore = [dict[@"star_class"] floatValue];
                self.kaidianTimeLabel.text = [NSString stringWithFormat:@"开店时间：%@",dict[@"setup_time"]];
                self.guanzhuLabel.text = [NSString stringWithFormat:@"%@人关注",dict[@"follow_num"]];
                self.yimaiLabel.text = [NSString stringWithFormat:@"%@人已购买", dict[@"purchase"]];
                self.pingjiaLabel.text = [NSString stringWithFormat:@"%.f%%好评", [dict[@"ratio"] floatValue] * 100];
                
                NSString *phone = dict[@"seller_phone"];
                if ([phone isKindOfClass:[NSNull class]]) {
                    self.phoneStr = @"10086";
                } else if ([phone isEqualToString:@""]) {
                    self.phoneStr = @"10086";
                } else {
                    self.phoneStr = phone;
                }
                self.follow = [dict[@"follow"] intValue];
                if (self.follow == 0) {
                    self.focusBtn.selected = NO;
                    self.isFollew = NO;
                } else {
                    self.isFollew = YES;
                    self.focusBtn.selected = YES;
                }
                [self.view layoutIfNeeded];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];

        }
        IsNeedHub:NO];
}

//实现方法
- (void)notification1:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.hidesBottomBarWhenPushed=YES;
    BaojiadanDetailViewController *vc=[[BaojiadanDetailViewController alloc]init];
    vc.seller_id=[dic[@"seller_id"] intValue];
    vc.receipt_id=[dic[@"stuff_cart_id"] intValue];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    
    
}

//店铺分享
- (void)rightBarButtonItemClicked {
    
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject*shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来"descr:@"店铺详情"thumImage:[UIImage imageNamed:@"AppIcon"]];
        //设置网页地址
        shareObject.webpageUrl = @"http://www.baidu.com";
        //分享消息对象设置分享内容对象
        messageObject.shareObject= shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self
                                               completion:^(id data, NSError *error) {
               if (error) {
                   NSLog(@"************Share fail with error %@*********", error);
               } else {
                   NSLog(@"response data is %@", data);
               }
           }];
    }];
    
}


- (void)initContentViewControllers {
    self.viewControllers = [NSMutableArray array];
    StoreDetailGoodsViewController *vc1 = [[StoreDetailGoodsViewController alloc] init];
    vc1.storeName=self.storeName;
    
    vc1.storeId = self.seller_id;
    [self.viewControllers addObject:vc1];
    StoreDetailCommentViewController *vc2 = [[StoreDetailCommentViewController alloc] init];
    vc2.storeId = self.seller_id;
    [self.viewControllers addObject:vc2];
    StoreDetailInfoViewController *vc3 = [[StoreDetailInfoViewController alloc] init];
    vc3.storeId = self.seller_id;
    [self.viewControllers addObject:vc3];
    self.pageContentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight - Nav_BAR_HEIGHT - CGRectGetMaxY(self.titleViewBgView.frame)) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.contentBgView addSubview:self.pageContentView];
}

#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTF endEditing:YES];

    NSDictionary *dict = @{
        @"title": self.searchTF.text
    };
    [[NSNotificationCenter defaultCenter] postNotificationName:@"searchData" object:nil userInfo:dict];

    return YES;
}

#pragma mark - XibFunction
//电话
- (IBAction)phoneBtnClicked:(id)sender {

    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneStr];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:
                     [NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
//聊天
- (IBAction)messageBtnClicked:(id)sender {
    
    NSDictionary *dict = @{
                       @"user_id": @(self.seller_id)
                       };
    [DZNetworkingTool postWithUrl:kFriendDetails
                       params:dict
                      success:^(NSURLSessionDataTask *task, id responseObject) {
                          if ([responseObject[@"code"] intValue] == SUCCESS) {
                              NSDictionary *dict = responseObject[@"data"];

                              NSString *headImg = dict[@"avatar"];
                              NSString *title = dict[@"nickname"];
                              self.phoneStr = dict[@"mobile"];
                            
                              //会话列表
                              ChatViewController *conversationVC = [[ChatViewController alloc] init];
                              conversationVC.hidesBottomBarWhenPushed = YES;
                              conversationVC.conversationType = ConversationType_PRIVATE;
                              conversationVC.targetId = [NSString stringWithFormat:@"%ld",self.seller_id ];
                              conversationVC.title = title;
                             
                              
                              RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                              rcduserinfo_.name = title;
                              rcduserinfo_.userId = [NSString stringWithFormat:@"%ld",self.seller_id];
                              rcduserinfo_.portraitUri = headImg;
                              
                              
                              [self.navigationController pushViewController:conversationVC animated:YES];
                              
                          } else {
                              [DZTools showNOHud:responseObject[@"msg"] delay:2];
                          
                          }
                      }
                       failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                          
                           [DZTools showNOHud:RequestServerError delay:2.0];
                       }
                    IsNeedHub:NO];

}
//关注
- (IBAction)fcouseBtnClicked:(id)sender {
    self.focusBtn.selected = !self.focusBtn.selected;
    //
    if (!self.isFollew) {
        NSDictionary *params = @{
            @"type": @"20",
            @"seller_id": @(self.seller_id)

        };
        [DZNetworkingTool postWithUrl:kDianpuFollow
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {

                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    NSDictionary *dict=responseObject[@"data"];
                    self.follow=[dict[@"follow_id"] intValue];
                    self.isFollew = YES;
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    self.isFollew = NO;
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                self.isFollew = NO;
                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];

    } else {
        //取消关注
        NSDictionary *params = @{

            @"follow_id": @(self.follow)

        };
        [DZNetworkingTool postWithUrl:kCancelFollow
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {

                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    self.isFollew = NO;
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    self.isFollew = YES;
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                self.isFollew = YES;
                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];
    }
}
//导入材料单
- (IBAction)addCiaLiaoDanBtnClicked:(id)sender {
    [self loadCartData];
    self.inputCaigoudanView.dataArray = [self.cartData copy];
    self.inputCaigoudanView.seller_id = [NSString stringWithFormat:@"%ld", (long) self.seller_id];
    [self.inputCaigoudanView.tableView reloadData];
    [[DZTools getAppWindow] addSubview:self.inputCaigoudanView];
}

#pragma mark – 懒加载
//MARK:懒加载
- (InputCaigoudanView *)inputCaigoudanView;
{
    if (!_inputCaigoudanView) {
        _inputCaigoudanView = [[InputCaigoudanView alloc] initWithFrame:[DZTools getAppWindow].bounds];
    }
    return _inputCaigoudanView;
}

@end
