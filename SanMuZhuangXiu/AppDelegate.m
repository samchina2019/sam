//
//  AppDelegate.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import "IQKeyboardManager.h"
#import "DaKaListModel.h"
#import "LoginViewController.h"
#import <AVFoundation/AVFoundation.h>
// Bugly崩溃日志
#import <Bugly/Bugly.h>

#import "WXApiManager.h"
#import "AlipayManager.h"
#import <AlipaySDK/AlipaySDK.h>
#define RONGCLOUD_IM_APPKEY @"pvxdm17jpo9or" // online key
//播放器
#import "WAMediaPlayer.h"
//分享
#import <UMShare/UMShare.h>
#import <UMCommon/UMCommon.h>
// 引入 JPush 功能所需头文件
#import "JPUSHService.h"
// iOS10 注册 APNs 所需头文件
//#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
//#endif

//极光  520192728@qq.com  Sanmuweilai2019
//友盟  三木未来   Sanmuweilai2019

//地图
static NSString *amapKey = @"a249aed2fcec8cce478f1c6ca2afa9b5";
static NSString *appId = @"19ce3ce912";
//极光
static NSString *appKey = @"d4e22952af31ab53b53d772f";
static NSString *channel = @"Publish channel";
static NSString *weixinAppkey = @"wxf92112054c7eb268";
static BOOL isProduction = TRUE;

