//
//  MyOrderDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BaojiadanDetailViewController.h"
#import "CaiLiaoDanDetailHeaderView.h"
#import "BaojiaDanDetailHeaderView.h"
#import "BlockAlertView.h"

#import "OederDetailModel.h"
#import "BaojiadanGoodsModel.h"

#import "BaoJiaDanCCell.h"
#import "MyOrderCell.h"
#import "FenleiBaojiaDanCell.h"
#import "GongZhongBaojiaDanCell.h"

#import "APAuthInfo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

#import "JieSuanViewController.h"
#import "CongxinBpViewController.h"
#import "ChatViewController.h"
#import "BaojiaDanDetailFooterView.h"

@interface BaojiadanDetailViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *HeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *startBgView;
@property (strong, nonatomic) IBOutlet UIView *FooterView;
@property (weak, nonatomic) IBOutlet UIView *zongjiBgView;
@property (weak, nonatomic) IBOutlet UIView *storeBgView;

@property (weak, nonatomic) IBOutlet UILabel *bendianBuyKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *bendianNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *bendianTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *daigouKindLabel;
@property (weak, nonatomic) IBOutlet UILabel *daigouNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *daigouTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangpinNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *allTotalLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangpinNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *headNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *headHaopingLabel;
@property (weak, nonatomic) IBOutlet UILabel *headBuyLabel;
@property (weak, nonatomic) IBOutlet UILabel *headPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *headJuliLabel;

@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;

@property (strong, nonatomic) NSDictionary *dataDic;

@property (strong, nonatomic) NSArray *dataArray;
@property (strong, nonatomic) NSMutableArray *bendianArray;
@property (strong, nonatomic) NSMutableArray *bendianMatchArray;
@property (strong, nonatomic) NSMutableArray *daigouArray;
@property (strong, nonatomic) NSMutableArray *budaigouArray;

@property (nonatomic, strong) NSString *bendianStr;
@property (nonatomic, strong) NSString *daigouStr;
@property (nonatomic, strong) NSString *wudaigouStr;
@property (nonatomic, strong) NSString *deliveryPrice;
@property (nonatomic, strong) NSString *taxesStr;
@property (nonatomic, strong) NSString *sellerId;
@property (nonatomic, strong) NSString *dataId;

@property (nonatomic, assign) float totalMoney;

@property (nonatomic, assign) int number;  //数量
@property (nonatomic, assign) int typeNum; //
@property (nonatomic, assign) int follow;
@property (nonatomic, assign) int phoneStr;
@property (nonatomic, assign) int daigouPrice;      //代购价格
@property (nonatomic, assign) int pipeitime;        //匹配时间
@property (nonatomic, assign) int bendiantime;      //本店时间
@property (nonatomic, assign) int daigoutime;       //代购时间
@property (nonatomic, assign) int bendian_data;     //本店数据
@property (nonatomic, assign) int bendian_matching; //本店匹配
@property (nonatomic, assign) int daigou;           //代购
@property (nonatomic, assign) int type;             //类型
@property (nonatomic, assign) int receiptId;        //报价单ID

@property (assign, nonatomic) BOOL iSHide1;  //1组隐藏
@property (assign, nonatomic) BOOL iSHide2;  //2组隐藏
@property (assign, nonatomic) BOOL iSHide3;  //3组隐藏
@property (assign, nonatomic) BOOL iSHide;   //4组隐藏
@property (nonatomic, assign) BOOL isFollew; //是否覆盖

@end

