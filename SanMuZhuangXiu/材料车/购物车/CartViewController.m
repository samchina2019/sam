//
//  CartViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/19.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "CartViewController.h"
#import "CartListCell.h"
#import "WebViewViewController.h"
#import "JieSuanViewController.h"
#import "SectionView.h"
#import "CartGoodListModel.h"
#import "AddressModel.h"
#import "CartSellerModel.h"
#import "CartJiesuanViewController.h"


@interface CartViewController () <CLLocationManagerDelegate>
// 定位管理器
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectAllBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalMoneyLabel;

@property (nonatomic, strong) SectionView *sectionView;

@property (nonatomic, assign) float money;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int sellerId;
@property (nonatomic) NSInteger page;
@property (nonatomic, assign) int typeNumber;
@property (nonatomic, assign) float totalMoney;
@property (nonatomic, assign) float express_price;
@property (nonatomic, assign) float taxes;
@property (nonatomic, assign) int coupon;

@property (nonatomic, assign) BOOL isExist;//是否存在
@property (nonatomic, assign) BOOL isSelectAll;//全选

@property (nonatomic, strong) NSString *nameStr;

@property (nonatomic, strong) NSMutableArray *cartArray;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectedCellArray;
@end

@implementation CartViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
    
    self.isSelectAll = NO;
    self.selectAllBtn.selected = NO;
    
    [self.cartArray removeAllObjects];
    self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥0.00"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.cartArray = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.selectedCellArray = [NSMutableArray array];
    self.sectionArray = [NSMutableArray array];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        NSLog(@"上拉加载更多");
    //        [self loadMore];
    //    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"CartListCell" bundle:nil] forCellReuseIdentifier:@"CartListCell"];
    [self.tableView.mj_header beginRefreshing];
}
#pragma mark – Network

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {

    [DZNetworkingTool postWithUrl:kGetlists
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"][@"cart"];

                if (isRefresh) {
                    [self.sectionArray removeAllObjects];
                }
                NSDictionary *addDict = dict[@"address"];

                AddressModel *model = [AddressModel mj_objectWithKeyValues:addDict];
                [self.addressArray addObject:model];
                [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@", model.Area[@"city"], model.Area[@"province"], model.Area[@"region"], model.detail] forState:UIControlStateNormal];

                NSArray *array = dict[@"goods_list"];
                for (NSDictionary *dict in array) {
                    CartSellerModel *model = [CartSellerModel mj_objectWithKeyValues:dict];
                    [self.sectionArray addObject:model];
                }
                [self.tableView reloadData];

                self.number = [dict[@"cart_total_num"] intValue];
                self.totalMoney = [dict[@"cart_total_price"] floatValue];
                self.express_price = [dict[@"express_price"] floatValue];
                self.taxes = [dict[@"taxes"] floatValue];

                self.coupon = [dict[@"coupon"] intValue];
                self.isExist = dict[@"coupon"];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.sectionArray.count == 0) {
        self.bottomView.hidden = YES;
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.bottomView.hidden = NO;
        self.tableView.backgroundView = nil;
    }
    return self.sectionArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    CartSellerModel *model = self.sectionArray[section];
    NSArray *array = model.data;
    self.typeNumber = (int) array.count;
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 150;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CartSellerModel *model = self.sectionArray[section];
    self.sectionView = [[SectionView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
    self.sectionView.sectionNameLabel.text = [NSString stringWithFormat:@"%@", model.seller_name];
    self.sectionView.sectionNumberLabel.text = [NSString stringWithFormat:@"店铺优惠%d", model.seller_coupon];

    self.sellerId = model.seller_id;
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CartSellerModel *model = self.sectionArray[indexPath.section];

    CartListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CartListCell" forIndexPath:indexPath];
    cell.guigeLabel.hidden = NO;
    NSArray *array = model.data;
    NSDictionary *temp = array[indexPath.row];
    CartGoodListModel *dict = [CartGoodListModel mj_objectWithKeyValues:temp];
    self.nameStr = dict.goods_name;
    [cell.iconImgV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", dict.images]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    cell.nameLabel.text = dict.goods_name;
    cell.moneyLabel.text = [NSString stringWithFormat:@"¥%@", dict.goods_price];
    cell.guigeLabel.text = [NSString stringWithFormat:@"品牌：%@ 规格：%@",dict.stuff_brand_name,dict.stuff_spec_name];
    cell.ppNumberButton.currentNumber = dict.total_num;
    cell.ppNumberButton.editing = NO;

    if (self.isSelectAll) {
      self.money = 0;
        cell.selectBtn.selected = YES;
        for ( CartSellerModel *model in self.sectionArray) {
            for (NSDictionary *dict in model.data) {
                self.money += [dict[@"goods_price"] floatValue]*[dict[@"total_num"] intValue];
            }
        }

        self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", self.money];
    } else {
        cell.selectBtn.selected = NO;
        self.money = 0;
        self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", self.money];
    }
    //    __weak typeof( CartListCell *) weakSelf = cell;
    cell.resultBlock = ^(NSInteger number, BOOL increaseStatus) {
        if (increaseStatus == YES) {
            [self addCartWithNumber:1 AddModel:dict];
        } else {
            //
            [self subCartWithNumber:1 addModel:dict];
        }

    };

    cell.selectBlock = ^(BOOL isSelected) {
        if (isSelected) {
            [self.selectedCellArray addObject:dict];
            [self.cartArray addObject:dict.cart_id];
            self.money += dict.total_num * [dict.goods_price floatValue];

        } else {
             [self.selectedCellArray removeObject:dict];
            [self.cartArray removeObject:dict.cart_id];
            self.money -= dict.total_num * [dict.goods_price floatValue];
           
        }

        self.totalMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", self.money];
    };

    return cell;
}
#pragma mark - Function

- (void)subCartWithNumber:(NSInteger)number addModel:(CartGoodListModel *)dict {
    //
    NSDictionary *temp = @{
        //        @"goods_id": @(dict.goods_id),
        //        @"goods_num": @(number),
        @"cart_id": dict.cart_id
    };

    [DZNetworkingTool postWithUrl:kSubCart
        params:temp
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [self refresh];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"cartXiaoxi" object:nil userInfo:nil];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
- (void)addCartWithNumber:(NSInteger)number AddModel:(CartGoodListModel *)dict {

    NSDictionary *temp = @{
        //        @"goods_id": @(dict.goods_id),
        //        @"goods_num": @(number),
        @"cart_id": dict.cart_id
    };

    [DZNetworkingTool postWithUrl:kAddnumCart
        params:temp
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [self refresh];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"cartXiaoxi" object:nil userInfo:nil];
//                [self.tableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}


#pragma mark - XibFunction
//结算
- (IBAction)jiesuanBtnClicked:(id)sender {

    if (self.cartArray.count == 0) {
        [DZTools showNOHud:@"请选择商品后再结算" delay:2];
        return;
    } else {
        self.parentViewController.parentViewController.hidesBottomBarWhenPushed = YES;

        CartJiesuanViewController *viewController = [[CartJiesuanViewController alloc] init];
        viewController.cartIdArray = self.cartArray;
        viewController.isSelectAll = self.isSelectAll;
        [self.navigationController pushViewController:viewController animated:YES];
        
        self.parentViewController.parentViewController.hidesBottomBarWhenPushed = NO;
        
    }
    
}
//全选
- (IBAction)selectAllBtnClicked:(id)sender {
    self.selectAllBtn.selected = !self.selectAllBtn.selected;
    [self.cartArray removeAllObjects];
    [self.selectedCellArray removeAllObjects];
    if (self.selectAllBtn.selected) {
        self.isSelectAll = YES;
        for (CartSellerModel *model in self.sectionArray) {
            NSArray *array = model.data;
            
            for (NSDictionary *dict in array) {
                [self.cartArray addObject:dict[@"cart_id"]];
                CartGoodListModel *temp = [CartGoodListModel mj_objectWithKeyValues:dict];
                [self.selectedCellArray addObject:temp];
            }
        }

    } else {
        self.isSelectAll = NO;
        [self.cartArray removeAllObjects];
        [self.selectedCellArray removeAllObjects];
    }

    [self.tableView reloadData];
}
//删除
- (IBAction)deleteBtnClicked:(id)sender {
    
    if (self.selectedCellArray.count == 0) {
        [DZTools showNOHud:@"请选择商品后再删除" delay:2];
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除购车里的商品吗？" preferredStyle:UIAlertControllerStyleAlert];
    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                               style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction *_Nonnull action){

                                             }]];
    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                               style:UIAlertActionStyleCancel
                                             handler:^(UIAlertAction *_Nonnull action) {

       
         NSMutableArray *tempArray = [NSMutableArray arrayWithCapacity:0];
      for (int i = 0; i < self.selectedCellArray.count; i++) {
             CartGoodListModel *model = self.selectedCellArray[i];
              [tempArray addObject:model.cart_id];
           }
               NSString *tempString = [tempArray componentsJoinedByString:@","];
                NSDictionary *dict = @{
                         @"cart_ids": tempString
                 };
                 [DZNetworkingTool postWithUrl:kGoodsDelete
                     params:dict
                     success:^(NSURLSessionDataTask *task, id responseObject) {
                         if ([responseObject[@"code"] intValue] == SUCCESS) {
                             [self.selectedCellArray removeAllObjects];
                             [DZTools showOKHud:responseObject[@"msg"] delay:2];
                             [self refresh];
                         } else {
                             [DZTools showNOHud:responseObject[@"msg"] delay:2];
                         }
                     }
                     failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                         [DZTools showNOHud:RequestServerError delay:2.0];
                     }
                     IsNeedHub:NO];

             }]];
    [self presentViewController:alertC animated:YES completion:nil];
}



@end
