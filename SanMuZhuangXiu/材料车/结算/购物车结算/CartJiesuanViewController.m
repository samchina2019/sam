//
//  CartJiesuanViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CartJiesuanViewController.h"
#import "ReLayoutButton.h"
#import "AddressModel.h"
#import "AddressManagerViewController.h"
#import "MyOrderPageViewController.h"
#import "ChangePasswordViewController.h"
#import "JiesuanTableViewCell.h"
#import "CartSellerModel.h"
#import "CouponModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface CartJiesuanViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *lijizhifuBtn;
@property (weak, nonatomic) IBOutlet UILabel *hejiLabel;
@property (strong, nonatomic) IBOutlet UIView *headView;

@property (weak, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//配送view
@property (weak, nonatomic) IBOutlet UIView *peisongView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *peisongTimeBtn;

@property (weak, nonatomic) IBOutlet UIView *payView;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *fapiaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *fapiaoTypeLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jifenBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (strong, nonatomic) IBOutlet UIView *zhifuStyleView;
@property (strong, nonatomic) IBOutlet UIView *fapiaoView;
@property (weak, nonatomic) IBOutlet UILabel *fapiaoXianshilabel;
@property (weak, nonatomic) IBOutlet UILabel *zhifuMoneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *yueBtn;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *youfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuijinLabel;
@property (weak, nonatomic) IBOutlet UIView *fapiaoTaitouView;
@property (weak, nonatomic) IBOutlet UIView *fapiaoNeirongView;
@property (weak, nonatomic) IBOutlet UILabel *suiqianMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *allMoneyLabel;
@property (weak, nonatomic) IBOutlet UIView *suiqianView;
@property (weak, nonatomic) IBOutlet UIButton *zengzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *kaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *bukaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *gerenBtn;
@property (weak, nonatomic) IBOutlet UIButton *danweiBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutFaPiaoViewheigth;
@property (weak, nonatomic) IBOutlet UITextField *danweiNameTF;
@property (weak, nonatomic) IBOutlet UITextField *danweishuihaoTF;
@property (weak, nonatomic) IBOutlet UIButton *zhifubaoBtn;

@property (nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign) int isSure;
@property (nonatomic, assign) BOOL isJifen;
@property (nonatomic, assign) float youhuiMoney;
@property (nonatomic, assign) double yunfeimodey;
@property (nonatomic, assign) double shuijinMoney;
@property (nonatomic, assign) double totalMoney;
@property (nonatomic, assign) float shuiJin;
@property (nonatomic, assign) float puShui;
@property (nonatomic, assign) float zengShui;
@property (nonatomic, assign) double price;
@property (nonatomic, assign) int seller_id;
@property (nonatomic, assign) int addressId;
@property (nonatomic, assign) double jifen;
@property (nonatomic, assign) double user_score;
@property (nonatomic, assign) int page;

@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic, strong) NSString *invoice;
@property (strong, nonatomic) NSString *orderNo;

@property (nonatomic, strong) NSArray *timeArray;
@property (nonatomic, strong) NSMutableArray *fapiaoArray;
@property (nonatomic, strong) NSDictionary *fapiaoDict;
@property (nonatomic, strong) NSMutableArray *youhuiArray;
@property (nonatomic, strong) NSMutableArray *invoice_info;
@property (nonatomic, strong) NSMutableArray *integra;
@property (nonatomic, strong) NSMutableArray *coupon_info;
@property (nonatomic, strong) NSMutableArray *moneyArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *addressArray;
@property (nonatomic, strong) NSMutableArray *selectTempArray;

@property (nonatomic, strong) JiesuanTableViewCell *selectCell;

@end

@implementation CartJiesuanViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DZTools islogin]) {
//        [self initJifen];
        [self initMyFapiaoDetail];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"结算";

    [self initView];
    self.jifenBtn.selected = NO;
    self.jifenLabel.text = @"¥0";
    self.invoice = @"1";
    self.timeArray = @[
        @"周一至周五收货",
        @"收货时间不限",
        @"周六日/节假日收货",
    ];
    [self.peisongTimeBtn setTitle:self.timeArray[0] forState:UIControlStateNormal];
    self.coupon_info = [NSMutableArray array];
    self.invoice_info = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.youhuiArray = [NSMutableArray array];
    self.addressArray = [NSMutableArray array];
    self.fapiaoDict = [NSDictionary dictionary];
    self.moneyArray = [NSMutableArray array];
    self.integra = [NSMutableArray array];
    self.selectTempArray = [NSMutableArray array];

    [self initTableView];
}
#pragma mark – UI