@implementation BaojiadanDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self initData];
    self.number = 0;
    self.typeNum = 0;
    self.totalMoney = 0;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"详情";

    self.sx = @"0";

    self.isFollew = NO;
    if (@available(iOS 11.0, *)) {
        self.detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.bendianArray = [NSMutableArray array];
    self.daigouArray = [NSMutableArray array];
    self.budaigouArray = [NSMutableArray array];
    self.bendianMatchArray = [NSMutableArray array];

    
    [self initStartView];
    self.daigou = 0;
    self.bendian_matching = 0;
    self.bendian_data = 0;
    [self initTableView];
    [self initCollectionView];
}
- (void)initStartView {
    self.starView = [[HYBStarEvaluationView alloc] initWithFrame:CGRectMake(0, 0, 90, 15) numberOfStars:5 isVariable:NO];
    self.starView.actualScore = 1;
    self.starView.fullScore = 5;
    self.starView.isContrainsHalfStar = YES;
    [self.startBgView addSubview:self.starView];
}
- (void)initCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(250, 100);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 5;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"BaoJiaDanCCell" bundle:nil] forCellWithReuseIdentifier:@"BaoJiaDanCCell"];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;

    [self.detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"FenleiBaojiaDanCell" bundle:nil] forCellReuseIdentifier:@"FenleiBaojiaDanCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"GongZhongBaojiaDanCell" bundle:nil] forCellReuseIdentifier:@"GongZhongBaojiaDanCell"];
}
- (void)initTableView {

    //阴影的颜色
    self.storeBgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.storeBgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.storeBgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.storeBgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.storeBgView.layer.cornerRadius = 5;
    //阴影的颜色
    self.zongjiBgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.zongjiBgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.zongjiBgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.zongjiBgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.zongjiBgView.layer.cornerRadius = 5;

    self.HeadView.frame = CGRectMake(0, 0, ViewWidth, 130);
    self.detailTableView.tableHeaderView = self.HeadView;
    self.FooterView.frame = CGRectMake(0, 0, ViewWidth, 190);
    self.detailTableView.tableFooterView = self.FooterView;
}

