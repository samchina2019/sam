//
//  TabBarController.m
//  HOOLA
//
//  Created by 犇犇网络 on 2018/8/18.
//  Copyright © 2018年 Darius. All rights reserved.
//

#import "TabBarController.h"
#import "DZNavigationController.h"

#import "HomeViewController.h"
#import "MessageViewController.h"
#import "MallViewController.h"
#import "CartPageViewController.h"
#import "MineViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface TabBarController () <UITabBarControllerDelegate, UITabBarDelegate, RCIMReceiveMessageDelegate>
@property (nonatomic , assign) NSInteger unReadNumber;

@end

@implementation TabBarController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getHeaderData];
    [self laodTotalNum];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UITabBar appearance].translucent = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tabBar.tintColor = TabbarColor;
    [self setTabBar];
    self.selectedIndex = 0;
    self.delegate = self;
    self.tabBarController.tabBar.delegate = self;
    [[RCIM sharedRCIM] setReceiveMessageDelegate:self];
    [self setBadageNum];
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"cartXiaoxi" object:nil];
   
}
- (void)searchClick:(NSNotification *)noti {
    [self laodTotalNum];
}
#pragma mark – Network
-(void)laodTotalNum {
[DZNetworkingTool postWithUrl:kGetTotalNum
                   params:nil
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if ([responseObject[@"code"] intValue] == SUCCESS) {
                          NSInteger cartTotalNum = [responseObject[@"data"][@"cart_total_num"] intValue];
                          UITabBarItem *item = [self.tabBar.items objectAtIndex:3];
                          // 如果没有未读消息返回值为nil
                          if (cartTotalNum == 0 || cartTotalNum == nil) {
                              item.badgeValue = nil;
                              return;
                          }
                          item.badgeValue = [NSString stringWithFormat:@"%d",  cartTotalNum];
                          NSDictionary *dict =@{
                                                @"number":@(cartTotalNum)
                                                };
                          //发送通知
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"xiaoxilaji" object:nil userInfo:dict];
                      }
                  }
                   failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                       
                   }
                IsNeedHub:NO];
}
- (void)getHeaderData {
    [DZNetworkingTool postWithUrl:kXiaoXiHome
                           params:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *systemDict = responseObject[@"data"][@"system"];
                                  NSInteger number = [systemDict[@"unread"] integerValue];
                                  NSDictionary *check_workDict = responseObject[@"data"][@"check_work"];
                                  NSInteger number1 = [check_workDict[@"unread"] integerValue];
                                  NSDictionary *logisticsDict = responseObject[@"data"][@"logistics"];
                                  NSInteger number2 = [logisticsDict[@"unread"] integerValue];
                                  NSDictionary *abnormalDict = responseObject[@"data"][@"abnormal"];
                                  NSInteger number3 = [abnormalDict[@"unread"] integerValue];
                                  NSDictionary *shareDict = responseObject[@"data"][@"share"];
                                  NSInteger number4 = [shareDict[@"unread"] integerValue];
                                  self.unReadNumber = number + number1 + number2 + number3 + number4;
                                  [self setBadageNum];
                            
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               
                           }
                        IsNeedHub:NO];
}
- (void)setTabBar {
    /**** 添加子控制器 ****/
    [self setupOneChildViewController:[[HomeViewController alloc] init] title:@"首页" image:@"tab_home" selectedImage:@"tab_home_pre"];
    //    [self setupOneChildViewController:[[RCDChatListViewController alloc] init] title:@"消息" image:@"tab_news" selectedImage:@"tab_news_pre"];
    [self setupOneChildViewController:[[MessageViewController alloc] init] title:@"消息" image:@"tab_news" selectedImage:@"tab_news_pre"];
    [self setupOneChildViewController:[[MallViewController alloc] init] title:@"商城" image:@"tab_shop" selectedImage:@"tab_shop_pre"];
    [self setupOneChildViewController:[[CartPageViewController alloc] init] title:@"材料车" image:@"tab_car" selectedImage:@"tab_car_pre"];
    //    [self setValue:[[CustomTabBar alloc] init] forKeyPath:@"tabBar"];

    [self setupOneChildViewController:[[MineViewController alloc] init] title:@"我的" image:@"tab_me" selectedImage:@"tab_me_pre"];
    
}
- (void)setupOneChildViewController:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    if (image.length) { // 图片名有具体值，判断图片传入值是空还是nil
        UIImage *tabImage = [UIImage imageNamed:image];
        tabImage = [tabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.image = tabImage;
        UIImage *selecttabImage = [UIImage imageNamed:selectedImage];

        selecttabImage = [selecttabImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        vc.tabBarItem.selectedImage = selecttabImage;
        NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
        //颜色属性
        attributes[NSForegroundColorAttributeName] = [UIColor blackColor];
        //字体大小属性
        //还有一些其他属性的key可以去NSAttributedString.h文件里去找
        attributes[NSFontAttributeName] = [UIFont systemFontOfSize:13];

        NSMutableDictionary *selectAttri = [NSMutableDictionary dictionary];
        selectAttri[NSForegroundColorAttributeName] = [MTool colorWithHexString:@"#2e8cff"];
        selectAttri[NSFontAttributeName] = [UIFont systemFontOfSize:11];

        vc.tabBarItem.title = title;
        //设置为选中状态的文字属性
        [vc.tabBarItem setTitleTextAttributes:attributes forState:UIControlStateNormal];
        //设置选中状态的属性
        [vc.tabBarItem setTitleTextAttributes:selectAttri forState:UIControlStateSelected];

        //        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(-5, 0, 5, 0);
        //        [vc.tabBarItem setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        
        
        
        
    }

    DZNavigationController *nav = [[DZNavigationController alloc] initWithRootViewController:vc];
    [self addChildViewController:nav];
}

//判断是否跳转
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if ([tabBarController.tabBar.selectedItem.title isEqualToString:@"消息"] || [tabBarController.tabBar.selectedItem.title isEqualToString:@"材料车"]) {
        DZNavigationController *nav = tabBarController.selectedViewController;
        if ([DZTools panduanLoginWithViewContorller:nav.viewControllers[0] isHidden:NO]) {
            return YES;
        }
        return NO;
    } else {
        return YES;
    }
}
//- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
//    if (item.tag==1) {
//        //在这里进行其他的操作。
//        if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]){
//        }
//    }
//}
#pragma mark - RCIMReceiveMessageDelegate
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setBadageNum];
    });
}
- (void)setBadageNum {
    NSInteger unreadMessageCount = [self getUnreadCount];
    UITabBarItem *item = [self.tabBar.items objectAtIndex:1];
    // 如果没有未读消息返回值为nil
    if (unreadMessageCount == 0 || unreadMessageCount == nil) {
        item.badgeValue = nil;
        return;
    }
    item.badgeValue = [NSString stringWithFormat:@"%ld", (long) unreadMessageCount];
}
// 获取未读消息个数的方法
- (NSInteger)getUnreadCount {
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
        @(ConversationType_PRIVATE),
        @(ConversationType_DISCUSSION),
        @(ConversationType_APPSERVICE),
        @(ConversationType_PUBLICSERVICE),
        @(ConversationType_GROUP)
    ]];
    return (unreadMsgCount + self.unReadNumber) ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
