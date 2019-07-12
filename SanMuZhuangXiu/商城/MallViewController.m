//
//  MallViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/19.
//  Copyright © 2018 Darius. All rights reserved.
//
#import "MallViewController.h"
#import "ReLayoutButton.h"
#import "StoreFocusListCell.h"
#import "SDCycleScrollView.h"
#import "ImgTitleCollectionCell.h"
#import "StoreClassListViewController.h"
#import "StoreDetailViewController.h"
#import "SearchGLViewController.h"

#import "CategoryListModel.h"
#import "BannerModel.h"
#import "MallSellerList.h"

static NSString *const imgCellId = @"ImgTitleCollectionCell";

@interface MallViewController () <SDCycleScrollViewDelegate, CLLocationManagerDelegate>
// 定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *cardNumLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *tuiJianBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *distanceBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *haopinBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *starBtn;

@property (strong, nonatomic) IBOutlet UIView *tableHeaderView;
@property (weak, nonatomic) IBOutlet UIView *lunboView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (weak, nonatomic) IBOutlet UIButton *dingWeiBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *CategoryDataArray;
@property (nonatomic, assign) NSInteger classSelectIndex;
@property (nonatomic, strong) NSMutableArray *bannerArray;
@property (nonatomic, strong) NSMutableArray *titleArray;

@property (nonatomic) NSInteger page;
/// default 默认 distance 距离 praise 好评 level 星级
@property (nonatomic, strong) NSString *type;

@end

@implementation MallViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getCategoryData];
    self.navigationController.navigationBar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self initCollectionView];

    [self initScrollView];
    [self initTableView];

    [self initLocation];
}

#pragma mark – UI
- (void)initTableView {
    
    self.sectionHeaderView.frame = CGRectMake(0, 0, ViewWidth, 40);
    self.tableHeaderView.frame = CGRectMake(0, 0, ViewWidth, 279 - 25 + ViewWidth / 375.0 * 175);

    self.tableView.tableHeaderView = self.tableHeaderView;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreFocusListCell" bundle:nil] forCellReuseIdentifier:@"StoreFocusListCell"];
  
}
- (void)initScrollView {

    //    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.lunboView.bounds delegate:self placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, ViewWidth, ViewWidth / 375.0 * 225) imageNamesGroup:@[@"home_pic_banner1", @"home_pic_banner2", @"home_pic_banner3"]];
    self.cycleScrollView.titleLabelBackgroundColor = [UIColor clearColor];
    self.cycleScrollView.autoScrollTimeInterval = 3.f;
    self.cycleScrollView.showPageControl = YES;
    [SDCycleScrollView clearImagesCache]; // 清除缓存。
    [self.lunboView addSubview:self.cycleScrollView];
}

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ViewWidth - 60) / 5;
    layout.itemSize = CGSizeMake(width, 75);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(10, 10, 0, 10);

    self.classSelectIndex = 0;
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerClass:[ImgTitleCollectionCell class] forCellWithReuseIdentifier:imgCellId];
}

#pragma mark – Network

