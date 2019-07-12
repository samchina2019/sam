//
//  SearchViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SearchViewController.h"
#import "JianQunDaKaViewController.h"

#import "AMapTipAnnotation.h"

@interface SearchViewController () <AMapSearchDelegate, MAMapViewDelegate, AMapLocationManagerDelegate, UITextFieldDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) UITextField *searchTF;
@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) MAMapView *mapView;
// 定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) UITableView *tableView;

/** 地址数组 */
@property (nonatomic, strong) NSMutableArray *addressArray;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavHeaderCenterView];
    ///地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [AMapServices sharedServices].enableHTTPS = YES;

    [self initMapView];
    [self loadAddress];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self clear];
}
#pragma mark – UI

- (void)initNavHeaderCenterView {
    UIView *bgSearchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth - 80, 30)];
    bgSearchView.layer.cornerRadius = 15;
    bgSearchView.backgroundColor = UIColorFromRGB(0xEEEEEE);

    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(15, 7, 16, 16)];
    imgV.image = [UIImage imageNamed:@"icon_search"];
    [bgSearchView addSubview:imgV];

    self.searchTF = [[UITextField alloc] initWithFrame:CGRectMake(45, 0, ViewWidth - 160, 30)];
    self.searchTF.placeholder = @"输入查询关键词";
    self.searchTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.searchTF.font = [UIFont systemFontOfSize:14];
    self.searchTF.returnKeyType = UIReturnKeySearch;
    self.searchTF.delegate = self;
    [bgSearchView addSubview:self.searchTF];

    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;

    self.navigationItem.titleView = bgSearchView;
}
#pragma mark – MapView

- (void)initMapView {
    self.mapView = [[MAMapView alloc] initWithFrame:self.bgView.bounds];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    //设置地图缩放比例，即显示区域
    [_mapView setZoomLevel:15.1 animated:YES];
    _mapView.mapType = MKMapTypeStandard;
    _mapView.userTrackingMode = MAUserTrackingModeFollow; //追踪用户的location更新
    _mapView.showsUserLocation = YES;                     //定位小蓝点
    //设置定位精度
    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
    //设置定位距离
    _mapView.distanceFilter = kCLLocationAccuracyHundredMeters;

    [self.bgView addSubview:self.mapView];

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.tableView.hidden = NO;
    self.tableView.userInteractionEnabled = YES;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.mapView addSubview:self.tableView];
    self.tableView.tableFooterView = [UIView new];

    //    UIView *hideView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 130)];
    //    hideView.backgroundColor=[UIColor clearColor];
    //    [self.mapView addSubview:hideView];
    //    UIButton *hideBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, hideView.bounds.size.width, hideView.bounds.size.height)];
    //    hideBtn.backgroundColor=[UIColor clearColor];
    //    [hideView addSubview:hideBtn];
    //    [hideBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
}
//-(void)cancelView{
//    self.tableView.hidden=YES;
//}

#pragma mark – Network

- (void)loadAddress {
    NSDictionary *params = @{
        @"token": [User getToken],
    };
    [DZNetworkingTool getWithUrl:kAddressLists
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                for (NSDictionary *addDict in dict[@"list"]) {
                    AddressModel *model = [AddressModel mj_objectWithKeyValues:addDict];
                    [self.addressArray addObject:model];
                }

                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

#pragma mark – UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.isSearch = YES;
    if (textField.text.length == 0) {
        return;
    }
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];

    request.location = [AMapGeoPoint locationWithLatitude:latitude longitude:longitude];

    /* 按照距离排序. */
    request.sortrule = 0;
    request.keywords = textField.text;
    request.requireExtension = YES;

    [self.search AMapPOIAroundSearch:request];
}
#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTF endEditing:YES];

    return YES;
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    if (response.pois.count == 0) {
        return;
    }

    //    for (AMapTip *tip in response.tips) {
    //
    //        CLLocationCoordinate2D coor ;
    //        coor.latitude = tip.location.latitude;
    //
    //        coor.longitude = tip.location.longitude;
    //
    //
    //        MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    //        pointAnnotation.coordinate = coor;//设置地图的定位中心点坐标
    //        self.mapView.centerCoordinate = coor;//将点添加到地图上，即所谓的大头针
    //        [self.mapView addAnnotation:pointAnnotation];
    //
    //    }

    [self.addressArray removeAllObjects];
    NSLog(@"---123----%@", response.pois);

    if (response.pois > 0) {

        self.tableView.hidden = NO;
        for (AMapPOI *tip in response.pois) {
            [self.addressArray addObject:tip];
        }

    } else {
        self.tableView.hidden = NO;
    }
    [self.tableView reloadData];
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[AMapTipAnnotation class]]) {
        static NSString *tipIdentifier = @"tipIdentifier";

        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:tipIdentifier];
        if (poiAnnotationView == nil) {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipIdentifier];
        }

        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];

        return poiAnnotationView;
    } else {
        return nil;
    }
}

#pragma mark – UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.addressArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cellid"];
    }
    if (self.isSearch) {
        AMapPOI *tip = self.addressArray[indexPath.row];

        cell.textLabel.text = tip.name;
        cell.detailTextLabel.text = tip.address;

    } else {
        AddressModel *model = self.addressArray[indexPath.row];
        cell.textLabel.text = model.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
    }

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (self.isSearch) {
        AMapPOI *tip = self.addressArray[indexPath.row];
        self.mapChangeBlock(tip);

    } else {
        AddressModel *model = self.addressArray[indexPath.row];

        self.mapChangeBlock1(model);
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Function
//清除
- (void)clear {
    [self.mapView removeAnnotations:self.mapView.annotations];
    [self.mapView removeOverlays:self.mapView.overlays];
}
#pragma mark - 懒加载
- (NSMutableArray *)addressArray {
    if (_addressArray == nil) {
        _addressArray = [NSMutableArray array];
    }
    return _addressArray;
}
@end
