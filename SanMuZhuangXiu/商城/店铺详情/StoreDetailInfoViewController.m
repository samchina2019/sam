//
//  StoreDetailInfoViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreDetailInfoViewController.h"
#import "StoreDetailInfoCell.h"
#import "CailiaoViewCell.h"

#import "GoodsSkuModel.h"

@interface StoreDetailInfoViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
///已选材料
@property (strong, nonatomic) IBOutlet UIView *yixuanCailiaoView;
///数字显示label
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
///材料单tableview
@property (weak, nonatomic) IBOutlet UITableView *cailiaodanTableview;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property(nonatomic ,strong)NSDictionary *dataDict;
@property (nonatomic) NSInteger page;

//已选材料
@property(nonatomic,strong)NSArray *selectedCailiao;
///number数量
@property (nonatomic, assign) NSInteger number;

@end

@implementation StoreDetailInfoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //    注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"newCartViewShow2" object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    
    self.number = 0;
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectedCailiao = [NSArray array];
    self.dataDict = [NSDictionary dictionary];
    
     self.cailiaodanTableview.rowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"StoreDetailInfoCell" bundle:nil] forCellReuseIdentifier:@"StoreDetailInfoCell"];
    [self.cailiaodanTableview registerNib:[UINib nibWithNibName:@"CailiaoViewCell" bundle:nil] forCellReuseIdentifier:@"CailiaoViewCell"];
    self.cailiaodanTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.mj_header beginRefreshing];

}
#pragma mark – Network

-(void)initData{
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
                             @"lng": [NSString stringWithFormat:@"%lf", longitude],
                             @"lat": [NSString stringWithFormat:@"%lf", latitude],
                             @"seller_id":@(self.storeId)
                             };
    [DZNetworkingTool postWithUrl:kSellerDetails
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict=responseObject[@"data"][@"data"];
                                  self.dataDict=dict[@"seller_details"];
                                 
                                
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                  
                                  
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                               
                           }
                        IsNeedHub:NO];
}

#pragma mark – Network