- (void)initView {
    //阴影
    self.addressView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.addressView.layer.shadowOpacity = 0.5f;
    self.addressView.layer.shadowRadius = 3.f;
    self.addressView.layer.shadowOffset = CGSizeMake(0, 0);
    self.addressView.layer.cornerRadius = 5;

    self.peisongView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.peisongView.layer.shadowOpacity = 0.5f;
    self.peisongView.layer.shadowRadius = 3.f;
    self.peisongView.layer.shadowOffset = CGSizeMake(0, 0);
    self.peisongView.layer.cornerRadius = 5;

    self.payView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.payView.layer.shadowOpacity = 0.5f;
    self.payView.layer.shadowRadius = 3.f;
    self.payView.layer.shadowOffset = CGSizeMake(0, 0);
    self.payView.layer.cornerRadius = 5;
}
- (void)initTableView {

    self.headView.frame = CGRectMake(0, 0, ViewWidth, 170);
    self.tableView.tableHeaderView = self.headView;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        NSLog(@"上拉加载更多");
    //        [self loadMore];
    //    }];

    //    [self loadYouhuiquan];
    [self.tableView registerNib:[UINib nibWithNibName:@"JiesuanTableViewCell" bundle:nil] forCellReuseIdentifier:@"JiesuanTableViewCell"];
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
- (void)initMyFapiaoDetail {
    [DZNetworkingTool postWithUrl:kMyInvoice
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.danweiNameTF.text = [NSString stringWithFormat:@"%@", dict[@"invoice_company"]];
                self.danweishuihaoTF.text = [NSString stringWithFormat:@"%@", dict[@"duty_paragraph"]];

            } else {
                //            [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSString *cartId = [self.cartIdArray componentsJoinedByString:@","];
    NSDictionary *dict = @{};
    if (self.addressId == 0) {
        if (self.isSelectAll) {
            dict = @{
                @"cartId": cartId,
            };
        } else {
            dict = @{
                @"cart_id": cartId,
            };
        }
    } else {
        if (self.isSelectAll) {
            dict = @{
                @"cartId": cartId,
                @"address_id": @(self.addressId)
            };
        } else {
            dict = @{
                @"cart_id": cartId,
                @"address_id": @(self.addressId)
            };
        }
    }
    [DZNetworkingTool postWithUrl:kCartGetinfo
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_footer.isRefreshing) {
                [self.tableView.mj_footer endRefreshing];
            }
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
               
                NSDictionary *dict = responseObject[@"data"][@"cart"];

                self.yunfeimodey = [dict[@"express_price"] doubleValue];
                self.youhuiMoney = [dict[@"coupon"] doubleValue];
                self.shuiJin = [dict[@"taxes"] doubleValue];
                self.user_score = [dict[@"user_score"] doubleValue];
                NSDictionary *addDict = dict[@"address"];
                AddressModel *model = [AddressModel mj_objectWithKeyValues:addDict];
                 //判断字典中是否有值
                if([[addDict allKeys] containsObject:@"address_id"]){
                    self.nameLabel.text = [NSString stringWithFormat:@"收件人:%@", model.name];
                    self.phoneLabel.text = model.phone;
                    self.addressId = model.address_id;
                    self.addressLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
                  
                } else {
                    self.nameLabel.text = @"";
                    self.phoneLabel.text = @"";
                    self.addressLabel.text = @"请选择地址";
                }
                NSArray *goodsArray = dict[@"goods_list"];
                for (NSDictionary *temp in goodsArray) {
                    CartSellerModel *model = [CartSellerModel mj_objectWithKeyValues:temp];
                    [self.dataArray addObject:model];
                }
                self.totalMoney = 0;
                self.totalMoney = [dict[@"cart_total_price"] doubleValue];
//                //计算总价格
//                for (CartSellerModel *model  in self.dataArray) {
//                    for (NSDictionary *dict in model.data) {
//                        self.totalMoney += [dict[@"goods_price"] floatValue]*[dict[@"total_num"] intValue];
//                    }
//                }
                //支付金额初始值
                self.hejiLabel.text = [NSString stringWithFormat:@"¥%.2f", self.totalMoney + self.yunfeimodey + self.shuiJin -self.youhuiMoney];
                self.zhifuMoneyLabel.text = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", self.totalMoney + self.yunfeimodey + self.shuiJin - self.youhuiMoney];
                
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

#pragma mark--tableview deleteGate
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
    CartSellerModel *model = self.dataArray[indexPath.row];
    NSArray *goodsArray = model.data;
    return 310 + goodsArray.count * 110;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    JiesuanTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JiesuanTableViewCell" forIndexPath:indexPath];
    CartSellerModel *model = self.dataArray[indexPath.row];

    cell.model = model;
    cell.yunfeiLabel.text = [NSString stringWithFormat:@"¥%.2f", model.express_price];
    cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.seller_name];
    //积分信息
    double jifenMoney = 0;
    jifenMoney = model.seller_price * [model.score_deduction doubleValue];
       __weak typeof(JiesuanTableViewCell *) weakself = cell;
    if ([model.score_deduction_if intValue] == 0) {
        cell.jifenBtn.userInteractionEnabled = NO;
        [cell.jifenBtn setTitle:@"该店铺不可使用积分" forState:UIControlStateNormal];
        model.yongJifen = 0;
        cell.jifenLabel.text = @"0";
        NSDictionary * dict = @{
                                @"seller_id": @(model.seller_id),
                                @"integra" : @(0)
                                };
        model.selectInvoce = dict;
        [self.integra addObject:dict];

    }else if ([model.score_deduction_if intValue] == 1){
        [cell.jifenBtn setTitle:[NSString stringWithFormat:@"我的积分%.f,可用积分%.f,可抵%.f元", self.user_score,jifenMoney*10,jifenMoney] forState:UIControlStateNormal];
        cell.jifenBtn.userInteractionEnabled = YES;
        cell.jifenBlock = ^(BOOL isSelect) {//积分的点击事件
            if (isSelect) {
                model.yongJifen =jifenMoney;
                weakself.jifenLabel.text = [NSString stringWithFormat:@"%.f",jifenMoney];
                NSDictionary * dict = @{
                                        @"seller_id": @(model.seller_id),
                                        @"integra" : @(1)
                                        };
                model.selectInvoce = dict;
                 [self.integra addObject:dict];
            }else{
                model.yongJifen = 0 ;
                weakself.jifenLabel.text = @"0";
                NSDictionary * dict = @{
                                        @"seller_id": @(model.seller_id),
                                        @"integra" : @(0)
                                        };
                model.selectInvoce = dict;
            [self.integra removeLastObject];
            [self.integra addObject:dict];
            }
            [self initMoneyView];
        };
    }
    //优惠券信息
    if (model.coupons.count == 0) {
        cell.youhuiquanLabel.text = [NSString stringWithFormat:@"¥0"];
        [cell.youhuiquanBtn setTitle:@"暂无优惠券" forState:UIControlStateNormal];
    }
    //发票信息
    NSDictionary *dict = model.invoice;
    if ([dict[@"invoice_type"] intValue] == 0) {
        cell.fapiaoBtn.userInteractionEnabled = NO;
        [weakself.fapiaoBtn setTitle:@"暂无发票" forState:UIControlStateNormal];
        weakself.shuijinLabel.text = @"¥0";
        NSDictionary *dict = @{
            @"invoice_type": @(0),
            @"seller_id": @(model.seller_id),
        };
        model.selectInvoce = dict;
        [self.invoice_info addObject:dict];
    } else {

        cell.fapiaoBtn.userInteractionEnabled = YES;
        self.zengShui = [dict[@"taxes"] floatValue];
        self.puShui = [dict[@"taxes_increment"] floatValue];
        cell.fapiaoBlock = ^{//发票的添加
            self.selectCell = weakself;
            self.seller_id = model.seller_id;
            self.index = indexPath;

            self.fapiaoView.frame = [DZTools getAppWindow].bounds;
            [[DZTools getAppWindow] addSubview:self.fapiaoView];

        };
    }
    cell.youhuiquanBlock = ^{//优惠券的点击事件
        [self.youhuiArray removeAllObjects];
        //        self.youhuiMoney = model.seller_pay_price;
        self.seller_id = model.seller_id;
        self.index = indexPath;
        if (model.coupons.count == 0) {
        } else {
            for (NSDictionary *dict in model.coupons) {
                CouponModel *typeModel = [CouponModel mj_objectWithKeyValues:dict];
                [self.youhuiArray addObject:typeModel];
            }
        }
        if (self.youhuiArray.count > 0) {
            [self alertYouhuiViewWithCell:weakself];
            model.couponMoney = self.youhuiMoney;
        } else {
            [weakself.youhuiquanBtn setTitle:@"暂无优惠券" forState:UIControlStateNormal];
        }
        [self initMoneyView];
    };
 
    float sellerMoney = 0;
    for (NSDictionary *dict in model.data) {
        sellerMoney += [dict[@"goods_price"] floatValue] * [dict[@"total_num"] intValue];
    }
    cell.totalPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", sellerMoney + model.express_price - model.coupon + model.seller_taxes];

    return cell;
}

#pragma mark - Function
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

                    if ([model.isdefault isEqualToString:@"1"]) {
                        self.nameLabel.text = [NSString stringWithFormat:@"收件人:%@", model.name];
                        self.phoneLabel.text = model.phone;
                        self.addressId = model.address_id;
                        self.addressLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
                    }
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
//jifen
- (void)initJifen {

    [DZNetworkingTool postWithUrl:kIntegral
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                self.jifen = [dict[@"score"] floatValue];
                [self.jifenBtn setTitle:[NSString stringWithFormat:@"可用积分%.f，可抵%.f元", self.jifen, self.jifen / 10] forState:UIControlStateNormal];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark-- 刷新价格
- (void)initMoneyView {
    self.hejiLabel.text = @"¥0";
    self.zhifuMoneyLabel.text = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥0元"];
    double shui = 0;
    double youhui = 0;

    for (CartSellerModel *model in self.selectTempArray) {
        shui += model.taxes;
        youhui += model.couponMoney;
    }
    double jifenTotal = 0;
    for (CartSellerModel *model in self.dataArray) {
        jifenTotal += model.yongJifen;
    }
    self.hejiLabel.text = [NSString stringWithFormat:@"¥%.2f", self.totalMoney - youhui + shui + self.yunfeimodey - jifenTotal];
    self.zhifuMoneyLabel.text = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", self.totalMoney - youhui + shui + self.yunfeimodey - jifenTotal];
  
}
//支付
- (void)zhifuWithpassword:(NSString *)password {
    //
    NSDictionary *params = @{
        @"pay_type": @"money",
        @"order_no": self.orderNo,
        @"pay_password": password

    };
    [DZNetworkingTool postWithUrl:kOrderPay
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                self.totalLabel.text = @"0.00";
                [self.view layoutIfNeeded];
                self.tabBarController.selectedIndex = 3;

                [self.navigationController popToRootViewControllerAnimated:YES];

            }else if([responseObject[@"code"] intValue] == 2){
                self.tabBarController.selectedIndex = 3;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
            } else {
                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                NSString *mima = responseObject[@"msg"];
                if ([mima containsString:@"请先设置支付密码"]) {
                    //设置支付密码
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置支付密码，无法支付。是否现在去设置支付密码？" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         //跳转到设置支付密码界面
                                                                         ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] init];
                                                                         vc.segmentTitleView.selectIndex = 1;
                                                                         vc.phoneStr = [User getUser].mobile;
                                                                         [self.navigationController pushViewController:vc animated:YES];
                                                                     }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *_Nonnull action){

                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:nil];

                } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    self.hidesBottomBarWhenPushed = YES;
                    MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                    viewController.selectIndex = 1;
                    self.totalLabel.text = @"0.00";
                    [self.view layoutIfNeeded];
                    [self.navigationController pushViewController:viewController animated:YES];
                    self.hidesBottomBarWhenPushed = YES;
                }
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

