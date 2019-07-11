//
//  JianQunDaKaViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/27.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JianQunDaKaViewController.h"
#import "GuiZeSetViewController.h"
#import "SearchViewController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "GongZhangRenZhengViewController.h"

@interface JianQunDaKaViewController () <MAMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate, AMapLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (nonatomic, strong) MAMapView *map;
// 定位管理器
@property (nonatomic, strong) CLLocation *currentLocation;          //定位坐标
@property (nonatomic, strong) AMapLocationManager *locationManager; //定位管
@end

@implementation JianQunDaKaViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"建群打卡";
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;

    self.map = [[MAMapView alloc] initWithFrame:self.mapView.bounds];
    self.map.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.map.delegate = self;
    //设置地图缩放比例，即显示区域
    [_map setZoomLevel:15.1 animated:YES];
    _map.mapType = MKMapTypeStandard;
    _map.userTrackingMode = MAUserTrackingModeFollow; //追踪用户的location更新
    _map.showsUserLocation = YES;                     //定位小蓝点
    //设置定位精度
    _map.desiredAccuracy = kCLLocationAccuracyBest;
    //设置定位距离
    _map.distanceFilter = kCLLocationAccuracyHundredMeters;

    [self.mapView addSubview:self.map];

    CGFloat x = 18;
    CGFloat y = 20;
    CGFloat width = 320;
    CGFloat heigth = 30;
    self.searchView.frame = CGRectMake(x, y, width, heigth);
    self.searchTextField.delegate = self;
    [self.mapView insertSubview:self.searchView aboveSubview:self.map];

    self.locationManager = [[AMapLocationManager alloc] init];
    self.locationManager.delegate = self;

    // 带逆地理信息的一次定位（返回坐标和地址信息）
    [self.locationManager setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，最低2s，此处设置为2s
    self.locationManager.locationTimeout = 2;
    //   逆地理请求超时时间，最低2s，此处设置为2s
    self.locationManager.reGeocodeTimeout = 2;
    [self GetLococation]; //定位返回结果
}
-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self clear];
}

#pragma mark - Function

- (void)GetLococation {
    // 带逆地理（返回坐标和地址信息）。将下面代码中的 YES 改成 NO ，则不会返回地址信息。
    [self.locationManager requestLocationWithReGeocode:YES
                                       completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
                                           if (error) {
                                               NSLog(@"locError:{%ld - %@};", (long) error.code, error.localizedDescription);
                                               if (error.code == AMapLocationErrorLocateFailed) {
                                                   return;
                                               }
                                           }
                                           /**location 当前定位地理信息*/
                                           NSLog(@"location:%@", location);
                                           self.currentLocation = location;
                                           //把中心点设成自己的坐标
                                           self.map.centerCoordinate = self.currentLocation.coordinate;

                                           //当前位置逆地理信息
                                           if (regeocode) {
                                               self.gongchengLabel.text = [NSString stringWithFormat:@"%@", regeocode.formattedAddress];
                                               NSLog(@"reGeocode:%@", regeocode);
                                           }
                                       }];
}



