//
//  MyOrderDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyOrderDetailViewController.h"
//cell
#import "GongZhongBaojiaDanCell.h"
#import "FenleiBaojiaDanCell.h"
#import "ZhiFuSelectTypeView.h"
//跳转controller
#import "AppraiseViewController.h"
#import "StoreDetailViewController.h"
#import "YanshouHuoViewController.h"
#import "ChangePasswordViewController.h"
#import "CaiLiaoDanDetailHeaderView.h"
//model
#import "BaojiadanGoodsModel.h"
#import "MyOrderCell.h"
#import "OederDetailModel.h"
#import "MallSellerList.h"
//支付
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface MyOrderDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
//详情按钮
@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (strong, nonatomic) IBOutlet UIView *HeadView;
@property (strong, nonatomic) IBOutlet UIView *FooterView;

//材料单名称：xxxxx
@property (weak, nonatomic) IBOutlet UILabel *cailiaoNameLabel;
//材料单总价：¥1200.00
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
//配送费
@property (weak, nonatomic) IBOutlet UILabel *peisongFeiLabel;
//下单时间：2018-11-11 11：11
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//发货时间：2018-11-11 11：11
@property (weak, nonatomic) IBOutlet UILabel *fahuotimeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fahuoLabelHeight;
//发票类型
@property (weak, nonatomic) IBOutlet UIButton *lijizhiduBtn;
@property (weak, nonatomic) IBOutlet UILabel *fapiaoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fapiaoLabelHeight;
//司机电话
@property (weak, nonatomic) IBOutlet UILabel *sijiLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sijiLabelHeight;
//车牌号
@property (weak, nonatomic) IBOutlet UILabel *chepaiLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *chepaiLabelHeight;
//收件人：张三
@property (weak, nonatomic) IBOutlet UILabel *shoujianrenNameLabel;
//13526567147
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//编号
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headIMageView;
//商家名
@property (weak, nonatomic) IBOutlet UILabel *shangjiaLabel;
//配送费：¥10.00
@property (weak, nonatomic) IBOutlet UILabel *peisongLabel;
@property (weak, nonatomic) IBOutlet UIButton *payBtn;
@property (weak, nonatomic) IBOutlet UIView *basicView;
//订单总价
@property (weak, nonatomic) IBOutlet UILabel *orderPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *quxiaodingdanBtn;

@property (weak, nonatomic) IBOutlet UIView *shangjiaView;
@property (weak, nonatomic) IBOutlet UIButton *zhunbeiShouhuo;

@property (strong, nonatomic) ZhiFuSelectTypeView *zhiFuSelectView;
@property (strong, nonatomic) NSDictionary *dataDic;
@property (strong, nonatomic) NSMutableArray *bendianArray;
@property (strong, nonatomic) NSMutableArray *daigouArray;
@property (strong, nonatomic) NSMutableArray *budaigouArray;
@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic, strong) NSDictionary *seller;
///总价
@property (nonatomic, assign) float totalMoney;
///yes 折叠 no不折叠
@property (assign, nonatomic) BOOL iSHide;
///yes 隐藏 no不隐藏
@property (assign, nonatomic) BOOL isHiddle;
///订单ID
@property (nonatomic, strong) NSString *orderNumber;

@end

@implementation MyOrderDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        self.detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.dataArray = [NSMutableArray array];
    self.bendianArray = [NSMutableArray array];
    self.budaigouArray = [NSMutableArray array];
    self.daigouArray = [NSMutableArray array];
    [self initData];

    [self initBasicView];
    [self initTableView];
    [self initBtn];
}

#pragma mark – UI