@interface AppDelegate () <JPUSHRegisterDelegate>
///声音播放器
@property(nonatomic,strong) WAMediaPlayer *player;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
     [NSThread sleepForTimeInterval:1];
    //y
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];

    // AppDelegate 进行全局设置
    if (@available(iOS 11.0, *)) {
        [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
    }
    
    [AMapServices sharedServices].apiKey = amapKey;
    /**********崩溃日志************/
    [Bugly startWithAppId:appId];

    /**********极光推送************/
    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert | JPAuthorizationOptionBadge | JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions
                           appKey:appKey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];

    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if (resCode == 0) {
            NSLog(@"registrationID获取成功：%@", registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            NSLog(@"registrationID获取失败，code：%d", resCode);
        }
    }];
    [JPUSHService setDebugMode];

    /**********微信************/
    //向微信注册,发起支付必须注册
    [WXApi registerApp:weixinAppkey enableMTA:YES];

    /**********融云************/
    [[RCIM sharedRCIM] initWithAppKey:RONGCLOUD_IM_APPKEY];
    //连接状态代理
    [[RCIM sharedRCIM] setConnectionStatusDelegate:self];
    //设置发送消息时在消息体中携带用户信息
    [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
    //设置用户信息提供者（最近联系人及聊天界面需要用到的用户名和头像链接都会从代理方法获取）
    [[RCIM sharedRCIM] setUserInfoDataSource:self];
    [[RCIM sharedRCIM] setGroupInfoDataSource:self];
    [RCIM sharedRCIM].enablePersistentUserInfoCache = YES;
    //开启输入状态监听
    [RCIM sharedRCIM].enableTypingStatus = YES;
    //    //开启发送已读回执
    //    [RCIM sharedRCIM].enabledReadReceiptConversationTypeList =
    //        @[@(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_GROUP)];

    //开启多端未读状态同步
    [RCIM sharedRCIM].enableSyncReadStatus = YES;

    //设置显示未注册的消息
    //如：新版本增加了某种自定义消息，但是老版本不能识别，开发者可以在旧版本中预先自定义这种未识别的消息的显示
    [RCIM sharedRCIM].showUnkownMessage = YES;
    [RCIM sharedRCIM].showUnkownMessageNotificaiton = YES;
    [RCIM sharedRCIM].globalConversationPortraitSize = CGSizeMake(36, 36);
    //开启消息@功能（只支持群聊和讨论组, App需要实现群成员数据源groupMemberDataSource）
    [RCIM sharedRCIM].enableMessageMentioned = YES;

    //设置Log级别，开发阶段打印详细log
    [RCIMClient sharedRCIMClient].logLevel = RC_Log_Level_Info;

    if ([DZTools islogin]) {
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[User getUserID] name:[User getUser].nickname portrait:[User getUser].avatar];
        [[RCIM sharedRCIM] connectWithToken:[User getIMToken]
            success:^(NSString *userId) {
                NSLog(@"登录成功========");
            }
            error:^(RCConnectErrorCode status) {
                NSLog(@"connect error %ld", (long) status);
                dispatch_async(dispatch_get_main_queue(), ^{

                               });
            }
            tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");

            }];
    }
    /**********友盟分享************/
    [self initShareSDK];
    /**********开启定位************/
    [self initLoactionManager];
    ///键盘自适应高度
    [self keyboardManager];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    TabBarController *tabBarController = [TabBarController new];
    self.window.rootViewController = tabBarController;

    [self.window makeKeyAndVisible];
    return YES;
}
#pragma mark - 键盘自适应高度
- (void)keyboardManager {
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager]; // 获取类库的单例变量

    keyboardManager.enable = YES; // 控制整个功能是否启用

    keyboardManager.shouldResignOnTouchOutside = YES; // 控制点击背景是否收起键盘

    keyboardManager.shouldToolbarUsesTextFieldTintColor = YES; // 控制键盘上的工具条文字颜色是否用户自定义

    keyboardManager.toolbarManageBehaviour = IQAutoToolbarBySubviews; // 有多个输入框时，可以通过点击Toolbar 上的“前一个”“后一个”按钮来实现移动到不同的输入框

    keyboardManager.enableAutoToolbar = YES; // 控制是否显示键盘上的工具条

    keyboardManager.placeholderFont = [UIFont boldSystemFontOfSize:17]; // 设置占位文字的字体

    keyboardManager.keyboardDistanceFromTextField = 10.0f; // 输入框距离键盘的距离
}
#pragma mark - 分享
- (void)initShareSDK {
    [UMConfigure setLogEnabled:YES]; //设置打开日志
    [UMConfigure initWithAppkey:UmengAppkey channel:nil];
    [self configUSharePlatforms];
}
- (void)configUSharePlatforms {
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:WeiXinAppkey appSecret:WeiXinAppSecret redirectURL:nil];
    /** 移除相应平台的分享，如微信收藏*/
    [[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];

    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:QQAppkey appSecret:QQAppSecret redirectURL:nil];
    /* 设置新浪的appKey和appSecret */
    //    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:SinaAppkey appSecret:SinaAppSecret redirectURL:nil];
}
#pragma mark - 初始化定位
- (void)initLoactionManager {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 50;
    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        [_locationManager requestWhenInUseAuthorization];
    }
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"请开启定位:设置 > 隐私 > 位置 > 定位服务");
    }
    [_locationManager startUpdatingLocation];
}
#pragma mark - 定位成功
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *nowLocation = [locations lastObject];
    // 通过location  或得到当前位置的经纬度
    self.latitude = nowLocation.coordinate.latitude;
    self.longitude = nowLocation.coordinate.longitude;

    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    //反地理编码
    [geoCoder reverseGeocodeLocation:nowLocation
                   completionHandler:^(NSArray<CLPlacemark *> *_Nullable placemarks, NSError *_Nullable error) {
                       if (error == nil) {
                           CLPlacemark *placemark = [placemarks firstObject];
                           NSLog(@"%@__%f__%f", placemark.name, self.latitude, self.longitude);
                           self.city = placemark.addressDictionary[@"City"];
                           self.adress = placemark.addressDictionary[@"FormattedAddressLines"][0];
                       }

                   }];
    [self.locationManager stopUpdatingLocation]; //定位成功后停止定位

    DaKaListModel *model = [DaKaListModel getdakaInfo];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYY-MM-dd"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];
    NSString *time = [NSString stringWithFormat:@"%@ %@:00", currentTimeString, model.clockin_time];

    NSInteger timeTamp = [self timeSwitchTimestamp:time andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];
    NSString *lateTime = [NSString stringWithFormat:@"%@ %@:00", currentTimeString, model.gooff_time];
    NSInteger laterTime = [self timeSwitchTimestamp:lateTime andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];

    NSString *afteTime = [NSString stringWithFormat:@"%@ %@:00", currentTimeString, model.noon_start];
    NSInteger afterTime = [self timeSwitchTimestamp:afteTime andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];

    NSString *noonTime = [NSString stringWithFormat:@"%@ %@:00", currentTimeString, model.noon_end];
    NSInteger noonrTime = [self timeSwitchTimestamp:noonTime andFormatter:[NSString stringWithFormat:@"YYYY-MM-dd HH:mm:ss"]];

    NSInteger currenttimeTamp = [self getNowTimestamp];
    double dictence = [self distanceBetweenOrderBy:self.latitude :model.lat:self.longitude:model.lng];

    if (dictence < model.card_range) {
        if (timeTamp > currenttimeTamp) {
            [self jisuDaka:model type:@"1"];
        }
        if (laterTime < currenttimeTamp) {
            [self jisuDaka:model type:@"2"];
        }
        if (currenttimeTamp > afterTime) {
            [self jisuDaka:model type:@"3"];
        }

        if (currenttimeTamp < noonrTime) {
            [self jisuDaka:model type:@"3"];
        }
    }
}