- (void)alertYouhuiViewWithCell:(JiesuanTableViewCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择优惠券" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.youhuiArray.count; i++) {
        CouponModel *typeModel = self.youhuiArray[i];

        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"满%@减%@", typeModel.threshold, typeModel.money]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXinziClick:i toCell:cell];
                                                }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertXinziClick:self.youhuiArray.count toCell:cell];

                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertXinziClick:(NSInteger)rowInteger toCell:(JiesuanTableViewCell *)cell {
    [cell.youhuiquanBtn setTitle:@"" forState:UIControlStateNormal];
    [self.coupon_info removeAllObjects];
    
    if (rowInteger < self.youhuiArray.count) {

        CouponModel *typeModel = self.youhuiArray[rowInteger];

        [cell.youhuiquanBtn setTitle:[NSString stringWithFormat:@"满%@减%@", typeModel.threshold, typeModel.money] forState:UIControlStateNormal];
        

        CartSellerModel *model = self.dataArray[self.index.row];
        cell.youhuiquanLabel.text = [NSString stringWithFormat:@"¥%@", typeModel.money];
        self.youhuiMoney = [typeModel.money floatValue];

        NSDictionary *dict = @{
            @"seller_id": @(model.seller_id),
            @"coupon_id": @(typeModel.coupon_id)
        };
        [self.coupon_info addObject:dict];
        model.couponMoney = [typeModel.money doubleValue];
        for (int i = 0; i < self.selectTempArray.count; i++) {
            CartSellerModel *temp = self.selectTempArray[i];
            if (temp.seller_id == model.seller_id) {

                [self.selectTempArray replaceObjectAtIndex:i withObject:model];
            }
        }
          [self initMoneyView];
    }else if (rowInteger == self.youhuiArray.count){
//        CouponModel *typeModel = self.youhuiArray[rowInteger];
        
        [cell.youhuiquanBtn setTitle:@"请选择优惠券" forState:UIControlStateNormal];
         [self initMoneyView];
    }
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertTimeClick:(NSInteger)intex {
    if (intex < self.timeArray.count) {

        [self.peisongTimeBtn setTitle:self.timeArray[intex] forState:UIControlStateNormal];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)zhifubaoPayWithDict:(NSDictionary *)dict {
    [DZNetworkingTool postWithUrl:kOrderPay
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.tabBarController.selectedIndex = 3;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [[AlipaySDK defaultService] payOrder:responseObject[@"data"]
                                          fromScheme:@"SanMuZhuangXiu"
                                            callback:^(NSDictionary *resultDic) {
                                                NSLog(@"-------%@", resultDic);
                                            }];
            } else if([responseObject[@"code"] intValue] == 2){
                self.tabBarController.selectedIndex = 3;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
            } else{
                self.hidesBottomBarWhenPushed = YES;
                MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                viewController.selectIndex = 1;
                self.totalLabel.text = @"0.00";
                [self.view layoutIfNeeded];
                [self.navigationController pushViewController:viewController animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

#pragma mark--XibFunction
- (IBAction)addressBtnClick:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
    vc.block = ^(AddressModel *_Nonnull model) {
        self.nameLabel.text = [NSString stringWithFormat:@"收件人:%@", model.name];
        self.phoneLabel.text = model.phone;
        self.addressId = model.address_id;
        self.addressLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        [self refresh];

    };
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

//发票抬头
- (IBAction)fapiaotaitouBtnClicked:(UIButton *)sender {
    sender.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
    sender.backgroundColor = UIColorWithRGB(63, 174, 233, 0.1);
    sender.selected = NO;
    if (sender == self.gerenBtn) {
        self.isSelect = YES;
        self.danweiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.danweiBtn.backgroundColor = [UIColor whiteColor];
        self.layOutFaPiaoViewheigth.constant = 80;
        self.danweiBtn.selected = NO;
    } else {
        self.isSelect = NO;
        self.gerenBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.gerenBtn.backgroundColor = [UIColor whiteColor];
        self.layOutFaPiaoViewheigth.constant = 160;
        self.gerenBtn.selected = NO;
    }
}
//发票类型
- (IBAction)fapiaoTypeBtnClicked:(UIButton *)sender {
    sender.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
    sender.backgroundColor = UIColorWithRGB(63, 174, 233, 0.1);
    sender.selected = YES;
    if (sender == self.bukaiBtn) {
        self.isSure = 0;
        self.fapiaoTypeLabel.text = @"";
        self.kaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.kaiBtn.backgroundColor = [UIColor whiteColor];
        self.kaiBtn.selected = NO;

        self.zengzhiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.zengzhiBtn.backgroundColor = [UIColor whiteColor];
        self.zengzhiBtn.selected = NO;

        self.fapiaoTaitouView.hidden = YES;
        self.fapiaoNeirongView.hidden = YES;
    } else if (sender == self.zengzhiBtn) {
        self.fapiaoTypeLabel.text = [NSString stringWithFormat:@"%.f%%的增值税发票", self.zengShui];
        self.isSure = 2;

        self.bukaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.bukaiBtn.backgroundColor = [UIColor whiteColor];
        self.bukaiBtn.selected = NO;
        self.kaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.kaiBtn.backgroundColor = [UIColor whiteColor];
        self.kaiBtn.selected = NO;
        self.fapiaoTaitouView.hidden = NO;
        self.fapiaoNeirongView.hidden = NO;
    } else {
        self.fapiaoTypeLabel.text = [NSString stringWithFormat:@"%.f%%的普通发票", self.puShui];
        self.isSure = 1;
        self.zengzhiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.zengzhiBtn.backgroundColor = [UIColor whiteColor];
        self.zengzhiBtn.selected = NO;

        self.bukaiBtn.backgroundColor = [UIColor whiteColor];
        self.bukaiBtn.selected = NO;
        self.fapiaoTaitouView.hidden = NO;
        self.fapiaoNeirongView.hidden = NO;
    }
    [self.fapiaoView layoutIfNeeded];
}
//发票确认
- (IBAction)fapiaoSureBtnClick:(id)sender {
    CartSellerModel *model = self.dataArray[self.index.row];
     model.isExist = YES;
    float sellerMoney = 0;
    for (NSDictionary *dict in model.data) {
        sellerMoney += [dict[@"goods_price"] floatValue] * [dict[@"total_num"] intValue];
    }
    if (self.bukaiBtn.selected) {
        [self.selectCell.fapiaoBtn setTitle:[NSString stringWithFormat:@"不开发票"] forState:UIControlStateNormal];
       
        self.selectCell.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sellerMoney + model.express_price - model.coupon];
        self.invoice = @"1";

        self.selectCell.shuijinLabel.text = @"¥0";

        NSDictionary *temp = @{
            @"invoice_type": @"0",
            @"seller_id": @(model.seller_id)
        };
        model.selectInvoce = temp;
        if (self.invoice_info.count == 0) {
            [self.invoice_info addObject:temp];
        } else {
            for (NSInteger i = 0; i < self.invoice_info.count; i++) {
                NSDictionary *dict = self.invoice_info[i];
                if ([dict[@"seller_id"] intValue] == model.seller_id) {
                    [self.invoice_info replaceObjectAtIndex:i withObject:temp];
                } else {
                    [self.invoice_info addObject:temp];
                }
            }
        }

    } else if (self.kaiBtn.selected) {
        if (self.isSelect == YES) {
            [self.selectCell.fapiaoBtn setTitle:[NSString stringWithFormat:@"普票(个人)"] forState:UIControlStateNormal];
            self.invoice = @"0";
            NSDictionary *temp = @{
                @"invoice": @(0),
                @"seller_id": @(model.seller_id),
                @"invoice_type": @(1)
            };
            model.selectInvoce = temp;
            model.taxes = 0;

            if (self.invoice_info.count == 0) {
                [self.invoice_info addObject:temp];
            } else {
                for (NSInteger i = 0; i < self.invoice_info.count; i++) {
                    NSDictionary *dict = self.invoice_info[i];
                    if ([dict[@"seller_id"] intValue] == model.seller_id) {
                        [self.invoice_info replaceObjectAtIndex:i withObject:temp];
                    } else {
                        [self.invoice_info addObject:temp];
                    }
                }
            }

            NSDictionary *dic = model.invoice;
            self.puShui = [dic[@"taxes"] doubleValue];
            model.taxes = model.seller_price * self.puShui / 100;
            self.selectCell.shuijinLabel.text = [NSString stringWithFormat:@"¥%.2f", model.taxes];
            //            model.seller_pay_price + model.express_price + model.coupon + model.seller_taxes
            self.selectCell.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sellerMoney + model.taxes + model.express_price - model.coupon];

        } else {
            [self.selectCell.fapiaoBtn setTitle:[NSString stringWithFormat:@"普票(单位)"] forState:UIControlStateNormal];
            self.invoice = @"10";

            if (self.danweiNameTF.text.length == 0) {
                [DZTools showNOHud:@"单位名称不能为空" delay:2];
                return;
            }

            if (self.danweishuihaoTF.text.length == 0) {
                [DZTools showNOHud:@"纳税人识别号不能为空" delay:2];
                return;
            }

            NSDictionary *temp = @{
                @"invoice": @(0),
                @"seller_id": @(model.seller_id),
                @"invoice_type": @(1),
                @"taxpayer_number": self.danweishuihaoTF.text,
                @"invoice_unitname": self.danweiNameTF.text
            };

            model.selectInvoce = temp;
            if (self.invoice_info.count == 0) {
                [self.invoice_info addObject:temp];
            } else {
                for (NSInteger i = 0; i < self.invoice_info.count; i++) {
                    NSDictionary *dict = self.invoice_info[i];
                    if ([dict[@"seller_id"] intValue] == model.seller_id) {
                        [self.invoice_info replaceObjectAtIndex:i withObject:temp];
                    } else {
                        [self.invoice_info addObject:temp];
                    }
                }
            }
            NSDictionary *dic = model.invoice;
            self.puShui = [dic[@"taxes"] doubleValue];
            model.taxes = model.seller_price * self.puShui / 100;
            self.selectCell.shuijinLabel.text = [NSString stringWithFormat:@"¥%.2f", model.taxes];
            self.selectCell.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sellerMoney + model.taxes + model.express_price - model.coupon];
        }
    } else if (self.zengzhiBtn.selected) {
        if (self.isSelect == YES) {
            [self.selectCell.fapiaoBtn setTitle:[NSString stringWithFormat:@"增值税(个人)"] forState:UIControlStateNormal];
            self.invoice = @"0";
            NSDictionary *temp = @{
                @"invoice": @(0),
                @"seller_id": @(model.seller_id),
                @"invoice_type": @(1)
            };
            model.selectInvoce = temp;
            if (self.invoice_info.count == 0) {
                [self.invoice_info addObject:temp];
            } else {
                for (NSInteger i = 0; i < self.invoice_info.count; i++) {
                    NSDictionary *dict = self.invoice_info[i];
                    if ([dict[@"seller_id"] intValue] == model.seller_id) {
                        [self.invoice_info replaceObjectAtIndex:i withObject:temp];
                    } else {
                        [self.invoice_info addObject:temp];
                    }
                }
            }
            NSDictionary *dic = model.invoice;
            self.zengShui = [dic[@"taxes_increment"] doubleValue];
            model.taxes = model.seller_price * self.zengShui / 100;
            self.selectCell.shuijinLabel.text = [NSString stringWithFormat:@"¥%.2f", model.taxes];
            self.selectCell.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sellerMoney + model.taxes + model.express_price - model.coupon];

        } else {
            [self.selectCell.fapiaoBtn setTitle:[NSString stringWithFormat:@"增值税(单位)"] forState:UIControlStateNormal];
            self.invoice = @"10";
            if (self.danweiNameTF.text.length == 0) {
                [DZTools showNOHud:@"单位名称不能为空" delay:2];
                return;
            }

            if (self.danweishuihaoTF.text.length == 0) {
                [DZTools showNOHud:@"纳税人识别号不能为空" delay:2];
                return;
            }

            NSDictionary *temp = @{
                @"invoice": @(0),
                @"seller_id": @(model.seller_id),
                @"invoice_type": @(1),
                @"taxpayer_number": self.danweishuihaoTF.text,
                @"invoice_unitname": self.danweiNameTF.text
            };
            model.selectInvoce = temp;
            if (self.invoice_info.count == 0) {
                [self.invoice_info addObject:temp];
            } else {
                for (NSInteger i = 0; i < self.invoice_info.count; i++) {
                    NSDictionary *dict = self.invoice_info[i];
                    if ([dict[@"seller_id"] intValue] == model.seller_id) {
                        [self.invoice_info replaceObjectAtIndex:i withObject:temp];
                    } else {
                        [self.invoice_info addObject:temp];
                    }
                }
            }
            NSDictionary *dic = model.invoice;
            self.zengShui = [dic[@"taxes_increment"] doubleValue];
            model.taxes = model.seller_price * self.zengShui / 100;
            self.selectCell.shuijinLabel.text = [NSString stringWithFormat:@"¥%.2f", model.taxes];
            self.selectCell.totalPriceLabel.text = [NSString stringWithFormat:@"%.2f", sellerMoney + model.taxes + model.express_price - model.coupon];
        }
        
    }

    [self.selectTempArray addObject:model];
    [self initMoneyView];
    [self.view layoutIfNeeded];
    [self.fapiaoView removeFromSuperview];
}

//是否选中积分积分
- (IBAction)jifenBtnClick:(id)sender {
    self.jifenBtn.selected = !self.jifenBtn.selected;
    if (self.jifenBtn.selected) {
        self.isJifen = 1;
        [self.jifenBtn setTitle:[NSString stringWithFormat:@"可用积分%.f，可抵%.f元", self.jifen, self.jifen / 10] forState:UIControlStateNormal];

    } else {
        self.isJifen = 0;
        [self.jifenBtn setTitle:[NSString stringWithFormat:@"可用积分%.f，可抵%.f元", self.jifen, self.jifen / 10] forState:UIControlStateNormal];
    }
    [self initMoneyView];
}
- (IBAction)cancelView:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    [self.zhifuStyleView removeFromSuperview];
}
- (IBAction)fapiaoCancelView:(id)sender {
    [self.fapiaoView removeFromSuperview];
}
- (IBAction)cancelBtnClick:(id)sender {
    [self.fapiaoView removeFromSuperview];
}
//支付
- (IBAction)zhifuBtnClick:(UIButton *)sender {

    [self.view endEditing:YES];
    sender.selected = YES;
    if (sender.tag == 1) {
        _weixinBtn.selected = NO;
        _zhifubaoBtn.selected = NO;
    } else if (sender.tag == 2) {
        _weixinBtn.selected = NO;
        _yueBtn.selected = NO;
    } else if (sender.tag == 3) {
        _zhifubaoBtn.selected = NO;
        _yueBtn.selected = NO;
    }
}