- (void)initData {

    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSDictionary *params = @{
        @"stuff_cart_id": @(self.receipt_id),
        @"seller_id": @(self.seller_id),
        @"lng": @(longitude),
        @"sx": self.sx,
        @"lat": @(latitude)
    };
    NSLog(@"======%@", params);
    [DZNetworkingTool postWithUrl:kReceiptDetail
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.dataDic = [NSDictionary dictionary];
                self.dataDic = responseObject[@"data"][@"receipt_data"];

                [self jiexiDataWithDict:self.dataDic];
               
                self.nameStr = self.dataDic[@"order_name"];
                self.receiptId = [self.dataDic[@"receipt_id"] intValue];
                NSDictionary *dict = responseObject[@"data"][@"receipt_data"][@"seller"];
                //                                  self.headImageView
                self.headNameLabel.text = dict[@"seller_name"];
                if ([dict[@"distance"] doubleValue] >= 1000) {
                    self.headJuliLabel.text = [NSString stringWithFormat:@"%.2fkm", [dict[@"distance"] doubleValue] / 1000];
                } else {
                    self.headJuliLabel.text = [NSString stringWithFormat:@"%.2fkm", [dict[@"distance"] doubleValue]];
                }

                self.headHaopingLabel.text = [NSString stringWithFormat:@"%.f%%好评", [dict[@"praise_degree"] floatValue]];
                self.phoneStr = [dict[@"seller_phone"] intValue];

                self.headBuyLabel.text = [NSString stringWithFormat:@"%@人已购买", dict[@"sales_figures"]];
                self.starView.actualScore = [dict[@"praise"] intValue];
//                NSDictionary *tempDict = responseObject[@"data"];
                self.headPriceLabel.text = [NSString stringWithFormat:@"%d", [self.dataDic[@"price"] intValue]];
                self.sellerId = self.dataDic[@"seller_id"];
//                self.bendianBuyKindLabel
                
                
                //                                  self.deliveryPrice=tempDict[@"delivery_price"];
                //
                //                                  self.bendianNumberLabel.text=[NSString stringWithFormat:@"数量:%@",tempDict[@"bd_number"]];
                //                                  self.bendianBuyKindLabel.text=[NSString stringWithFormat:@"本店购买商品种类：%@种",tempDict[@"bd_type"]];
                //                                  self.bendianTotalLabel.text=[NSString stringWithFormat:@"¥%@",tempDict[@"bd_price"]];
                //
                //
                //                                  self.daigouNumberLabel.text=[NSString stringWithFormat:@"数量:%@",tempDict[@"daigou_num"]];
                //                                  self.daigouKindLabel.text=[NSString stringWithFormat:@"代购购买商品种类：%@种",tempDict[@"daigou_type"]];
                //                                  self.daigouTotalLabel.text=[NSString stringWithFormat:@"¥%@",tempDict[@"daigou_price"]];
                //                                  self.shangpinNumberLabel.text= [NSString stringWithFormat:@"商品数量:%@",tempDict[@"sum"]];
                //                                  self.number=[tempDict[@"sum"] intValue];
                //                                  int type1=[tempDict[@"bd_type"]  intValue];
                //                                  int type2=[tempDict[@"daigou_type"] intValue];
                //                                  self.typeNum=type1+type2;
                //                                  self.allTotalLabel.text=[NSString stringWithFormat:@"¥%@",tempDict[@"price"]];
                //                                  self.totalMoney=tempDict[@"price"];
                //                                  self.bendianStr=tempDict[@"bd_price"];
                //                                  self.daigouStr=tempDict[@"daigou_price"];
                //                                  self.wudaigouStr=tempDict[@"price"];
                //                                  self.taxesStr=tempDict[@"taxes"];

              
                
                [self.detailTableView reloadData];
            } else {
                [self.bendianMatchArray removeAllObjects];
                [self.bendianArray removeAllObjects];
                [self.daigouArray removeAllObjects];
                [self.budaigouArray removeAllObjects];
                
                [self.detailTableView reloadData];
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

//数据解析
- (void)jiexiDataWithDict:(NSDictionary *)dict {
    self.dataArray = [NSArray array];
    NSDictionary *tempDict = @{};
    NSDictionary *tempDict1 = @{};
    NSDictionary *tempDict2 = @{};
    NSDictionary *tempDict3 = @{};
    
      [self.bendianMatchArray removeAllObjects];
      [self.bendianArray removeAllObjects];
      [self.daigouArray removeAllObjects];
      [self.budaigouArray removeAllObjects];

    for (NSDictionary *gongzhongDict in dict[@"bendian_matching_show"]) {
        
        if ([dict[@"bendian_matching_show"] count] == 0) {

        } else {

          
            BaojiadanGoodsModel *fenlei = [[BaojiadanGoodsModel alloc] init];
            fenlei.goods_name = gongzhongDict[@"stuff_category_name"];
            fenlei.type = 1;
            tempDict = dict[@"bendian_matching_count"];
            //            [tempArray addObject:tempDict];
            [self.bendianMatchArray addObject:fenlei];
            for (NSDictionary *goodsDict in gongzhongDict[@"data"]) {
                BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];
                goods.type = 0;
                [self.bendianMatchArray addObject:goods];
            }
        }
    }

    for (NSDictionary *gongzhongDict in dict[@"bendian_show"]) {
       
        if ([dict[@"bendian_show"] count] == 0) {

        } else {
           
            BaojiadanGoodsModel *fenlei = [[BaojiadanGoodsModel alloc] init];
            fenlei.goods_name = gongzhongDict[@"stuff_category_name"];
            fenlei.type = 1;
            tempDict1 = dict[@"bendian_data_count"];
            //            [tempArray addObject:tempDict1];
            [self.bendianArray addObject:fenlei];
            for (NSDictionary *goodsDict in gongzhongDict[@"data"]) {
                BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];

                goods.type = 0;
                [self.bendianArray addObject:goods];
            }
        }
    }
    for (NSDictionary *gongzhongDict in dict[@"daibgou_show"]) {

        BaojiadanGoodsModel *fenlei = [[BaojiadanGoodsModel alloc] init];
        fenlei.goods_name = gongzhongDict[@"stuff_category_name"];
        fenlei.type = 1;
       
        tempDict2 = dict[@"daigou_count"];

        [self.daigouArray addObject:fenlei];
        for (NSDictionary *goodsDict in gongzhongDict[@"data"]) {
            BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];
            goods.type = 0;
            [self.daigouArray addObject:goods];
        }
    }
    for (NSDictionary *gongzhongDict in dict[@"surplus_show"]) {

        BaojiadanGoodsModel *fenlei = [[BaojiadanGoodsModel alloc] init];
        fenlei.goods_name = gongzhongDict[@"stuff_category_name"];
        fenlei.type = 1;
       
        tempDict3 = dict[@"surplus_count"];

        [self.budaigouArray addObject:fenlei];
        for (NSDictionary *goodsDict in gongzhongDict[@"data"]) {
            BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];
            goods.goods_name = goods.seller_name;
            NSString *tempStr = @"";
            for (NSDictionary *dict in goods.stuff_spec) {
                tempStr = [tempStr stringByAppendingString:dict[@"name"]];
            }
            goods.stuff_spec_name = tempStr;
            goods.type = 0;
            [self.budaigouArray addObject:goods];
        }
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];

    if (self.bendianMatchArray.count != 0) {
        [array addObject:@{ @"array": self.bendianMatchArray,
                            @"title": @"完全匹配",
                            @"data": tempDict }];
    }
    if (self.bendianArray.count != 0) {
        [array addObject:@{ @"array": self.bendianArray,
                            @"title": @"品牌不匹配",
                            @"data": tempDict1 }];
    }

    if (self.daigouArray.count != 0) {
        [array addObject:@{ @"array": self.daigouArray,
                            @"title": @"本店缺货可代购",
                            @"data": tempDict2 }];
    }
    if (self.budaigouArray.count != 0) {
        [array addObject:@{ @"array": self.budaigouArray,
                            @"title": @"本店缺货不可代购",
                            @"data": tempDict3 }];
    }
    self.dataArray = array;
    [self.detailTableView reloadData];
    NSLog(@"----%@", self.dataArray);
}
#pragma mark--tableview deleteGate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    NSDictionary *dict = self.dataArray[section];
    if ([dict[@"title"] isEqualToString:@"完全匹配"]) {
        if (self.iSHide) {
            return 0;
        }
    }

    if ([dict[@"title"] isEqualToString:@"品牌不匹配"]) {
        if (self.iSHide1) {
            return 0;
        }
    }
    if ([dict[@"title"] isEqualToString:@"本店缺货可代购"]) {
        if (self.iSHide2) {
            return 0;
        }
    }
    if ([dict[@"title"] isEqualToString:@"本店缺货不可代购"]) {
        if (self.iSHide3) {
            return 0;
        }
    }
    NSArray *array = dict[@"array"];
    return array.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *array = dict[@"array"];
    BaojiadanGoodsModel *model = array[indexPath.row];
    if (model.type == 0) {
        return 91;
    } else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 200;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 70;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        ((UITableViewHeaderFooterView *) view).backgroundView.backgroundColor = [UIColor whiteColor];
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BaojiaDanDetailHeaderView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header"];
    if (!headV) {
        headV = [[BaojiaDanDetailHeaderView alloc] initWithReuseIdentifier:@"Header"];
    }

    NSDictionary *dict = self.dataArray[section];
    NSDictionary *temp = dict[@"data"];

    headV.headViewLabel.text = [NSString stringWithFormat:@"%@", dict[@"title"]];
    if ([temp[@"typenum"] intValue] == 0) {
        headV.zhongleiLabel.text = [NSString stringWithFormat:@"共计商品种类：0种"];
    } else {
        headV.zhongleiLabel.text = [NSString stringWithFormat:@"共计商品种类：%@种", temp[@"typenum"]];
    }

    if ([temp[@"num"] intValue] == 0) {
        headV.numberLabel.text = [NSString stringWithFormat:@"共计商品数量：0"];
    } else {
        headV.numberLabel.text = [NSString stringWithFormat:@"共计商品数量：%@", temp[@"num"]];
    }
    if ([temp[@"price"] intValue] == 0) {
        headV.priceLabel.text = [NSString stringWithFormat:@"共计商品总价：¥0"];
    } else {
        headV.priceLabel.text = [NSString stringWithFormat:@"共计商品总价：¥%@", temp[@"price"]];
    }

    if ([dict[@"title"] isEqualToString:@"完全匹配"]) {
        headV.priceLabel.hidden = NO;
        headV.shanglaBlock = ^{
            self.iSHide = !self.iSHide;
            [self.detailTableView reloadData];
        };
    }
    if ([dict[@"title"] isEqualToString:@"品牌不匹配"]) {
        headV.priceLabel.hidden = NO;
        headV.shanglaBlock = ^{
            self.iSHide1 = !self.iSHide1;
            [self.detailTableView reloadData];
        };
    }
    if ([dict[@"title"] isEqualToString:@"本店缺货可代购"]) {
         headV.priceLabel.hidden = NO;
        headV.shanglaBlock = ^{
            self.iSHide2 = !self.iSHide2;
            [self.detailTableView reloadData];
        };
    }
    if ([dict[@"title"] isEqualToString:@"本店缺货不可代购"]) {
         headV.priceLabel.hidden = YES;
        headV.shanglaBlock = ^{
            self.iSHide3 = !self.iSHide3;
            [self.detailTableView reloadData];
        };
    }

    return headV;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    BaojiaDanDetailFooterView *headV = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Footer"];
    if (!headV) {
        headV = [[BaojiaDanDetailFooterView alloc] initWithReuseIdentifier:@"Footer"];
    }
    headV.backgroundColor = [UIColor whiteColor];
    NSDictionary *dict = self.dataArray[section];
    NSDictionary *temp = dict[@"data"];

    __weak typeof(BaojiaDanDetailFooterView *) weakself = headV;
    
    if ([dict[@"title"] containsString:@"完全匹配"]) {
       
        headV.xiugaiBtn.hidden = YES;
        headV.chaidanBtn.hidden = YES;
        headV.sureBtn.hidden = NO;
      
        headV.sureBlock = ^(BOOL isSelect){
 
            if (isSelect) {
                [weakself.sureBtn setTitle:@"取消" forState:UIControlStateNormal];
             
                self.bendian_matching = 1;
              
                self.number += [temp[@"num"] intValue];
                self.typeNum += [temp[@"typenum"] intValue];
                self.totalMoney += [temp[@"price"] floatValue];
                [DZTools showText:@"已选中" delay:2];
             
            }else{
                [weakself.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
                self.bendian_matching = 0;
                
                self.number -= [temp[@"num"] intValue];
                self.typeNum -= [temp[@"typenum"] intValue];
                self.totalMoney -= [temp[@"price"] floatValue];
                [DZTools showText:@"已取消" delay:2];
            }            
            [self reloadFooterView];
        };
    } else if ([dict[@"title"] containsString:@"品牌不匹配"]) {
        headV.sureBtn.hidden = NO;
        headV.xiugaiBtn.hidden = NO;
        headV.chaidanBtn.hidden = NO;
        
        headV.sureBlock =  ^(BOOL isSelect){
            if (isSelect) {
                 [weakself.sureBtn setTitle:@"取消" forState:UIControlStateNormal];
                self.bendian_data = 1;
       
                self.number += [temp[@"num"] intValue];
                self.typeNum += [temp[@"typenum"] intValue];
                self.totalMoney += [temp[@"price"] floatValue];
                [DZTools showText:@"已选中" delay:2];
            
            }else{
                [weakself.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
                self.bendian_data = 0;
                
                self.number -= [temp[@"num"] intValue];
                self.typeNum -= [temp[@"typenum"] intValue];
                self.totalMoney -= [temp[@"price"] floatValue];
                [DZTools showText:@"已取消" delay:2];
                
            }
             [self reloadFooterView];
        };
        headV.chaidanBlock = ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定拆单？" preferredStyle:UIAlertControllerStyleAlert];
            
         
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *_Nonnull action){
                                                                     
                                                                     
                                                                 }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *_Nonnull action) {
                   self.type = 1;
                   [self demolitionOrder];
               }];

            [alertController addAction:sureAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
        };
        //修改
        headV.xiugaiBlock = ^{
            if (self.bendianArray.count > 0) {
                NSMutableArray *testArray = [NSMutableArray array];
                for (BaojiadanGoodsModel *goods in self.bendianArray) {
                    if (goods.data_id.length == 0) {
                        //                    return;
                    } else {
                        [testArray addObject:goods.data_id];
                    }
                }
                self.dataId = [testArray componentsJoinedByString:@","];
            }

            self.hidesBottomBarWhenPushed = YES;

            CongxinBpViewController *vc = [[CongxinBpViewController alloc] init];
            vc.data_id = self.dataId;
            vc.stuff_cart_id = [NSString stringWithFormat:@"%d", self.receipt_id];
            vc.isFromBaojiadan = YES;

            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = YES;

        };
    } else if ([dict[@"title"] containsString:@"本店缺货可代购"]) {
        headV.sureBtn.hidden = NO;
        headV.xiugaiBtn.hidden = YES;
        headV.chaidanBtn.hidden = NO;
        
        headV.sureBlock =  ^(BOOL isSelect){
            if (isSelect) {
                [weakself.sureBtn setTitle:@"取消" forState:UIControlStateNormal];
                self.daigou = 1;
                self.number += [temp[@"num"] intValue];
                self.typeNum += [temp[@"typenum"] intValue];
                self.totalMoney += [temp[@"price"] floatValue];
                [DZTools showText:@"已选中" delay:2];
                
            }else{
               [weakself.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
                self.daigou = 0;
                self.number -= [temp[@"num"] intValue];
                self.typeNum -= [temp[@"typenum"] intValue];
                self.totalMoney -= [temp[@"price"] floatValue];
                [DZTools showText:@"已取消" delay:2];
            }
     [self reloadFooterView];
        };

        headV.chaidanBlock = ^{
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定拆单？" preferredStyle:UIAlertControllerStyleAlert];
            
           
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *_Nonnull action){
                                                                     
                                                                 }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *_Nonnull action) {
               self.type = 2;
               [self demolitionOrder];
           }];
          
            
            [alertController addAction:sureAction];
            [alertController addAction:cancelAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
           
        };
    } else if ([dict[@"title"] containsString:@"本店缺货不可代购"]) {
        headV.sureBtn.hidden = YES;
        headV.xiugaiBtn.hidden = YES;
        headV.chaidanBtn.hidden = NO;
        headV.chaidanBlock = ^{
          
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否确定拆单？" preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *_Nonnull action){
                                                                     
                                                                 }];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是"
                                                                 style:UIAlertActionStyleDefault
                                                               handler:^(UIAlertAction *_Nonnull action) {
                   self.type = 3;
                   [self demolitionOrder];
               }];
            [alertController addAction:sureAction];
            [alertController addAction:cancelAction];
      
            [self presentViewController:alertController animated:YES completion:nil];
        };
    }
    return headV;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = self.dataArray[indexPath.section];
    NSArray *array = dict[@"array"];
    BaojiadanGoodsModel *model = array[indexPath.row];

    //    if (model.type == 2) {
    //        GongZhongBaojiaDanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GongZhongBaojiaDanCell"];
    //        cell.gongzhongLabel.text=model.goods_name;
    //        return cell;
    //    } else
    if (model.type == 1) {
        FenleiBaojiaDanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FenleiBaojiaDanCell"];
        cell.fenleiLabel.text = model.goods_name;

        return cell;
    } else {
        MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell"];
        cell.nameLabel.text = model.goods_name;
        cell.pinpaiLabel.text = model.stuff_brand_name;
        NSMutableArray *array = [NSMutableArray array];
        for (NSDictionary *dict in model.stuff_spec) {
            [array addObject:dict[@"name"]];
        }
        NSString *name = [array componentsJoinedByString:@" "];
        cell.xinghaoLabel.text = [NSString stringWithFormat:@"规格：%@", name];
        cell.numberLabel.text = [NSString stringWithFormat:@"数量：%d", model.number];
        if (model.goods_price.length == 0) {
            cell.onePriceLabel.text = [NSString stringWithFormat:@"¥0"];
            cell.allPriceLabel.text = [NSString stringWithFormat:@"¥0"];
        } else if ([model.goods_price isKindOfClass:[NSNull class]]) {
            cell.onePriceLabel.text = [NSString stringWithFormat:@"¥0"];
            cell.allPriceLabel.text = [NSString stringWithFormat:@"¥0"];
        } else {
            cell.onePriceLabel.text = [NSString stringWithFormat:@"¥%@", model.goods_price];
            cell.allPriceLabel.text = [NSString stringWithFormat:@"¥%d", model.con_price];
        }
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
    }
}
#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    BaoJiaDanCCell *cell = (BaoJiaDanCCell *) [collectionView dequeueReusableCellWithReuseIdentifier:@"BaoJiaDanCCell" forIndexPath:indexPath];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark - Function
-(void)reloadFooterView{
    
    self.bendianBuyKindLabel.text = [NSString stringWithFormat:@"共计商品种类：%d种", self.typeNum];
    self.shangpinNumLabel.text = [NSString stringWithFormat:@"共计商品数量：%d", self.number];
    
    self.daigouKindLabel.text = [NSString stringWithFormat:@"共计商品价格：¥%.2f", self.totalMoney];

    
}
- (void)demolitionOrder {

    NSDictionary *params = @{
        @"receipt_id": @(self.receiptId),
        @"type": @(self.type)
    };
    [DZNetworkingTool postWithUrl:kDemolitionOrder
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                    //拆单弹窗
                    NSString *name = [NSString stringWithFormat:@"%@", responseObject[@"data"][@"name"]];
                    NSString *message = [NSString stringWithFormat:@"已经为拆单重新命名：\n\n%@\n\n您可以在材料单中找到它", name];

                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil
                                                                                             message:message
                                                                                      preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定"
                                                                         style:UIAlertActionStyleDefault
                                                                       handler:^(UIAlertAction *_Nonnull action) {
                  if ([responseObject[@"data"][@"status"] intValue] == 0) {
                   self.tabBarController.selectedIndex = 3;
                   [self.navigationController popToRootViewControllerAnimated:NO];
                  }else{
               //拆单之后刷新页面
                   [self initData];
                   [self.detailTableView layoutIfNeeded];
                  }
                                                                           
                    }];
                

                    [alertController addAction:sureAction];

                    [self presentViewController:alertController animated:YES completion:nil];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//head的点击事件
- (IBAction)callBtnClick:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%d", self.phoneStr];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:
                     [NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
- (IBAction)onlineBtnClick:(id)sender {
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
                      //会话列表
                      ChatViewController *conversationVC = [[ChatViewController alloc] init];
                      conversationVC.hidesBottomBarWhenPushed = YES;
                      conversationVC.conversationType = ConversationType_PRIVATE;
                      conversationVC.targetId = [NSString stringWithFormat:@"%d", self.seller_id];
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
- (IBAction)dianzanBtnClick:(id)sender {
    self.guanzhuBtn.selected = !self.guanzhuBtn.selected;
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
                    NSDictionary *dict = responseObject[@"data"];
                    self.follow = [dict[@"follow_id"] intValue];
                    self.isFollew = YES;
                } else {
                    [DZTools showText:responseObject[@"msg"] delay:2];
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
                    [DZTools showText:responseObject[@"msg"] delay:2];
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

//立即购买
- (IBAction)buyNowClick:(id)sender {
    //    BlockAlertView *alertView=[[BlockAlertView alloc]initWithdelegate:self];
    //    [alertView show];

    if ((self.bendian_data == 0) && (self.bendian_matching == 0) && (self.daigou == 0)) {
        [DZTools showNOHud:@"您没有选中材料" delay:2];
        return;
    } else {
        self.hidesBottomBarWhenPushed = YES;
        JieSuanViewController *viewController = [JieSuanViewController new];
        viewController.isFromCart = NO;
        viewController.dataDict = @{
            @"dianpuName": self.headNameLabel.text,
            @"cailiaodanName": self.nameStr,
            @"number": @(self.number),
            @"typeNumber": @(self.typeNum),
            @"totalMoney": @(self.totalMoney),
            @"receipt_id": @(self.receiptId),
            @"bendian_matching": @(self.bendian_matching),
            @"bendian_data": @(self.bendian_data),
            @"daigou": @(self.daigou),
            @"seller_id": @(self.seller_id)
        };
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    
    }
}

@end