- (void)showAlert:(NSString *)messageMsg {
    //    // 1.弹框提醒
    //    // 初始化对话框
    //
    //    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定建群" message:messageMsg preferredStyle:UIAlertControllerStyleAlert];
    //    //添加点击事件
    //    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    //        //跳转到规则设置：
    //            self.hidesBottomBarWhenPushed = YES;
    //         NSLog(@"按钮有反应了。。。。。");
    //        GuiZeSetViewController *guizeSetViewController=[[GuiZeSetViewController alloc]init];
    //
    //        [self.navigationController pushViewController:guizeSetViewController animated:YES];
    //        self.hidesBottomBarWhenPushed = YES;
    //
    //    }];
    //
    //    [alert addAction:sureAction];
    //
    //    // 弹出对话框
    //    [self presentViewController:alert animated:true completion:nil];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定建群" message:messageMsg preferredStyle:UIAlertControllerStyleAlert];

    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"确定建群"];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
    [title addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0, 4)];
    [alert setValue:title forKey:@"attributedTitle"];

    // 使用富文本来改变alert的message字体大小和颜色
    // NSMakeRange(0, 14) 代表:从0位置开始 14个字符
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:messageMsg];

    [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSMakeRange(0, messageMsg.length)];

    [message addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x333333) range:NSMakeRange(0, messageMsg.length)];

    [alert setValue:message forKey:@"attributedMessage"];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {

                                                             [self jianqunClick];

                                                         }];

    //    // 设置按钮的title颜色
    [cancelAction setValue:UIColorFromRGB(0x333333) forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    //

    [alert addAction:cancelAction];

    [self presentViewController:alert animated:YES completion:nil];
}
//建群
- (void)jianqunClick {

    [DZNetworkingTool postWithUrl:kMyForemanAuth
                           params:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  if ([responseObject[@"data"][@"is_auth_foreman"] intValue] == 0) {
                                      //跳转到工长认证
                                      GongZhangRenZhengViewController *viewController = [GongZhangRenZhengViewController new];
                                      self.hidesBottomBarWhenPushed = YES;
                                      [self.navigationController pushViewController:viewController animated:YES];
                                  } else if ([responseObject[@"data"][@"is_auth_foreman"] intValue] == 1) {
                                      [DZTools showNOHud:@"工长认证中，不能建群" delay:2];
                                  } else if ([responseObject[@"data"][@"is_auth_foreman"] intValue] == 2) {
                                      [self jianqun];
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
//建群
-(void)jianqun{
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    
    if (self.gongdiNameText.text.length == 0) {
        [DZTools showNOHud:@"工地名称不能为空！" delay:2];
        return;
    }
    NSDictionary *dict = @{
                           @"group_name": self.gongdiNameText.text,
                           @"address": self.gongchengLabel.text,
                           @"lng": @(longitude),
                           @"lat": @(latitude)
                           };
    [DZNetworkingTool postWithUrl:kFoundGroup
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict=responseObject[@"data"];
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  self.hidesBottomBarWhenPushed = YES;
                                  //跳转到设置
                                  GuiZeSetViewController *vc = [[GuiZeSetViewController alloc] init];
                                  vc.groupId=[dict[@"group_id"] intValue];
                                  [self.navigationController pushViewController:vc animated:YES];
                                  self.hidesBottomBarWhenPushed = YES;
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                              
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:responseObject[@"msg"] delay:2];
                           }
                        IsNeedHub:NO];
}
//清除 信息
- (void)clear
{
    [self.map  removeAnnotations:self.map.annotations];
    [self.map removeOverlays:self.map.overlays];
}
#pragma mark -- XibFunction
- (IBAction)JianqunClick:(id)sender {
    
    if (self.gongdiNameText.text.length == 0) {
        [DZTools showNOHud:@"工地名称不能为空！" delay:2];
        return;
    }
    
    [DZNetworkingTool  postWithUrl:kFoundGroupCleck params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSString *score = responseObject[@"data"][@"score"];
             [self showAlert:[NSString stringWithFormat:@"本次建群消费%@积分",score]];
        }else{
           [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
   
}
- (IBAction)searchBtnClick:(id)sender {

//    self.hidesBottomBarWhenPushed = YES;
//    SearchViewController *viewController = [[SearchViewController alloc] init];
//    viewController.mapChange = ^(AMapTip *_Nonnull tip) {
//        //        self.currentLocation.coordinate=tip.location;
//        self.currentLocation= [[CLLocation alloc]initWithLatitude:tip.location.latitude longitude:tip.location.longitude];
//        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
//        pointAnnotation.coordinate =  self.currentLocation.coordinate;//设置地图的定位中心点坐标
//        self.map.centerCoordinate = self.currentLocation.coordinate;;//将点添加到地图上，即所谓的大头针
//        [self.map addAnnotation:pointAnnotation];
//
//
//        self.gongchengLabel.text=[NSString stringWithFormat:@"%@",tip.address];
//    };
//    [self.navigationController pushViewController:viewController animated:YES];
//    self.hidesBottomBarWhenPushed=YES;
//

}

- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
    
}
- (IBAction)gongdiBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SearchViewController *viewController = [[SearchViewController alloc] init];
        viewController.mapChangeBlock = ^(AMapPOI *_Nonnull tip) {

            self.currentLocation= [[CLLocation alloc]initWithLatitude:tip.location.latitude longitude:tip.location.longitude];
            MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
            pointAnnotation.coordinate =  self.currentLocation.coordinate;//设置地图的定位中心点坐标
            self.map.centerCoordinate = self.currentLocation.coordinate;//将点添加到地图上，即所谓的大头针
            [self.map addAnnotation:pointAnnotation];
            
            
            self.gongchengLabel.text=[NSString stringWithFormat:@"%@%@%@%@",tip.province,tip.city,tip.district,tip.address];
        };
        viewController.mapChangeBlock1 = ^(AddressModel * _Nonnull model) {
            
            
             self.gongchengLabel.text=[NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        };
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    

}

@end