//确认订单
- (IBAction)sureBtnClick:(id)sender {
    NSString *cartId = [self.cartIdArray componentsJoinedByString:@","];
    NSDictionary *dict = @{};
    if (self.isSelectAll) {//全选
        dict = @{};
    } else {
        dict = @{
            @"cart_id": cartId,
        };
    }
    NSDictionary *params = @{};

    if (self.addressId == 0) {
        [DZTools showNOHud:@"地址不能为空，请选择地址后在再结算" delay:2];
        return;
    }

    if (self.invoice_info.count == 0) {//发票信息为0
        if (self.coupon_info.count == 0) {//优惠券为0
            params = @{
                @"cart_id": cartId,
                @"integra": [self.integra mj_JSONString],
                @"invoice_info": [self.invoice_info mj_JSONString],
                @"pstime": self.peisongTimeBtn.titleLabel.text,
                @"address_id":@(self.addressId)
                
            };
        } else {
            params = @{
                @"cart_id": cartId,
                @"integra":  [self.integra mj_JSONString],
                @"invoice_info": [self.invoice_info mj_JSONString],
                @"coupon_info": [self.coupon_info mj_JSONString],
                @"pstime": self.peisongTimeBtn.titleLabel.text,
                @"address_id":@(self.addressId)
            };
        }
    } else {
        if (self.coupon_info.count == 0) {//优惠券为0
            params = @{
                @"cart_id": cartId,
                @"integra": [self.integra mj_JSONString],
                @"invoice_info": [self.invoice_info mj_JSONString],
                @"pstime": self.peisongTimeBtn.titleLabel.text,
                @"address_id":@(self.addressId)
            };
        } else {
            params = @{
                @"cart_id": cartId,
                @"integra":  [self.integra mj_JSONString],
                @"invoice_info": [self.invoice_info mj_JSONString],
                @"coupon_info": [self.coupon_info mj_JSONString],
                @"pstime": self.peisongTimeBtn.titleLabel.text,
                @"address_id":@(self.addressId)
            };
        }
    }
    NSLog(@"-------%@", params);
    [DZNetworkingTool postWithUrl:kCartPay
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"][@"order"];
                self.totalLabel.text = @"0.00";
                self.orderNo = dict[@"order_no"];
                NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
                NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", [dict[@"pay_price"] floatValue]];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", [dict[@"pay_price"] floatValue]]];
                [attrStr setAttributes:attributeDict range:range];
                self.zhifuMoneyLabel.text = textStr;
                self.zhifuMoneyLabel.attributedText = attrStr;

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"24小时未支付自动取消" message:nil preferredStyle:UIAlertControllerStyleAlert];

                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"继续支付"
                                                                   style:UIAlertActionStyleDefault
                                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                                     self.zhifuStyleView.frame = [DZTools getAppWindow].bounds;
                                                                     [[DZTools getAppWindow] addSubview:self.zhifuStyleView];
                                                                 }];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消支付"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:^(UIAlertAction *_Nonnull action) {

                                                            self.tabBarController.selectedIndex = 3;
                                                            [self.navigationController popToRootViewControllerAnimated:NO];
                                                                     }];

                [alert addAction:cancelAction];
                [alert addAction:okAction];

                [self presentViewController:alert animated:YES completion:nil];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