#pragma mark - 计算两点之间的距离
- (double)distanceBetweenOrderBy:(double)lat1:(double)lat2:(double)lng1:(double)lng2 {

    CLLocation *curLocation = [[CLLocation alloc] initWithLatitude:lat1 longitude:lng1];

    CLLocation *otherLocation = [[CLLocation alloc] initWithLatitude:lat2 longitude:lng2];

    double distance = [curLocation distanceFromLocation:otherLocation];

    return distance;
}

#pragma mark - 极速打卡
- (void)jisuDaka:(DaKaListModel *)model type:(NSString *)type {

    NSDictionary *dict = @{
        @"lng": @(model.lng),
        @"lat": @(model.lat),
        //                          @"group_id":@(model.group_id),
        //                          @"type":type
    };
    [DZNetworkingTool postWithUrl:kAutoClockin
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict=responseObject[@"data"];
                NSString *urlStr=dict[@"data"];
                NSURL * url  = [NSURL URLWithString:urlStr];
                ///代测试
                [self.player playAudioWithURL:url];
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                
                

            } else {

                //            [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            //        [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
#pragma mark - 将某个时间转化成 时间戳

- (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate

    //时间转时间戳的方法:

    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];

    NSLog(@"将某个时间转化成 时间戳&&&&&&&timeSp:%ld", (long) timeSp); //时间戳的值

    return timeSp;
}
- (NSInteger)getNowTimestamp {

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    [formatter setDateStyle:NSDateFormatterMediumStyle];

    [formatter setTimeStyle:NSDateFormatterShortStyle];

    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    //设置时区,这个对于时间的处理有时很重要

    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];

    [formatter setTimeZone:timeZone];

    NSDate *datenow = [NSDate date]; //现在时间

    NSLog(@"设备当前的时间:%@", [formatter stringFromDate:datenow]);
    //    self.timeStr=[NSString stringWithFormat:@"%@",[formatter stringFromDate:datenow]];
    //时间转时间戳的方法:

    NSInteger timeSp = [[NSNumber numberWithDouble:[datenow timeIntervalSince1970]] integerValue];

    NSLog(@"设备当前的时间戳:%ld", (long) timeSp); //时间戳的值

    return timeSp;
}

#pragma mark 定位失败
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"error:%@", error);
}

- (void)onlineConfigCallBack:(NSNotification *)note {

    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions (such as an
    // incoming phone call or SMS message) or when the user quits the application
    // and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down
    // OpenGL ES frame rates. Games should use this method to pause the game.
    RCConnectionStatus status = [[RCIMClient sharedRCIMClient] getConnectionStatus];
    if (status != ConnectionStatus_SignUp) {
        int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
            @(ConversationType_PRIVATE), @(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE),
            @(ConversationType_PUBLICSERVICE), @(ConversationType_GROUP)
        ]];
        application.applicationIconBadgeNumber = unreadMsgCount;
    }
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate
    // timers, and store enough application state information to restore your
    // application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called
    // instead of applicationWillTerminate: when the user quits.
    //  int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
    //    @(ConversationType_PRIVATE),
    //    @(ConversationType_DISCUSSION),
    //    @(ConversationType_APPSERVICE),
    //    @(ConversationType_PUBLICSERVICE),
    //    @(ConversationType_GROUP)
    //  ]];
    //  application.applicationIconBadgeNumber = unreadMsgCount;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
    if ([RCIMClient sharedRCIMClient].getConnectionStatus != ConnectionStatus_Connected && [DZTools islogin]) {
        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[User getUserID] name:[User getUser].nickname portrait:[User getUser].avatar];
        [[RCIM sharedRCIM] connectWithToken:[User getIMToken]
            success:^(NSString *userId) {
                NSLog(@"登录成功========");
            }
            error:^(RCConnectErrorCode status) {
                NSLog(@"connect error %ld", (long) status);
                dispatch_async(dispatch_get_main_queue(), ^{

                               });
            }
            tokenIncorrect:^{
                //token过期或者不正确。
                //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
                //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
                NSLog(@"token错误");

            }];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the
    // application was inactive. If the application was previously in the
    // background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if
    // appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *, id> *)options {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url options:options];
    if (!result) {
        // 微信的支付回调
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }

        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSLog(@"result = %@", resultDic);
                                [[AlipayManager sharedManager] managerStandbyCallback:resultDic];