- (void)initBasicView {

    //阴影的颜色
    self.basicView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.basicView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.basicView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.basicView.layer.shadowOffset = CGSizeMake(0, 0);
    self.basicView.layer.cornerRadius = 5;

    //阴影的颜色
    self.shangjiaView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.shangjiaView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.shangjiaView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.shangjiaView.layer.shadowOffset = CGSizeMake(0, 0);
    self.shangjiaView.layer.cornerRadius = 5;
}
//初始化tableview
- (void)initTableView {
    self.HeadView.frame = CGRectMake(0, 0, ViewWidth, 510);
    //    self.fapiaoLabel.text = [NSString stringWithFormat:@"司机姓名：%@", @"张三"];
    self.detailBtn.hidden = YES;
    if (self.type == 30) { //20 待付款 30待收货 40已取消 50 已完成
        if ([self.order_status_name containsString:@"已发货"]) {
            self.zhunbeiShouhuo.hidden = NO;
            self.lijizhiduBtn.hidden = YES;
            self.quxiaodingdanBtn.hidden = YES;
            self.fahuotimeLabel.hidden = NO;
            [self.zhunbeiShouhuo setTitle:@"准备收货" forState:UIControlStateNormal];
        } else if ([self.order_status_name containsString:@"未发货"]) {
            self.zhunbeiShouhuo.hidden = NO;
            self.lijizhiduBtn.hidden = YES;
            self.quxiaodingdanBtn.hidden = YES;
            self.fahuotimeLabel.hidden = YES;
            [self.zhunbeiShouhuo setTitle:@"我要催单" forState:UIControlStateNormal];
        } else if ([self.order_status_name containsString:@"未接单"]) {
            self.fahuotimeLabel.hidden = YES;
            self.zhunbeiShouhuo.hidden = NO;
            [self.zhunbeiShouhuo setTitle:@"我要催单" forState:UIControlStateNormal];
        } else if ([self.order_status_name containsString:@"异常"]) {
            self.zhunbeiShouhuo.hidden = YES;
            self.fahuotimeLabel.hidden = NO;
            //            [self.zhunbeiShouhuo setTitle:@"我要催单" forState:UIControlStateNormal];
        }
        //        self.fapiaoLabelHeight.constant = 0;
        //        self.HeadView.frame = CGRectMake(0, 0, ViewWidth, 452+75);
    } else if (self.type == 40) { //取消
        self.zhunbeiShouhuo.hidden = YES;
        self.fahuotimeLabel.hidden =YES;
        [self.quxiaodingdanBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [self.lijizhiduBtn setTitle:@"继续购买" forState:UIControlStateNormal];

    } else if (self.type == 50) { //完成
        if (self.order_evalu == 0) {
            self.zhunbeiShouhuo.hidden = NO;
            self.payBtn.hidden = YES;
            self.lijizhiduBtn.hidden = YES;
            self.quxiaodingdanBtn.hidden = YES;
             self.fahuotimeLabel.hidden =NO;
             self.zhunbeiShouhuo.userInteractionEnabled = NO;
            [self.zhunbeiShouhuo setTitle:@"去评价" forState:UIControlStateNormal];
        }else  if (self.order_evalu == 1){
            self.zhunbeiShouhuo.hidden = YES;
             self.fahuotimeLabel.hidden =NO;
            self.lijizhiduBtn.hidden = YES;
            self.quxiaodingdanBtn.hidden = YES;
            self.zhunbeiShouhuo.userInteractionEnabled = YES;
            self.payBtn.hidden = YES;
//            [self.zhunbeiShouhuo setTitle:@"去评价" forState:UIControlStateNormal];
        }
       
    }else if (self.type == 20){
        self.fahuotimeLabel.hidden =YES;
    }

    self.detailTableView.tableHeaderView = self.HeadView;
    self.FooterView.frame = CGRectMake(0, 0, ViewWidth, 65);
    self.detailTableView.tableFooterView = self.FooterView;

    [self.detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"MyOrderCell" bundle:nil] forCellReuseIdentifier:@"MyOrderCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"FenleiBaojiaDanCell" bundle:nil] forCellReuseIdentifier:@"FenleiBaojiaDanCell"];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"GongZhongBaojiaDanCell" bundle:nil] forCellReuseIdentifier:@"GongZhongBaojiaDanCell"];
}

#pragma mark – Network

- (void)initData {
    [self.dataArray removeAllObjects];
    NSDictionary *dict = @{
        @"id": @(self.orderId)
    };
    NSLog(@"%@", dict);
    [DZNetworkingTool getWithUrl:kOrderDetail
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"][@"order"];
                self.dataDic = dict;
                [self jiexiDataWithDict:self.dataDic];
                ///赋值
                OederDetailModel *model = [OederDetailModel mj_objectWithKeyValues:dict];
                self.seller = model.seller;
                self.orderNumber = model.order_no;
                self.fahuotimeLabel.text = model.freight_time;

                if (model.order_name.length == 0) {
                    self.cailiaoNameLabel.text = @"暂无名称";
                } else {
                    self.cailiaoNameLabel.text = [NSString stringWithFormat:@"材料单名称：%@", model.order_name];
                }
                NSString *fapiaoStr = @"";
                //                发票类型 1：3%增值税普通发票 2： 3%增值税专用发票 3： 16%增值税普通发票 4： 16%增值税专用发票
                if (model.invoice == 1) {
                    fapiaoStr = [NSString stringWithFormat:@"发票类型：3%%增值税普通发票"];
                } else if (model.invoice == 2) {
                    fapiaoStr = [NSString stringWithFormat:@"发票类型：3%%增值税专用发票"];
                } else if (model.invoice == 3) {
                    fapiaoStr = [NSString stringWithFormat:@"发票类型：16%%增值税普通发票"];
                } else if (model.invoice == 4) {
                    fapiaoStr = [NSString stringWithFormat:@"发票类型：16%%增值税专用发票"];
                }
                self.fapiaoLabel.text = fapiaoStr;
                // 时间戳 -> NSDate *
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.updatetime];
                //设置时间格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                //将时间转换为字符串
                NSString *timeStr = [formatter stringFromDate:date];
                if (model.updatetime == 0) {
                    self.fahuotimeLabel.text = @"暂未发货";
                }else{
                    self.fahuotimeLabel.text = [NSString stringWithFormat:@"发货时间:%@", timeStr];
                }
                
                self.priceLabel.text = [NSString stringWithFormat:@"材料单总价:%.2f", model.pay_price];
                self.bianhaoLabel.text = [NSString stringWithFormat:@"订单编号：%@", model.order_no];
                self.peisongFeiLabel.text = [NSString stringWithFormat:@"配送费用：%.2f", model.express_price];

                self.totalMoney = model.pay_price;
                self.orderPriceLabel.text = [NSString stringWithFormat:@"¥%.2f", self.totalMoney];
                if (self.type == 50) {
                    self.peisongLabel.text = [NSString stringWithFormat:@"物流单号：%@", model.express_no];
                } else { //准备收货
                    self.peisongLabel.text = [NSString stringWithFormat:@"配送费：%.2f", model.express_price];
                }

                // 时间戳 -> NSDate *
                NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:model.createtime];
                //设置时间格式
                NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
                [formatter1 setDateFormat:@"yyyy-MM-dd HH:mm"];
                //将时间转换为字符串
                NSString *timeStr1 = [formatter stringFromDate:date1];
                self.timeLabel.text = [NSString stringWithFormat:@"下单时间:%@", timeStr1];

                NSDictionary *addDict = dict[@"address"];
                self.shoujianrenNameLabel.text = [NSString stringWithFormat:@"收件人:%@", addDict[@"name"]];
                self.phoneLabel.text = addDict[@"phone"];
                self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",
                                                                    addDict[@"province_id"], addDict[@"city_id"], addDict[@"region_id"], addDict[@"detail"]];

                NSDictionary *sellerDict = dict[@"seller"];
                //
                self.shangjiaLabel.text = [NSString stringWithFormat:@"%@", sellerDict[@"seller_name"]];

                [self.headIMageView sd_setImageWithURL:sellerDict[@"images"]
                                      placeholderImage:[UIImage imageNamed:@"defaultImg"]];

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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.iSHide) {
        return 0;
    }

    return [self.dataArray[section] count];
    ;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    BaojiadanGoodsModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.type == 0) {
        return 91;
    } else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] init];
    return view;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaojiadanGoodsModel *model = self.dataArray[indexPath.section][indexPath.row];
    if (model.type == 2) {
        GongZhongBaojiaDanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GongZhongBaojiaDanCell"];
        cell.gongzhongLabel.text = model.goods_name;
        return cell;
    } else if (model.type == 1) {
        FenleiBaojiaDanCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FenleiBaojiaDanCell"];
        cell.fenleiLabel.text = model.goods_name;
        return cell;
    } else {
        MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderCell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];

        cell.nameLabel.text = model.goods_name;
        cell.pinpaiLabel.text = model.stuff_brand_name;

        NSMutableArray *array = [NSMutableArray array];
        NSString *name = @"";
        if (model.stuff_spec.count > 0) { //规格

            for (NSDictionary *dict in model.stuff_spec) {
                [array addObject:dict[@"name"]];
            }
            name = [array componentsJoinedByString:@""];
        } else {
            name = @"暂无数据";
        }
        cell.xinghaoLabel.text = [NSString stringWithFormat:@"规格：%@", name];
        cell.numberLabel.text = [NSString stringWithFormat:@"数量：%d", model.number];
        cell.onePriceLabel.text = [NSString stringWithFormat:@"¥%@", model.goods_price];
        cell.allPriceLabel.text = [NSString stringWithFormat:@"¥%d", (model.con_price * model.number)];

        return cell;
    }
}
#pragma mark - Function
//朋友代付
- (void)friendPay {
}
//立即支付
- (void)nowPay {
    NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
    NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", [self.dataDic[@"pay_price"] floatValue]];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
    NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", [self.dataDic[@"pay_price"] floatValue]]];
    [attrStr setAttributes:attributeDict range:range];

    //转场动画
    CATransition *animation = [CATransition animation];
    animation.type = kCATransitionMoveIn;
    animation.subtype = kCATransitionFromTop;
    animation.duration = 0.25;
    [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];

    self.zhiFuSelectView.moneyLabel.attributedText = attrStr;
    [[DZTools getAppWindow] addSubview:self.zhiFuSelectView];
}
//支付
- (void)zhifufounction:(int)type {
    [self.zhiFuSelectView removeFromSuperview];
    if (type == 1) { //1余额 2支付宝 3微信
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
                                                              //发起余额支付
                                                              [self payByYueWithPassword:textField.text];

                                                          }]];
        [self presentViewController:alertController animated:true completion:nil];

    } else if (type == 2) { //支付宝支付
        NSDictionary *dict = @{
            @"pay_type": @"alipay",
            @"order_no": self.orderNumber,
            //                               @"pay_password":password

        };
        [DZNetworkingTool postWithUrl:kOrderPay
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [self.navigationController popViewControllerAnimated:YES];
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    [[AlipaySDK defaultService] payOrder:responseObject[@"data"]
                                              fromScheme:@"SanMuZhuangXiu"
                                                callback:^(NSDictionary *resultDic) {
                                                    NSLog(@"-------%@", resultDic);
                                                }];

                }else if([responseObject[@"code"] intValue] == 2){
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    self.tabBarController.selectedIndex = 3;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];
    } else if (type == 3) { //微信支付
        NSDictionary *dict = @{
            @"pay_type": @"wechat",
            @"order_no": self.orderNumber,
            //                               @"pay_password":password
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

                }else if([responseObject[@"code"] intValue] == 2){
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    self.tabBarController.selectedIndex = 3;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];
    }
}
//余额支付
- (void)payByYueWithPassword:(NSString *)passWorld {
    NSDictionary *params = @{
        @"pay_type": @"money",
        @"order_no": self.orderNumber,
        @"pay_password": passWorld

    };
    [DZNetworkingTool postWithUrl:kOrderPay
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popToRootViewControllerAnimated:YES];

            } else {
                NSString *mima = responseObject[@"msg"];
                if ([mima containsString:@"请先设置支付密码"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置支付密码，无法支付。是否现在去设置支付密码？" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         //修改支付密码
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

                }else if([responseObject[@"code"] intValue] == 2){
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    self.tabBarController.selectedIndex = 3;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {

                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//解析数据
- (void)jiexiDataWithDict:(NSDictionary *)dict {
    for (NSDictionary *gongzhongDict in dict[@"bendian_data"]) {
        BaojiadanGoodsModel *gongzhong = [[BaojiadanGoodsModel alloc] init];
        gongzhong.goods_name = gongzhongDict[@"stuff_work_name"];
        gongzhong.type = 2;
        [self.bendianArray addObject:gongzhong];
        for (NSDictionary *fenleiDict in gongzhongDict[@"data"]) {
            BaojiadanGoodsModel *fenlei = [[BaojiadanGoodsModel alloc] init];
            fenlei.goods_name = fenleiDict[@"stuff_category_name"];
            fenlei.type = 1;
            [self.bendianArray addObject:fenlei];
            for (NSDictionary *goodsDict in fenleiDict[@"data"]) {
                BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];
                goods.type = 0;
                [self.bendianArray addObject:goods];
            }
        }
    }

    for (NSDictionary *gongzhongDict in dict[@"daibgou_data"]) {
        BaojiadanGoodsModel *gongzhong = [[BaojiadanGoodsModel alloc] init];
        gongzhong.goods_name = gongzhongDict[@"stuff_work_name"];
        gongzhong.type = 2;
        [self.budaigouArray addObject:gongzhong];
        for (NSDictionary *fenleiDict in gongzhongDict[@"data"]) {
            BaojiadanGoodsModel *fenlei = [[BaojiadanGoodsModel alloc] init];
            fenlei.goods_name = fenleiDict[@"stuff_category_name"];
            fenlei.type = 1;
            [self.budaigouArray addObject:fenlei];
            for (NSDictionary *goodsDict in fenleiDict[@"data"]) {
                BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];
                goods.type = 0;
                [self.budaigouArray addObject:goods];
            }
        }
    }
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
    [array addObject:self.bendianArray];

    if (self.budaigouArray.count != 0) {
        [array addObject:self.budaigouArray];
    }
    self.dataArray = array;
    [self.detailTableView reloadData];
}
//催单
- (void)jiedanFunction {
    NSDictionary *dict = @{
        @"id": @(self.orderId)
    };
    [DZNetworkingTool postWithUrl:kReminder
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

- (void)initBtn {
    //设置边框的颜色
    [self.detailBtn.layer setBorderColor:[UIColor whiteColor].CGColor];

    //设置边框的粗细
    [self.detailBtn.layer setBorderWidth:1.0];

    //设置圆角的半径
    [self.detailBtn.layer setCornerRadius:2];

    //切割超出圆角范围的子视图
    self.detailBtn.layer.masksToBounds = YES;
}
#pragma mark--XibFunction
//取消按钮的点击
- (IBAction)cancelBtnClick:(id)sender {

    if (self.type == 20) {
        NSDictionary *dict = @{ @"cancel_order": @(20),
                                @"order_id": @(self.orderId) };
        [DZNetworkingTool postWithUrl:kCancelOrder
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {

                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];
    } else if (self.type == 40) {
        //
        NSDictionary *dict = @{
            @"order_id": @(self.orderId)
        };
        [DZNetworkingTool postWithUrl:kDelOrder
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {

                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

                [DZTools showNOHud:RequestServerError delay:2.0];
            }
            IsNeedHub:NO];
    }
}

//立即付款的点击//在线支付
- (IBAction)nowPayBtnClick:(id)sender {
    if (self.type == 20) {

        NSString *messageStr = [NSString stringWithFormat:@"您的应付金额为：¥%@", self.dataDic[@"pay_price"]];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"立即支付" message:messageStr preferredStyle:UIAlertControllerStyleAlert];

        // 使用富文本来改变alert的title字体大小和颜色
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"立即支付"];
        [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 4)];
        [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0] range:NSMakeRange(0, 4)];
        [alert setValue:title forKey:@"attributedTitle"];

        // 使用富文本来改变alert的message字体大小和颜色
        // NSMakeRange(0, 14) 代表:从0位置开始 14个字符
        NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:messageStr];
        [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, messageStr.length)];
        [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:250 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0] range:NSMakeRange(8, messageStr.length - 8)];
        [alert setValue:message forKey:@"attributedMessage"];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"立即支付"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                                 [self nowPay];
                                                             }];

        //    // 设置按钮的title颜色
        [cancelAction setValue:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0] forKey:@"titleTextColor"];
        //
        //    // 设置按钮的title的对齐方式
        [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
        //
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                             //                                                             [self friendPay];
                                                         }];
        // 设置按钮的title颜色
        [okAction setValue:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0] forKey:@"titleTextColor"];
        //
        //    // 设置按钮的title的对齐方式
        [okAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
        [alert addAction:okAction];
        [alert addAction:cancelAction];

        [self presentViewController:alert animated:YES completion:nil];
    } else if (self.type == 40) {

        self.parentViewController.hidesBottomBarWhenPushed = YES;
        StoreDetailViewController *vc = [[StoreDetailViewController alloc] init];
        MallSellerList *list = [MallSellerList new];
        list.seller_id = [self.seller[@"seller_id"] intValue];
        vc.seller_id = list.seller_id;
        [self.navigationController pushViewController:vc animated:YES];
        self.parentViewController.hidesBottomBarWhenPushed = YES;
    }
}
//返回按钮点击事件
- (IBAction)leftBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