- (IBAction)tijiaoBtnClick:(id)sender {
    if (self.yueBtn.selected) {

        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.frame = CGRectMake(15, 64, 240, 30);
            textField.placeholder = @"请输入支付密码";
            textField.secureTextEntry = YES;
        }];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action){
                                                              [self.navigationController popViewControllerAnimated:YES];
                                                          }]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
                                                              UITextField *textField = alertController.textFields.firstObject;
                                                              if (textField.text.length == 0) {
                                                                  [DZTools showNOHud:@"支付密码不能为空" delay:2.0];
                                                                  return;
                                                              }
                                                              [self zhifuWithpassword:textField.text];
                                                          }]];
        [self presentViewController:alertController animated:true completion:nil];

    } else if (self.zhifubaoBtn.selected) {
        NSDictionary *dict = @{
            @"pay_type": @"alipay",
            @"order_no": self.orderNo,
            //                               @"pay_password": password
        };
        [self zhifubaoPayWithDict:dict];
    } else if (self.weixinBtn.selected) {
        if ([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
            NSDictionary *dict = @{
                @"pay_type": @"wechat",
                @"order_no": self.orderNo,
                //                                   @"pay_password": password
            };
            [DZNetworkingTool postWithUrl:kOrderPay
                params:dict
                success:^(NSURLSessionDataTask *task, id responseObject) {
                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                        [self.navigationController popViewControllerAnimated:YES];
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];
                        NSDictionary *dict = responseObject[@"data"];
                        PayReq *request = [[PayReq alloc] init];
                        request.openID = dict[@"appid"];
                        request.partnerId = dict[@"partnerid"];
                        request.prepayId = dict[@"prepayid"];
                        request.nonceStr = dict[@"noncestr"];
                        request.timeStamp = [dict[@"timestamp"] intValue];
                        request.package = dict[@"package"];
                        request.sign = dict[@"sign"];
                        [WXApi sendReq:request];

                        [self.view layoutIfNeeded];
                        self.tabBarController.selectedIndex = 3;

                        [self.navigationController popToRootViewControllerAnimated:YES];

                    } else if([responseObject[@"code"] intValue] == 2){
                         [DZTools showOKHud:responseObject[@"msg"] delay:2];
                        self.tabBarController.selectedIndex = 3;
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    }else{
                        self.hidesBottomBarWhenPushed = YES;
                        MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                        viewController.selectIndex = 1;
                        self.totalLabel.text = @"0.00";
                        [self.view layoutIfNeeded];
                        [self.navigationController pushViewController:viewController animated:YES];
                        self.hidesBottomBarWhenPushed = YES;
                    }
                }
                failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
                IsNeedHub:NO];
        }
    }

    [self.zhifuStyleView removeFromSuperview];
}

- (IBAction)peisongBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择配送时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.timeArray.count; i++) {

        [alert addAction:[UIAlertAction actionWithTitle:self.timeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertTimeClick:i];
                                                }]];
    }

    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertTimeClick:self.timeArray.count];
                                                
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
    
}

@end
