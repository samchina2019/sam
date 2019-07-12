//
//  GoodsDetailPageViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GoodsDetailPageViewController.h"
#import "FSScrollContentView.h"
#import "GoodsDetailInfoViewController.h"
#import "GoodsDetailParameterViewController.h"
#import "GoodsDetailBuyMessageViewController.h"
#import "YBPopupMenu.h"
#import "ChatViewController.h"
#import "StoreDetailViewController.h"
#import "SearchGLViewController.h"
#import "MyFocusPageViewController.h"
#import "MyZuJiPageViewController.h"
#import "GoodsDetailModel.h"
#import "CartJiesuanViewController.h"
#import "GoodsSelectSpecView.h"
#import "GuigeModel.h"

@interface GoodsDetailPageViewController () <FSPageContentViewDelegate, FSSegmentTitleViewDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) NSString *goods_spec_id; //根据规格和品牌确定的商品ID
@property (nonatomic, strong) NSString *goods_sku_id;  //规格ID 1 2 3
@property (nonatomic, strong) NSString *goods_sku_name;
@property (nonatomic, strong) NSString *pingPaiID;
@property (nonatomic, strong) NSString *goods_num;

@property (nonatomic, strong) GoodsSelectSpecView *goodsSelectSpecView;

@end

@implementation GoodsDetailPageViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadBasicData];
    self.goods_num = @"";
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self initNavTitleView];
    [self initContentViewControllers];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    UIImage *image = [UIImage imageNamed:@"nav_gengduo"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
}

#pragma mark – UI

- (void)initNavTitleView {
    _titleArray = @[@"商品", @"详情", @"购买须知"];
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth - 110, 44) titles:_titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor clearColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x333333);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleFont = [UIFont boldSystemFontOfSize:14];
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:14];
    self.titleView.indicatorColor = TabbarColor;
    self.navigationItem.titleView = self.titleView;
}
#pragma mark – ContentViewController

- (void)initContentViewControllers {
    self.viewControllers = [NSMutableArray array];
    GoodsDetailInfoViewController *vc1 = [[GoodsDetailInfoViewController alloc] init];
    vc1.Block = ^(NSString *_Nonnull num, BOOL isNumChange) {
        if (isNumChange) {
            self.goods_num = num;
        } else {
            self.goodsSelectSpecView.dataDict = self.dataDict;
            NSMutableArray *guigeArray = [NSMutableArray arrayWithCapacity:0];
            for (NSDictionary *dict in self.dataDict[@"specData"][@"spec_attr"]) {
                GuigeModel *model = [[GuigeModel alloc] init];
                model.data = dict[@"spec_items"];
                model.spec_name = dict[@"group_name"];
                model.spec_rel_id = [dict[@"group_id"] integerValue];
                
                [guigeArray addObject:model];
            }
            self.goodsSelectSpecView.dataArray = [guigeArray mutableCopy];
//            self.goodsSelectSpecView.pingPaiArray = [self.dataDict[@"specData"][@"brand_list"] mutableCopy];
            [[DZTools getAppWindow] addSubview:self.goodsSelectSpecView];
        }
    };
    vc1.goodsId = self.goodsId;
    vc1.mallId = self.mallId;
    vc1.storeName = self.storeName;
    vc1.image = self.image;
    vc1.view.backgroundColor = [UIColor redColor];
    [self.viewControllers addObject:vc1];
    GoodsDetailParameterViewController *vc2 = [[GoodsDetailParameterViewController alloc] init];
    vc2.goodsId = self.goodsId;
    vc2.mallId = self.mallId;
    vc2.storeName = self.storeName;
    vc2.dataDict = self.dataDict;
    vc2.view.backgroundColor = [UIColor whiteColor];
    [self.viewControllers addObject:vc2];
    GoodsDetailBuyMessageViewController *vc3 = [[GoodsDetailBuyMessageViewController alloc] init];
    vc3.goodsId = self.goodsId;
    vc3.mallId = self.mallId;
    vc3.storeName = self.storeName;
    vc3.dataDict = self.dataDict;
    [self.viewControllers addObject:vc3];
    self.pageContentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight - NavAndStatusHight - 50) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
}

#pragma mark – Network