//上拉按钮的点击事件
- (IBAction)shanglaBtnClick:(id)sender {
    self.iSHide = !self.iSHide;
    [self.detailTableView reloadData];
}

//详情按钮的点击事件
- (IBAction)detailBtnClick:(id)sender {
    //    kMyInvoice
}
//准备收货
- (IBAction)zhunbeiShouHuoBtnClicked:(id)sender {

    if (self.type == 50) { //去评价
        self.parentViewController.hidesBottomBarWhenPushed = YES;
        AppraiseViewController *controller = [[AppraiseViewController alloc] init];
        controller.dataDic = self.dataDic;
        controller.order_type = self.orderType;
        [self.navigationController pushViewController:controller animated:YES];
        self.parentViewController.hidesBottomBarWhenPushed = YES;
    } else {
        //准备收货
        if ([self.order_status_name containsString:@"已发货"]) {
            self.parentViewController.hidesBottomBarWhenPushed = YES;
            YanshouHuoViewController *controller = [[YanshouHuoViewController alloc] init];
            controller.orderId = self.orderId;
            controller.dataDic = self.dataDic;
            [self.navigationController pushViewController:controller animated:YES];
            self.parentViewController.hidesBottomBarWhenPushed = YES;
        }else if ([self.order_status_name containsString:@"未发货"]){
            //催单
             [self  jiedanFunction];
        }else if ([self.order_status_name containsString:@"未接单"]){
             [self  jiedanFunction];
        }
      
    }
}

#pragma mark – 懒加载
- (ZhiFuSelectTypeView *)zhiFuSelectView {
    if (!_zhiFuSelectView) {
        _zhiFuSelectView = [[ZhiFuSelectTypeView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(self) weakSelf = self;
        _zhiFuSelectView.block = ^(int type) {
            [weakSelf zhifufounction:type];
        }; //1余额 2支付宝 3微信
    }
    return _zhiFuSelectView;
}

@end