- (void)refresh
{
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
-(void)loadMore{
    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
                             @"lng": [NSString stringWithFormat:@"%lf", longitude],
                             @"lat": [NSString stringWithFormat:@"%lf", latitude],
                             @"seller_id":@(self.storeId)
                             };
    [DZNetworkingTool postWithUrl:kSellerDetails
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                  [self.tableView.mj_header endRefreshing];
                  [self.tableView.mj_footer endRefreshing];
                  if ([responseObject[@"code"] intValue] == SUCCESS) {
                      if(isRefresh){
                          [self.dataArray removeAllObjects];
                      }
                      NSDictionary *dict=responseObject[@"data"][@"data"];
                      self.dataDict=dict[@"seller_details"];
                      
                      [self.dataArray addObject:self.dataDict[@"seller_imgs"]];
                      [self.tableView reloadData];
                  } else {
                      [DZTools showNOHud:responseObject[@"msg"] delay:2];

                  }
              }
               failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                   [self.tableView.mj_header endRefreshing];
                   [self.tableView.mj_footer endRefreshing];
                   [DZTools showNOHud:RequestServerError delay:2.0];
                   
               }
            IsNeedHub:NO];
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.cailiaodanTableview) {
        if (self.selectedCailiao.count == 0) {
            UIImageView* backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.cailiaodanTableview.backgroundView = backgroundImageView;
            self.cailiaodanTableview.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.cailiaodanTableview.backgroundView = nil;
        }
        return self.selectedCailiao.count;
    }else{
    if ([[self.dataDict allKeys] count] == 0) {
        return 0;
    }
    return 7;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.cailiaodanTableview) {
        CailiaoViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"CailiaoViewCell" forIndexPath:indexPath];
        GoodsSkuModel* cailiaomodel = self.selectedCailiao[indexPath.row];
        NSDictionary *dict=cailiaomodel.selectsGoodsDict;
        cell.nameLabel.text = dict[@"goods_name"];
        cell.pinpaiLabel.text = dict[@"pingPaiName"];
        cell.guigeLabel.text = dict[@"guigeName"];
        cell.ppnumBtn.currentNumber = cailiaomodel.number;
        cell.numBlock = ^(CGFloat num) {
            cailiaomodel.number = num;
        };
        return cell;
        
    }else{
    StoreDetailInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StoreDetailInfoCell" forIndexPath:indexPath];
  
    switch (indexPath.row) {
        case 0:
        {
            cell.titleLabel.text = @"商家信息";
            cell.contentLabel.text = @" ";
            cell.array = self.dataArray;
        }
            break;
        case 1:
        {
            cell.titleLabel.text = @"商家名称";
            cell.contentLabel.text =self.dataDict[@"seller_name"];
            cell.array = @[];
        }
            break;
        case 2:
        {
            cell.titleLabel.text = @"经营类别";
            NSString *title=self.dataDict[@"business"];
            if ([title isEqualToString:@""]) {
                 cell.contentLabel.text = @"这里没有数据";
            }else{
            cell.contentLabel.text = title;
            }
            cell.array = @[];
        }
            break;
        case 3:
        {
            cell.titleLabel.text = @"商家地址";
            NSString *title=self.dataDict[@"seller_addr"];
            if ([title isEqualToString:@""]) {
                cell.contentLabel.text = @"这里没有数据";
            }else{
                cell.contentLabel.text = title;
            }
           
            cell.array = @[];
        }
            break;
        case 4:
        {
            cell.titleLabel.text = @"商家电话";
            NSString *title= self.dataDict[@"seller_phone"];
            if ([title isEqualToString:@""]) {
                cell.contentLabel.text = @"这里没有数据";
            }else{
                cell.contentLabel.text = title;
            }
            cell.array = @[];
        }
            break;
        case 5:
        {
            cell.titleLabel.text = @"送货时间";
            NSString *title= self.dataDict[@"delivery_time"];
            if ([title isEqualToString:@"-"]) {
                cell.contentLabel.text = @"这里没有数据";
            }else{
                cell.contentLabel.text = title;
            }

            cell.array = @[];
        }
            break;
        case 6:
        {
            cell.titleLabel.text = @"商家公告";
            NSString *title= self.dataDict[@"notice"];
            if ([title isEqualToString:@""]) {
                cell.contentLabel.text = @"这里没有数据";
            }else{
                cell.contentLabel.text = title;
            }
    
            cell.array = @[];
        }
            break;
        default:
            break;
    }
    
    return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    ShenghuoquanModel *model = self.dataArray[indexPath.row];
    //    self.hidesBottomBarWhenPushed = YES;
    //    LifeCycleDetailViewController *viewController = [LifeCycleDetailViewController new];
    //    viewController.zone_id = model.zone_id;
    //    [self.navigationController pushViewController:viewController animated:YES];
    //    self.hidesBottomBarWhenPushed = YES;
}
#pragma mark - Function

//实现方法
- (void)notification1:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.selectedCailiao = dic[@"data"];
    
    self.number = [dic[@"number"] integerValue];
    
    [self.cailiaodanTableview reloadData];
    [self.tableView reloadData];
}

#pragma mark – XibFunction
- (IBAction)gouwucheBtnClick:(id)sender {
    self.yixuanCailiaoView.frame = [DZTools getAppWindow].bounds;
    
    [[DZTools getAppWindow] addSubview:self.yixuanCailiaoView];
    
}
- (IBAction)shengchengOrderClick:(id)sender {
    
    GoodsSkuModel *model=self.selectedCailiao[0];
    NSDictionary *dict = model.selectsGoodsDict;
    NSDictionary *params = @{
                             @"goods_id": dict[@"goods_id"],
                             @"goods_num": @(model.number),
                             @"goods_sku_id":dict[@"goods_sku_id"]
                             };
    
    [DZNetworkingTool postWithUrl:kAddCart
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  
                                  self.selectedCailiao = nil;
                                  self.numberLabel.text = 0;
                                  [self.view layoutIfNeeded];
                                  [self.cailiaodanTableview reloadData];
                                   [[NSNotificationCenter defaultCenter] postNotificationName:@"cartXiaoxi" object:nil userInfo:dict];
                                  self.tabBarController.selectedIndex = 2;
                                  [self.navigationController popToRootViewControllerAnimated:NO];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                  
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                               
                           }
                        IsNeedHub:NO];
    //    [self.specArray removeAllObjects];
    [self.yixuanCailiaoView removeFromSuperview];
}
- (IBAction)cancelCailiaocheClick:(id)sender {
    [self.yixuanCailiaoView removeFromSuperview];
    
}
#pragma mark – 懒加载
- (void)setNumber:(NSInteger)number
{
    _number = number;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)_number];
    if (number == 0) {
        self.numberLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
    }
}

@end
