//
//  AppDelegate.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, CLLocationManagerDelegate, RCIMConnectionStatusDelegate, RCIMUserInfoDataSource, RCIMGroupInfoDataSource>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic) double longitude;
@property (nonatomic) double latitude;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *adress;
@property (strong, nonatomic) UINavigationController * rootNav;

- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *userInfo))completion;

@end