- (void)loadBasicData {
    NSDictionary *params = @{
        @"goods_id": @(self.goodsId)
    };
    [DZNetworkingTool postWithUrl:kGoodsDetail
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.dataDict = responseObject[@"data"];
                GoodsDetailInfoViewController *vc1 = self.viewControllers[0];
                vc1.dataDict = self.dataDict;
                [vc1 refreshWithDict:self.dataDict];
                GoodsDetailParameterViewController *vc2 = self.viewControllers[1];
                vc2.dataDict = self.dataDict;
                [vc2 refreshWithDict:self.dataDict];
                GoodsDetailBuyMessageViewController *vc3 = self.viewControllers[2];
                vc3.dataDict = self.dataDict;
                [vc3 refreshWithDict:self.dataDict];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark FSSegmentTitleViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;
}

- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (index == 0) {
        if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
            return;
        }
     
        NSDictionary *dict = @{
                               @"user_id": @(self.mallId)
                               };
        [DZNetworkingTool postWithUrl:kFriendDetails
                               params:dict
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
                                      NSDictionary *dict = responseObject[@"data"];
                                      
                                      NSString *headImg = dict[@"avatar"];
                                      NSString *title = dict[@"nickname"];
//                                      self.phoneStr = dict[@"mobile"];
                                      
                                      //会话列表
                                      ChatViewController *conversationVC = [[ChatViewController alloc] init];
                                      conversationVC.hidesBottomBarWhenPushed = YES;
                                      conversationVC.conversationType = ConversationType_PRIVATE;
                                      conversationVC.targetId = [NSString stringWithFormat:@"%ld",self.mallId ];
                                      conversationVC.title = title;
                                      
                                      
                                      RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                                      rcduserinfo_.name = title;
                                      rcduserinfo_.userId = [NSString stringWithFormat:@"%ld",self.mallId];
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


    } else if (index == 1) {

        self.hidesBottomBarWhenPushed = YES;
        StoreDetailViewController *vc = [[StoreDetailViewController alloc] init];
        vc.seller_id = self.mallId;
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = YES;

    } else if (index == 2) {
        //跳到搜索页面
        self.hidesBottomBarWhenPushed = YES;
        SearchGLViewController *vc = [[SearchGLViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = YES;

    } else if (index == 3) {
        if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
            return;
        }
        self.hidesBottomBarWhenPushed = YES;
        MyFocusPageViewController *vc = [[MyFocusPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = YES;

    } else if (index == 4) {
        if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
            return;
        }
        self.hidesBottomBarWhenPushed = YES;
        MyZuJiPageViewController *vc = [[MyZuJiPageViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - Function

- (void)rightBarButtonItemClicked:(UIButton *)btn {
    [YBPopupMenu showRelyOnView:btn
                         titles:@[@"消息", @"商城", @"搜索", @"我的关注", @"浏览记录", @"帮助与反馈"]
                          icons:@[@"icon_xiaoxi", @"icon_dianpu (1)", @"icon_sousuo", @"shangcheng_guanzhu", @"icon_lljl", @"icon_bangzhu"]
                      menuWidth:150
                  otherSettings:^(YBPopupMenu *popupMenu) {
                      popupMenu.dismissOnSelected = YES;
                      popupMenu.isShowShadow = YES;
                      popupMenu.delegate = self;
                      popupMenu.type = YBPopupMenuTypeDefault;
                      popupMenu.cornerRadius = 8;
                      popupMenu.tag = 100;
                      popupMenu.backColor = [UIColor whiteColor];
                      popupMenu.separatorColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0];
                      popupMenu.textColor = [UIColor blackColor];
                      
                      popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                  }];
}
#pragma mark - XibFunction
//店铺
- (IBAction)mallBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    StoreDetailViewController *vc = [[StoreDetailViewController alloc] init];
    vc.seller_id = self.mallId;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//在线咨询
- (IBAction)callBtnClick:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }

    NSDictionary *dict = @{
                           @"user_id": @(self.mallId)
                           };
    [DZNetworkingTool postWithUrl:kFriendDetails
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  
                                  NSString *headImg = dict[@"avatar"];
                                  NSString *title = dict[@"nickname"];
//                                  self.phoneStr = dict[@"mobile"];
                                  
                                  //会话列表
                                  ChatViewController *conversationVC = [[ChatViewController alloc] init];
                                  conversationVC.hidesBottomBarWhenPushed = YES;
                                  conversationVC.conversationType = ConversationType_PRIVATE;
                                  conversationVC.targetId = [NSString stringWithFormat:@"%ld",self.mallId ];
                                  conversationVC.title = title;
                                  
                                  
                                  RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                                  rcduserinfo_.name = title;
                                  rcduserinfo_.userId = [NSString stringWithFormat:@"%ld",self.mallId];
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
//购物车
- (IBAction)cartBtnCLick:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
}
//加入购物车
- (IBAction)joinCartBtnClicked:(UIButton *)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    if (self.goods_sku_id.length == 0) {
        self.goodsSelectSpecView.dataDict = self.dataDict;
        NSMutableArray *guigeArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in self.dataDict[@"specData"][@"spec_attr"]) {
            GuigeModel *model = [[GuigeModel alloc] init];
            model.data = dict[@"spec_items"];
            model.spec_name = dict[@"group_name"];
            model.spec_rel_id = [dict[@"group_id"] integerValue];
            [guigeArray addObject:model];
        }
        self.goodsSelectSpecView.dataArray = [guigeArray mutableCopy];
        self.goodsSelectSpecView.cartTiaozhuan = 1;
        self.goodsSelectSpecView.imageStr = self.dataDict[@"detail"][@"image"];
//        self.goodsSelectSpecView.pingPaiArray = [self.dataDict[@"specData"][@"brand_list"] mutableCopy];
        [[DZTools getAppWindow] addSubview:self.goodsSelectSpecView];
        return;
    }
    NSDictionary *params = @{ @"goods_id": @(self.goodsId),
                              @"goods_num": self.goods_num.length == 0 ? @"1" : self.goods_num,
                              @"goods_sku_id": self.goods_sku_id };
    NSLog(@"%@", params);
    [DZNetworkingTool postWithUrl:kAddCart
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                
                self.goods_sku_id = @"";
                
               [[NSNotificationCenter defaultCenter] postNotificationName:@"cartXiaoxi" object:nil userInfo:nil];
                
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];

        }
        IsNeedHub:NO];
}
//立即购买
- (IBAction)bugBtnClicked:(UIButton *)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    if (self.goods_sku_id.length == 0) {
        self.goodsSelectSpecView.dataDict = self.dataDict;
        NSMutableArray *guigeArray = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dict in self.dataDict[@"specData"][@"spec_attr"]) {
            GuigeModel *model = [[GuigeModel alloc] init];
            model.data = dict[@"spec_items"];
            model.spec_name = dict[@"group_name"];
            model.spec_rel_id = [dict[@"group_id"] integerValue];
            
            [guigeArray addObject:model];
        }

        self.goodsSelectSpecView.dataArray = [guigeArray mutableCopy];
        self.goodsSelectSpecView.cartTiaozhuan = 2;
         self.goodsSelectSpecView.imageStr = self.dataDict[@"detail"][@"image"];