//数据请求
- (void)getCategoryData {

    [DZNetworkingTool postWithUrl:kLitestoreIndex
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                if ([[responseObject objectForKey:@"data"][@"Categorylist"] isEqual:[NSNull null]]) {

                } else {
                    NSDictionary *dict = [responseObject objectForKey:@"data"];
                    NSArray *arr = [dict objectForKey:@"Categorylist"];
                    NSLog(@"-----------%@", dict);
                    [self.CategoryDataArray removeAllObjects];
                    for (NSDictionary *dict in arr) {
                        CategoryListModel *model = [CategoryListModel mj_objectWithKeyValues:dict];

                        [self.CategoryDataArray addObject:model];
                    }
                    [self.collectionView reloadData];

                    NSArray *bannerArr = [NSArray array];
                    bannerArr = [dict objectForKey:@"bannerlist"];
                    NSString *imageStr = @"";
                    NSString *titleStr = @"";

                    [self.bannerArray removeAllObjects];
                    [self.titleArray removeAllObjects];
                    for (NSDictionary *bannerDict in bannerArr) {
                        BannerModel *model = [BannerModel mj_objectWithKeyValues:bannerDict];
                        imageStr = model.image;
                        [self.bannerArray addObject:imageStr];
                        titleStr = model.title;
                        [self.titleArray addObject:titleStr];
                    }

                    self.cycleScrollView.imageURLStringsGroup = [self.bannerArray copy];
                    self.cycleScrollView.titlesGroup = [self.titleArray copy];
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
- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        @"lat": [NSString stringWithFormat:@"%lf", latitude],
        @"page": @(1),
        @"row": @(20),
        @"type": @"default"
    };
    [DZNetworkingTool postWithUrl:kIndexStoreList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                if (isRefresh) {
                    [self.dataArray removeAllObjects];
                }
                NSArray *array = dict[@"list"];
                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in array) {
                    MallSellerList *list = [MallSellerList mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:list];
                }
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark - SDCycleScrollView Delegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"-----点击了------");
}
#pragma mark - CoreLocation Delegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [self.locationManager stopUpdatingLocation];
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];

    //获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:currentLocation
                   completionHandler:^(NSArray *array, NSError *error) {
                       if (array.count > 0) {
                           CLPlacemark *placemark = [array objectAtIndex:0];
                           //             NSLog(@"????%@",placemark);
                           //获取城市
                           NSString *currCity = placemark.locality;
                           if (!currCity) {
                               //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                               currCity = placemark.administrativeArea;
                           }

                           [self.dingWeiBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@%@", placemark.administrativeArea, placemark.locality, placemark.subLocality, placemark.thoroughfare, placemark.name] forState:UIControlStateNormal];
                       } else if (error == nil && [array count] == 0) {
                           NSLog(@"No results were returned.");
                       } else if (error != nil) {
                           NSLog(@"An error occurred = %@", error);
                       }

                   }];
}
#pragma mark - <UICollectionViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.CategoryDataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgTitleCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];

    CategoryListModel *categoryModel = self.CategoryDataArray[indexPath.row];

    cell.textLabel.text = categoryModel.name;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, categoryModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    //    if (self.classSelectIndex == indexPath.row) {
    //        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, categoryModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg_pre"]];
    //    }

    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    CategoryListModel *categoryModel = self.CategoryDataArray[self.classSelectIndex];
    CategoryListModel *categoryModel2 = self.CategoryDataArray[indexPath.row];

    ImgTitleCollectionCell *selectCell = (ImgTitleCollectionCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.classSelectIndex inSection:0]];
    //
    //    [selectCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, categoryModel2.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    ImgTitleCollectionCell *cell = (ImgTitleCollectionCell *) [collectionView cellForItemAtIndexPath:indexPath];

    //    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, categoryModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    //    self.classSelectIndex = indexPath.row;
    self.hidesBottomBarWhenPushed = YES;
    StoreClassListViewController *viewController = [StoreClassListViewController new];
    viewController.selectIndex = indexPath.row;

    viewController.title = categoryModel2.name;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.tableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.sectionHeaderView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    StoreFocusListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreFocusListCell" forIndexPath:indexPath];
    MallSellerList *dict = self.dataArray[indexPath.row];
    cell.storeNameLabel.text = dict.seller_name;

    if ([dict.store_avatar containsString:@"http://"]) {
         [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict.store_avatar]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }else{
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, dict.store_avatar]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }

    if (dict.distance < 0) {
        cell.distanceLabel.text = [NSString stringWithFormat:@"0km"];
    } else {
        cell.distanceLabel.text = [NSString stringWithFormat:@"%.2fkm", (double) dict.distance];
    }
    cell.starView.actualScore = dict.level;
    cell.pingjiaLabel.text = [NSString stringWithFormat:@"%.f%%好评", dict.ratio * 100];
    cell.goodsLabel.text = [NSString stringWithFormat:@"主营商品:%@", dict.seller_type_name];
    cell.yimaiLabel.text = [NSString stringWithFormat:@"%ld人已买", dict.order_count];
    cell.huodongLabel.text = [NSString stringWithFormat:@"满%ld减%ld", (long) dict.man, (long) dict.subtract];
    cell.peisongLabel.text = [NSString stringWithFormat:@"配送费:¥%@", dict.distribution_fee];
    cell.deletebtn.hidden = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    MallSellerList *dict = self.dataArray[indexPath.row];
    StoreDetailViewController *viewController = [StoreDetailViewController new];
    viewController.seller_id = dict.seller_id;
    viewController.storeName = dict.seller_name;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

#pragma mark - Function

- (void)initData {
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.CategoryDataArray = [NSMutableArray array];
    self.bannerArray = [NSMutableArray array];
    self.titleArray = [NSMutableArray array];
}
- (void)initLocation {
    [[DZTools getAppDelegate].locationManager startUpdatingLocation];
    //判断定位操作是否被允许

    if ([CLLocationManager locationServicesEnabled]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        //设置定位精度
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.distanceFilter = kCLLocationAccuracyHundredMeters; //每隔多少米定位一次（这里的设置为每隔百米)
        if (IOS8) {
            //使用应用程序期间允许访问位置数据
            [self.locationManager requestWhenInUseAuthorization];
        }
        // 开始定位
        [self.locationManager startUpdatingLocation];
    } else {
        //提示用户无法进行定位操作
        NSLog(@"%@", @"定位服务当前可能尚未打开，请设置打开！");
    }
}

#pragma mark - XibFunction
//购物车
- (IBAction)cardBtnclicked:(id)sender {
}

//排序
- (IBAction)panxuBtnclicked:(UIButton *)sender {

    sender.selected = YES;

    switch (sender.tag) {
    case 1: {
        self.starBtn.selected = NO;
        self.distanceBtn.selected = NO;
        self.haopinBtn.selected = NO;
        self.type = @"default";

    } break;
    case 2: {
        self.starBtn.selected = NO;
        self.tuiJianBtn.selected = NO;
        self.haopinBtn.selected = NO;
        self.type = @"distance";

    } break;
    case 3: {
        self.starBtn.selected = NO;
        self.tuiJianBtn.selected = NO;
        self.distanceBtn.selected = NO;
        self.type = @"praise";

    } break;
    case 4: {
        self.haopinBtn.selected = NO;
        self.tuiJianBtn.selected = NO;
        self.distanceBtn.selected = NO;
        self.type = @"level";

    } break;
    default:
        break;
    }
    
    [self refresh];
}
//搜索页面的跳转
- (IBAction)searchBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed=YES;
    SearchGLViewController *vc=[[SearchGLViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = NO;

}

@end