//                                                          if ([resultDic[@"resultStatus"] intValue] == 9000) {
//                                                              [DZTools showOKHud:@"支付完成" delay:2];
//                                                              [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuSuccess" object:nil];
//                                                          } else if ([resultDic[@"resultStatus"] intValue] == 6001) {
//                                                              [DZTools showNOHud:@"支付取消" delay:2];
//
//                                                          } else {
//                                                              [DZTools showNOHud:@"支付失败" delay:2];
//                                                          }
                                                      
//                                                      }];
                                                      }];

            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url
                                             standbyCallback:^(NSDictionary *resultDic) {
                                                 NSLog(@"result = %@", resultDic);
                                [[AlipayManager sharedManager] processAuthStandbyCallback:resultDic];
                                                 // 解析 auth code
//                                                 NSString *result = resultDic[@"result"];
//                                                 NSString *authCode = nil;
//                                                 if (result.length > 0) {
//                                                     NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                                                     for (NSString *subResult in resultArr) {
//                                                         if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                                                             authCode = [subResult substringFromIndex:10];
//                                                             break;
//                                                         }
//                                                     }
//                                                 }
//                                                 NSLog(@"授权结果 authCode = %@", authCode ?: @"");
                                                 
                                             }];
        }
    }
    return result;
}

- (BOOL)application:(UIApplication *)application
              openURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
           annotation:(id)annotation {
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 微信的支付回调
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }

        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url
                                                      standbyCallback:^(NSDictionary *resultDic) {
                                                          NSLog(@"result = %@", resultDic);
            [[AlipayManager sharedManager] managerStandbyCallback:resultDic];
                           [[AlipayManager sharedManager] managerStandbyCallback:resultDic];
//                            if ([resultDic[@"resultStatus"] intValue] == 9000) {
//                                          [DZTools showOKHud:@"支付完成" delay:2];
//                                          [[NSNotificationCenter defaultCenter] postNotificationName:@"zhifuSuccess" object:nil];
//                                      } else if ([resultDic[@"resultStatus"] intValue] == 6001) {
//                                          [DZTools showNOHud:@"支付取消" delay:2];
//
//                                      } else {
//                                          [DZTools showNOHud:@"支付失败" delay:2];
//                                      }
                                     
                                  }];

            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url
                                             standbyCallback:^(NSDictionary *resultDic) {
                                                 NSLog(@"result = %@", resultDic);
                    [[AlipayManager sharedManager] processAuthStandbyCallback:resultDic];

////                                                  解析 auth code
//                    NSString *result = resultDic[@"result"];
//                    NSString *authCode = nil;
//                    if (result.length > 0) {
//                        NSArray *resultArr = [result componentsSeparatedByString:@"&"];
//                        for (NSString *subResult in resultArr) {
//                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
//                        authCode = [subResult substringFromIndex:10];
//                            break;
//                             }
//                         }
//                     }
//                                                 NSLog(@"授权结果 authCode = %@", authCode ?: @"");
                                             }];
        }
    }
    return result;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}