//        self.goodsSelectSpecView.pingPaiArray = [self.dataDict[@"specData"][@"brand_list"] mutableCopy];
        [[DZTools getAppWindow] addSubview:self.goodsSelectSpecView];
        return;
    }
    
    NSDictionary *params = @{ @"goods_id": @(self.goodsId),
                              @"goods_num": self.goods_num.length == 0 ? @"1" : self.goods_num,
                              @"goods_sku_id": self.goods_sku_id };
    [DZNetworkingTool postWithUrl:kAddCart
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
//                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                NSString *cart_id=[NSString stringWithFormat:@"%@_%@",@(self.goodsId),[NSString stringWithFormat:@"%@", self.goods_sku_id]];
                NSArray *array=@[cart_id];
                self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;

                CartJiesuanViewController *viewController = [[CartJiesuanViewController alloc] init];
                 viewController.cartIdArray=array;
                  viewController.title = @"结算";
//                viewController.isSelectAll = isSelectAll;
                [self.navigationController pushViewController:viewController animated:YES];
                self.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;

            } else {
                [DZTools showNOHud:@"库存不足" delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];

        }
        IsNeedHub:NO];
}

#pragma mark – 懒加载
- (GoodsSelectSpecView *)goodsSelectSpecView {
    if (!_goodsSelectSpecView) {
        _goodsSelectSpecView = [[GoodsSelectSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(self) weakSelf = self;
        _goodsSelectSpecView.sureBlock = ^(NSString *_Nonnull num, NSString *_Nonnull guigeID, NSString *_Nonnull guigeName, NSString *_Nonnull goods_spec_id, NSString *_Nonnull pingPaiID, NSString *_Nonnull goods_name, NSString *_Nonnull goods_price, NSString *_Nonnull pingPaiName ,int cartTiaozhuan) {
            weakSelf.goods_num = num;
            weakSelf.goods_sku_id = guigeID;
            weakSelf.goods_sku_name = guigeName;
            weakSelf.goods_spec_id = goods_spec_id;
//            weakSelf.pingPaiID = pingPaiID;
            if (cartTiaozhuan==1) {
                [weakSelf joinCartBtnClicked:nil];
            }else if (cartTiaozhuan==2){
                [weakSelf bugBtnClicked:nil];
            }
            
            NSDictionary *dict = @{   @"num": num,
//                                    @"pingPaiID": pingPaiID,
                                    @"goods_sku_name": guigeName,
                                    @"goods_spec_id": goods_spec_id };
            GoodsDetailInfoViewController *vc1 = weakSelf.viewControllers[0];
            [vc1 refreshGoodsInfoWithDict:dict];
        };
        _goodsSelectSpecView.deleteBlock = ^{
            weakSelf.goodsSelectSpecView = nil;
        };
    }
    return _goodsSelectSpecView;
}
@end