#pragma mark - RCIMUserInfoDataSource
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion {
    // 所有的用户名 和 头像url 信息均需要通过自己的服务器去获取
    // 登录用户的id 请替换成自己的id
    NSString *myid = [User getUserID];
    if ([userId isEqualToString:myid]) {

        //  返回登录用户的详细信息
        NSString *picUrl = [User getUser].avatar;
        NSString *name = [User getUser].nickname;

        RCUserInfo *user = [[RCUserInfo alloc] init];
        user.userId = myid;
        user.name = name;
        user.portraitUri = picUrl;
        return completion(user);
    } else {

        // 返回除登录用户以外 其它聊天对象的信息
        // 注意 如果是通过服务器 获取用户信息 可以在 为获取前设置默认的返回值
        //  获取到返回值后 重新调用融云的接口刷新用户信息
        RCUserInfo *user = [[RCUserInfo alloc] init];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"default_avator" ofType:@".png"];
        user.userId = userId;
        user.name = userId;
        user.portraitUri = path;
        //TODO: 从接口获取信息
        [DZNetworkingTool postWithUrl:kFriendDetails
            params:@{ @"user_id": userId }
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSDictionary *dict = responseObject[@"data"];
                    NSString *headImg = dict[@"avatar"];
                    NSString *nickname = dict[@"nickname"];

                    user.name = nickname;
                    user.userId = userId;
                    user.portraitUri = headImg;
                    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:userId];
                }
                // 获取到信息后刷新用户信息
                return completion(user);
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                // 获取用户信息失败
            }
            IsNeedHub:NO];
    }
}
- (void)getGroupInfoWithGroupId:(NSString *)groupId completion:(void (^)(RCGroup *groupInfo))completion
{
         RCGroup *group = [[RCGroup alloc]init];
        //TODO: 从接口获取信息
        [DZNetworkingTool postWithUrl:kGroupDetails
                               params:@{ @"group_type": @"0",
                                         @"group_id":groupId
                                         }
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
                                      NSDictionary *dict = responseObject[@"data"];
                                      NSString *headImg = dict[@"group_image"];
                                      NSString *nickname = dict[@"group_name"];
                                      
                                      group.groupName = nickname;
                                      group.groupId = groupId;
                                      group.portraitUri = headImg;
                                      [[RCIM sharedRCIM] refreshGroupInfoCache:group withGroupId:groupId];
                                  }
                                  // 获取到信息后刷新用户信息
                                  return completion(group);
                              }
                               failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                   // 获取用户信息失败
                               }
                            IsNeedHub:NO];
}
#pragma mark - RCIMConnectionStatusDelegate
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
//    return;
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"您的帐号在别的设备上登录，"
                                                                               @"您被迫下线！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action){
                                                    [User deleUser];
                                                    LoginViewController *loginVC = [LoginViewController new];
                                                    loginVC.hidesBottomBarWhenPushed = YES;
                                                    [[DZTools topViewController].navigationController pushViewController:loginVC animated:YES];
                                                }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else if (status == ConnectionStatus_TOKEN_INCORRECT) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"token失效"
                                                                               @"您被迫下线！"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action){
                                                    [User deleUser];
                                                    LoginViewController *loginVC = [LoginViewController new];
                                                    loginVC.hidesBottomBarWhenPushed = YES;
                                                    [[DZTools topViewController].navigationController pushViewController:loginVC animated:YES];
                                                }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    } else if (status == ConnectionStatus_DISCONN_EXCEPTION) {
        [[RCIMClient sharedRCIMClient] disconnect];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您的帐号被封禁" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"知道了"
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action){

                                                }]];
        [self.window.rootViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark APNS
/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
    didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/*
 * @Summary:远程push注册成功收到DeviceToken回调
 *
 */
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    /// Required - 注册 DeviceToken

    [JPUSHService registerDeviceToken:deviceToken];
    NSString *token = [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<" withString:@""]
        stringByReplacingOccurrencesOfString:@">"
                                  withString:@""] stringByReplacingOccurrencesOfString:@" "
                                                                            withString:@""];
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", token]);
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}

/*
 * @Summary: 远程push注册失败
 */
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    /**
     * 统计推送打开率2
     */
    [[RCIMClient sharedRCIMClient] recordRemoteNotificationEvent:userInfo];
    
    /**
     * 获取融云推送服务扩展字段2
     */
    NSDictionary *pushServiceData = [[RCIMClient sharedRCIMClient] getPushExtraFromRemoteNotification:userInfo];
    if (pushServiceData) {
        NSLog(@"该远程推送包含来自融云的推送服务");
        for (id key in [pushServiceData allKeys]) {
            NSLog(@"key = %@, value = %@", key, pushServiceData[key]);
        }
    } else {
        
        NSLog(@"该远程推送不包含来自融云的推送服务");
    }
}
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    /**
     * 统计推送打开率3
     */
    [[RCIMClient sharedRCIMClient] recordLocalNotificationEvent:notification];
    
    
    
}
//iOS 7 Remote Notification
- (void)application:(UIApplication *)application didReceiveRemoteNotification:  (NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    NSLog(@"this is iOS7 Remote Notification");
    
    // iOS 10 以下 Required
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark- JPUSHRegisterDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler  API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"/////////%@",userInfo);
    if (@available(iOS 10.0, *)) {
        if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
            [JPUSHService handleRemoteNotification:userInfo];
        }
    } else {
        // Fallback on earlier versions
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"/////////%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
}
// iOS 12 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center openSettingsForNotification:(UNNotification *)notification{
    if (notification && [notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //从通知界面直接进入应用
    }else{
        //从通知设置界面进入应用
    }
}
@end
