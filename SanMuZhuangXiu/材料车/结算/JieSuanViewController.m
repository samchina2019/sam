//
//  JieSuanViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JieSuanViewController.h"
#import "MyOrderPageViewController.h"
#import "AddressPickerView.h"
#import "AddressManagerViewController.h"
#import "ChangePasswordViewController.h"
#import "AddressModel.h"
#import "ReLayoutButton.h"
#import "BaojiadanDetailViewController.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface JieSuanViewController () <AddressPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *zengzhiBtn;
@property (weak, nonatomic) IBOutlet UILabel *fapiaoTypeLabel;

@property (weak, nonatomic) IBOutlet UIButton *peisongBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (nonatomic, strong) AddressPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;

@property (strong, nonatomic) IBOutlet UIView *zhifuView;
@property (weak, nonatomic) IBOutlet UIButton *yueBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifuaboBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;

@property (strong, nonatomic) IBOutlet UIView *addressView;
@property (weak, nonatomic) IBOutlet UIButton *morenBtn;
@property (weak, nonatomic) IBOutlet UITextField *nameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UIButton *addressBtn;
@property (weak, nonatomic) IBOutlet UILabel *bottemMoneyLabel;
@property (weak, nonatomic) IBOutlet UITextField *detailAddressTF;

@property (strong, nonatomic) IBOutlet UIView *faPiaoView;
@property (weak, nonatomic) IBOutlet UIButton *kaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *bukaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *gerenBtn;
@property (weak, nonatomic) IBOutlet UIButton *danweiBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutFaPiaoViewheigth;
@property (weak, nonatomic) IBOutlet UITextField *danweiNameTF;
@property (weak, nonatomic) IBOutlet UITextField *danweishuihaoTF;
@property (weak, nonatomic) IBOutlet UILabel *sellerName;
@property (weak, nonatomic) IBOutlet UILabel *cailiaodanName;
@property (weak, nonatomic) IBOutlet UILabel *totalPayLabel;
@property (weak, nonatomic) IBOutlet UILabel *cailiaotypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *manjianLabel;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiquanLabel;
@property (weak, nonatomic) IBOutlet UILabel *suijinLabel;
@property (weak, nonatomic) IBOutlet UILabel *allPayLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jifenBtn;
@property (weak, nonatomic) IBOutlet UILabel *zhifuMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *fapiaoXianshilabel;
@property (weak, nonatomic) IBOutlet UIView *fapiaoTaitouView;
@property (weak, nonatomic) IBOutlet UIView *fapiaoNeirongView;
@property (weak, nonatomic) IBOutlet UIButton *fapiaoBtn;

@property (nonatomic, assign) int addressId;  //地址ID
@property (nonatomic, assign) int couponId;   //优惠券ID
@property (nonatomic, assign) int jifen;      //积分
@property (nonatomic, assign) int youhuiquan; //优惠券
@property (nonatomic, assign) double yunfei; //运费
///1 普通发票 2 增值税
@property (nonatomic, assign) int invoice_type;

@property (nonatomic, assign) BOOL isSelect; //是否选中
@property (nonatomic, assign) int isSure;    //确定选中
@property (nonatomic, assign) BOOL isJifen;  //选中积分

@property (nonatomic, assign) float shuiJin;  //税金
@property (nonatomic, assign) double puShui;   //普通税率
@property (nonatomic, assign) double zengShui; //增值z税率

@property (nonatomic, strong) NSString *invoice;
@property (nonatomic, strong) NSString *addressStr;
@property (nonatomic, strong) NSString *orderNo;

@end

@implementation JieSuanViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([DZTools islogin]) {
        if (!self.isFromCart) {
            [self initFapiao];
            [self initJifen];
            [self initMyFapiaoDetail];
        }
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"结算";
    self.view.backgroundColor = ViewBackgroundColor;

    if (@available(iOS 11.0, *)) {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    if (ViewHeight + 1 - NavAndStatusHight > 600) {
        _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
    } else {
        self.layOutheigth.constant = 600;
    }

    [self initBasicView];
    [self initView];
    [self initData];
}
#pragma mark – UI

- (void)initBasicView {

    if (!self.isFromCart) {
        if (!self.isFromSeller) {
            [self initYouhuiQuan];
        }
        [self loadAddress];

    } else if (self.isFromSeller) {
        if ([self.dataDict[@"exist_address"] intValue] == 1) {
            AddressModel *model = [AddressModel mj_objectWithKeyValues:self.dataDict[@"address"]];
            self.NameLabel.text = [NSString stringWithFormat:@"收件人：%@", model.name];
            self.phoneLabel.text = [NSString stringWithFormat:@"%@", model.phone];
            self.detailLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        }
        self.manjianLabel.text = [NSString stringWithFormat:@"优惠%@", self.dataDict[@"coupon"]];
        self.youhuiquan = [self.dataDict[@"coupon"] intValue];
        self.youhuiquanLabel.text = [NSString stringWithFormat:@"¥%@", self.dataDict[@"coupon"]];
    } else {
        //        if ([self.dataDict[@"exist_address"] intValue] == 1) {
        //            AddressModel *model = [AddressModel mj_objectWithKeyValues:self.dataDict[@"address"][0]];
        //            self.NameLabel.text = [NSString stringWithFormat:@"收件人：%@", model.name];
        //            self.phoneLabel.text = [NSString stringWithFormat:@"%@", model.phone];
        //            self.detailLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        //        }
        self.manjianLabel.text = [NSString stringWithFormat:@"优惠%@", self.dataDict[@"coupon"]];
        self.youhuiquan = [self.dataDict[@"coupon"] intValue];
        self.youhuiquanLabel.text = [NSString stringWithFormat:@"¥%@", self.dataDict[@"coupon"]];
    }
}
- (void)initView {
    //阴影
    self.bgView1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView1.layer.shadowOpacity = 0.5f;
    self.bgView1.layer.shadowRadius = 3.f;
    self.bgView1.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView1.layer.cornerRadius = 5;

    self.bgView2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView2.layer.shadowOpacity = 0.5f;
    self.bgView2.layer.shadowRadius = 3.f;
    self.bgView2.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView2.layer.cornerRadius = 5;

    self.bgView3.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView3.layer.shadowOpacity = 0.5f;
    self.bgView3.layer.shadowRadius = 3.f;
    self.bgView3.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView3.layer.cornerRadius = 5;

    self.kaiBtn.layer.borderWidth = 1;
    self.kaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    self.bukaiBtn.layer.borderWidth = 1;
    self.bukaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    self.gerenBtn.layer.borderWidth = 1;
    self.gerenBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    self.danweiBtn.layer.borderWidth = 1;
    self.zengzhiBtn.layer.borderWidth = 1;
    self.zengzhiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;

    self.danweiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
    self.layOutFaPiaoViewheigth.constant = 80;

    self.jifenBtn.selected = NO;
    self.invoice = @"0";
}

#pragma mark – Network
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
                        self.NameLabel.text = [NSString stringWithFormat:@"收件人:%@", model.name];
                        self.phoneLabel.text = model.phone;
                        self.addressId = model.address_id;
                        self.detailLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
                        [self loadPeisongTime];
                    }
                }
                self.NameLabel.text = @"";
                self.phoneLabel.text = @"";
                self.detailLabel.text = @"请选择收货地址";

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)loadPeisongTime {

    NSDictionary *dict = @{
        @"seller_id": self.dataDict[@"seller_id"],
        @"receipt_id": self.dataDict[@"receipt_id"],
        @"address_id": @(self.addressId)
    };
    [DZNetworkingTool postWithUrl:kFreight
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *data = responseObject[@"data"][@"freight"];
                self.yunfeiLabel.text = [NSString stringWithFormat:@"%.2f", [data[@"freight"] floatValue]];
                self.yunfei = [data[@"freight"] doubleValue];
                [self.peisongBtn setTitle:[NSString stringWithFormat:@"配送时间：%@", data[@"delivery_time"]] forState:UIControlStateNormal];
                [self.view layoutIfNeeded];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];

        }
        IsNeedHub:NO];
}
- (void)initFapiao {
    //
    NSDictionary *dict = @{ @"seller_id": self.dataDict[@"seller_id"] };
    [DZNetworkingTool postWithUrl:kInvoice
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.puShui = [dict[@"taxes"] doubleValue];
                self.zengShui = [dict[@"taxes_increment"] doubleValue];
                if ([dict[@"invoice_type"] intValue] == 0) {
                    self.bukaiBtn.selected = YES;
                    self.bukaiBtn.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
                    self.bukaiBtn.backgroundColor = UIColorWithRGB(63, 174, 233, 0.1);
                    self.kaiBtn.hidden = YES;
                    self.zengzhiBtn.hidden = YES;
                    self.fapiaoTypeLabel.hidden = YES;
                    self.fapiaoTaitouView.hidden = YES;
                    self.fapiaoNeirongView.hidden = YES;
                    self.suijinLabel.text = @"¥0";
                    self.invoice = @"1";
                    self.fapiaoXianshilabel.text = @"不开发票";

                } else  if([dict[@"invoice_type"] intValue] == 1){
                    self.invoice = @"0";
                    self.kaiBtn.hidden = NO;
                    self.zengzhiBtn.hidden = NO;
                    self.fapiaoTypeLabel.hidden = NO;
                    self.fapiaoTaitouView.hidden = NO;
                    self.fapiaoNeirongView.hidden = NO;
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

- (void)initJifen {
    NSDictionary *dict = @{ @"seller_id": self.dataDict[@"seller_id"] };
    [DZNetworkingTool postWithUrl:kScorerul
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
///返回的数据n描述
//                score_deduction_if 是否支持积分抵扣:0=不支持,1=支持
//                score_deduction 积分抵扣（单笔消费可抵扣百分比） 店铺总价乘以 它
//                user_score 用户的积分
                self.jifen = [self.dataDict[@"totalMoney"] floatValue]* [dict[@"score_deduction"] floatValue];
                if ([dict[@"score_deduction_if"] intValue] == 0) {
                    
                      [self.jifenBtn setTitle:@"店铺不支持积分抵扣" forState:UIControlStateNormal];
                    self.jifenBtn.userInteractionEnabled = NO;
                    
                }else if ([dict[@"score_deduction_if"] intValue] == 1){
                    
                    [self.jifenBtn setTitle:[NSString stringWithFormat:@"我的积分%@,可用积分%d,可抵%d元", dict[@"user_score"],self.jifen*10,self.jifen] forState:UIControlStateNormal];
                    self.jifenBtn.userInteractionEnabled = YES;
                    
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
- (void)initYouhuiQuan {

    NSDictionary *params = @{ @"receipt_id": self.dataDict[@"receipt_id"] };
    NSLog(@"paras==%@", params);
    [DZNetworkingTool postWithUrl:kCoupon
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                //
                NSArray *array = responseObject[@"data"][@"coupon_data"];

                NSDictionary *dict = array[0];
                self.couponId = [dict[@"coupon_id"] intValue];
                self.manjianLabel.text = [NSString stringWithFormat:@"满%d减%d", [dict[@"threshold"] intValue], [dict[@"money"] intValue]];
                self.youhuiquanLabel.text = [NSString stringWithFormat:@"¥%d", [dict[@"money"] intValue]];
                self.youhuiquan = [dict[@"money"] intValue];

            } else {
                //                [DZTools showNOHud:responseObject[@"msg"] delay:2];
                self.manjianLabel.text = [NSString stringWithFormat:@"暂无优惠券"];
                self.youhuiquanLabel.text = [NSString stringWithFormat:@"¥0"];
                self.youhuiquan = 0;
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

#pragma mark - Function

- (void)cancelBtnClick {
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@", province, city, area] forState:UIControlStateNormal];
    self.addressStr = [NSString stringWithFormat:@"%@,%@,%@", province, city, area];

    [self.pickerView hide];
}
//初始化数据
- (void)initData {
    self.sellerName.text = self.dataDict[@"dianpuName"];
    self.cailiaodanName.text = self.dataDict[@"cailiaodanName"];
    self.totalPayLabel.text = [NSString stringWithFormat:@"%.2f", [self.dataDict[@"totalMoney"] floatValue]];
    self.numberLabel.text = [NSString stringWithFormat:@"商品数量:%d", [self.dataDict[@"number"] intValue]];
    self.cailiaotypeLabel.text = [NSString stringWithFormat:@"材料种类:%d", [self.dataDict[@"typeNumber"] intValue]];
    self.yunfeiLabel.text = @"¥0";
    float money = 0;
    self.jifenLabel.text = @"¥0";
    money = [self.dataDict[@"totalMoney"] floatValue] - self.youhuiquan;
    NSLog(@"-----%d", self.youhuiquan);
    self.allPayLabel.text = [NSString stringWithFormat:@"%.2f", money];
    self.bottemMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", money];
}

//支付
- (void)zhifuWithpassword:(NSString *)password {

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
                //                                      self.totalLabel.text = @"0.00";
                [self.view layoutIfNeeded];
                self.tabBarController.selectedIndex = 3;

                [self.navigationController popToRootViewControllerAnimated:YES];

            }else if([responseObject[@"code"] intValue] == 2){
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                self.tabBarController.selectedIndex = 3;
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            }  else {
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
                                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                                             //                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                                                             self.hidesBottomBarWhenPushed = YES;
                                                                             MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                                                                             viewController.selectIndex = 1;
                                                                             //                                      self.totalLabel.text = @"0.00";
                                                                             [self.view layoutIfNeeded];
                                                                             [self.navigationController pushViewController:viewController animated:YES];
                                                                             self.hidesBottomBarWhenPushed = YES;
                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    //                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                    self.hidesBottomBarWhenPushed = YES;
                    MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                    viewController.selectIndex = 1;
                    //                                      self.totalLabel.text = @"0.00";
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
#pragma mark-- xibFunction
//选择收货地址
- (IBAction)selectAddressBtnClicked:(id)sender {

    self.hidesBottomBarWhenPushed = YES;
    AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
    vc.block = ^(AddressModel *_Nonnull model) {
        self.NameLabel.text = [NSString stringWithFormat:@"收件人:%@", model.name];
        self.phoneLabel.text = model.phone;
        self.addressId = model.address_id;
        self.detailLabel.text = [NSString stringWithFormat:@"详细地址:%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        [self.view layoutIfNeeded];
        [self loadPeisongTime];

    };
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//确认订单
- (IBAction)payBtnClicked:(id)sender {
    //将遍历出来的界面存放入数组
    NSString *urlStr = @"";
    NSDictionary *params = @{};
    if (self.addressId == 0) {
        [DZTools showNOHud:@"请选择收货地址" delay:2];
        return;
    }
    if (!self.isFromSeller) {
        int isIntegra = 0;
        if (self.jifenBtn.selected) {
            isIntegra = 1;
        } else {
            isIntegra = 0;
        }
        urlStr = kAddOrder;
        if (self.bukaiBtn.selected) {
               params = @{ @"seller_id": self.dataDict[@"seller_id"],
                            @"receipt_id": self.dataDict[@"receipt_id"],
                            @"address_id": @(self.addressId),
                            @"coupon_id": @(self.couponId),
                            @"integra": @(isIntegra),
                            @"invoice": self.invoice,
                            @"bendian_data": self.dataDict[@"bendian_data"],
                            @"bendian_matching": self.dataDict[@"bendian_matching"],
                            @"daigou": self.dataDict[@"daigou"]
            };
        } else if (self.kaiBtn.selected) {
            if ([self.danweiNameTF.text length] > 0 && [self.danweishuihaoTF.text length] > 0) {
                params = @{ @"seller_id": self.dataDict[@"seller_id"],
                            @"receipt_id": self.dataDict[@"receipt_id"],
                            @"address_id": @(self.addressId),
                            @"coupon_id": @(self.couponId),
                            @"integra": @(isIntegra),
                            @"invoice": self.invoice,
                            @"invoice_type": @(self.invoice_type),
                            @"invoice_unitname": self.danweiNameTF.text,
                            @"taxpayer_number": self.danweishuihaoTF.text,
                            @"bendian_data": self.dataDict[@"bendian_data"],
                            @"bendian_matching": self.dataDict[@"bendian_matching"],
                            @"daigou": self.dataDict[@"daigou"]
                };
            } else {
                params = @{ @"seller_id": self.dataDict[@"seller_id"],
                            @"receipt_id": self.dataDict[@"receipt_id"],
                            @"address_id": @(self.addressId),
                            @"coupon_id": @(self.couponId),
                            @"integra": @(isIntegra),
                            @"invoice_type": @(self.invoice_type),
                            @"invoice": self.invoice,
                            @"bendian_data": self.dataDict[@"bendian_data"],
                            @"bendian_matching": self.dataDict[@"bendian_matching"],
                            @"daigou": self.dataDict[@"daigou"]
                };
            }
        } else {
            if ([self.danweiNameTF.text length] > 0 && [self.danweishuihaoTF.text length] > 0) {
                params = @{ @"seller_id": self.dataDict[@"seller_id"],
                            @"receipt_id": self.dataDict[@"receipt_id"],
                            @"address_id": @(self.addressId),
                            @"coupon_id": @(self.couponId),
                            @"integra": @(isIntegra),
                            @"invoice_type": @(self.invoice_type),
                            @"invoice": self.invoice,
                            @"invoice_unitname": self.danweiNameTF.text,
                            @"taxpayer_number": self.danweishuihaoTF.text,
                            @"bendian_data": self.dataDict[@"bendian_data"],
                            @"bendian_matching": self.dataDict[@"bendian_matching"],
                            @"daigou": self.dataDict[@"daigou"]
                };
            } else {
                params = @{ @"seller_id": self.dataDict[@"seller_id"],
                            @"receipt_id": self.dataDict[@"receipt_id"],
                            @"address_id": @(self.addressId),
                            @"coupon_id": @(self.couponId),
                            @"integra": @(isIntegra),
                            @"invoice_type": @(self.invoice_type),
                            @"invoice": self.invoice,
                            @"bendian_data": self.dataDict[@"bendian_data"],
                            @"bendian_matching": self.dataDict[@"bendian_matching"],
                            @"daigou": self.dataDict[@"daigou"]
                };
            }
        }
    } else {
        int isIntegra = 0;
        if (self.jifenBtn.selected) {
            isIntegra = 1;
        } else {
            isIntegra = 0;
        }
        urlStr = kCartPay;

        if ([self.danweiNameTF.text length] > 0 && [self.danweishuihaoTF.text length] > 0) {

            params = @{
                @"integra": @(isIntegra),
                @"invoice": self.invoice,
                @"invoice_unitname": self.danweiNameTF.text,
                @"taxpayer_number": self.danweishuihaoTF.text
            };
        } else {
            params = @{
                @"integra": @(isIntegra),
                @"invoice": self.invoice
            };
        }
    }
    [DZNetworkingTool postWithUrl:urlStr
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"][@"order_no"];

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
                                                                     self.zhifuView.frame = [DZTools getAppWindow].bounds;
                                                                     [[DZTools getAppWindow] addSubview:self.zhifuView];
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
//发票
- (IBAction)fapiaoBtnClicked:(id)sender {
    self.faPiaoView.frame = [DZTools getAppWindow].bounds;
    [[DZTools getAppWindow] addSubview:self.faPiaoView];
}
//选择支付方式
- (IBAction)selectChongzhiType:(UIButton *)sender {
    [self.view endEditing:YES];
    sender.selected = YES;
    if (sender.tag == 1) {
        _weixinBtn.selected = NO;
        _zhifuaboBtn.selected = NO;
    } else if (sender.tag == 2) {
        _weixinBtn.selected = NO;
        _yueBtn.selected = NO;
    } else if (sender.tag == 3) {
        _zhifuaboBtn.selected = NO;
        _yueBtn.selected = NO;
    }
}
- (IBAction)hiddenZhifuView:(id)sender {
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
    [self.zhifuView removeFromSuperview];
}
- (IBAction)hiddenAddressViewView:(id)sender {
    [self.addressView removeFromSuperview];
}
- (IBAction)hiddenfaPiaoViewView:(id)sender {
    [self.faPiaoView removeFromSuperview];
}
//提交订单
- (IBAction)commitBtnClicked:(id)sender {
    [self.zhifuView removeFromSuperview];
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
    } else if (self.zhifuaboBtn.selected) {
        NSDictionary *dict = @{
            @"pay_type": @"alipay",
            @"order_no": self.orderNo,

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
                                                    if ([resultDic[@"resultStatus"] intValue] == 9000) {
                                                        //                                                         [DZTools showNOHud:@"支付取消" delay:2];
                                                        self.tabBarController.selectedIndex = 3;

                                                        [self.navigationController popToRootViewControllerAnimated:YES];

                                                    } else if ([resultDic[@"resultStatus"] intValue] == 6001) {
                                                        //                                                         self.hidesBottomBarWhenPushed = YES;
                                                        MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                                                        viewController.selectIndex = 1;
                                                        //                                      self.totalLabel.text = @"0.00";
                                                        [self.view layoutIfNeeded];
                                                        [self.navigationController pushViewController:viewController animated:YES];
                                                        self.hidesBottomBarWhenPushed = YES;
                                                    } else {
                                                        //                                                          self.hidesBottomBarWhenPushed = YES;
                                                        MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                                                        viewController.selectIndex = 1;
                                                        //                                      self.totalLabel.text = @"0.00";
                                                        [self.view layoutIfNeeded];
                                                        [self.navigationController pushViewController:viewController animated:YES];
                                                        self.hidesBottomBarWhenPushed = YES;
                                                    }

                                                }];
                }else if([responseObject[@"code"] intValue] == 2){
                    [DZTools showOKHud:responseObject[@"msg"] delay:2];
                    self.tabBarController.selectedIndex = 3;
                    
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    self.hidesBottomBarWhenPushed = YES;
                    MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                    viewController.selectIndex = 1;
                    //                                      self.totalLabel.text = @"0.00";
                    [self.view layoutIfNeeded];
                    [self.navigationController pushViewController:viewController animated:YES];
                    self.hidesBottomBarWhenPushed = YES;
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];
    } else if (self.weixinBtn.selected) {
        if ([WXApi isWXAppInstalled]) { // 判断 用户是否安装微信
            NSDictionary *dict = @{
                @"pay_type": @"wechat",
                @"order_no": self.orderNo,

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

                    }else if([responseObject[@"code"] intValue] == 2){
                        [DZTools showOKHud:responseObject[@"msg"] delay:2];
                        self.tabBarController.selectedIndex = 3;
                        
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    } else {
                        self.hidesBottomBarWhenPushed = YES;
                        MyOrderPageViewController *viewController = [MyOrderPageViewController new];
                        viewController.selectIndex = 1;
                        //                                      self.totalLabel.text = @"0.00";
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
}

//发票类型
- (IBAction)fapiaoTypeBtnClicked:(UIButton *)sender {
    sender.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
    sender.backgroundColor = UIColorWithRGB(63, 174, 233, 0.1);
    sender.selected = YES;
    //    sender.selected = NO;
    if (sender == self.bukaiBtn) {
        self.isSure = 0;
        self.kaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.kaiBtn.backgroundColor = [UIColor whiteColor];
        self.kaiBtn.selected = NO;
        self.shuiJin = 0;
        self.suijinLabel.text = @"¥0";
        self.zengzhiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.zengzhiBtn.backgroundColor = [UIColor whiteColor];
        self.zengzhiBtn.selected = NO;

        self.fapiaoTaitouView.hidden = YES;
        self.fapiaoNeirongView.hidden = YES;
    } else if (sender == self.zengzhiBtn) {
        self.isSure = 1;

        self.fapiaoTypeLabel.text = [NSString stringWithFormat:@"%.2f%%增值税发票", self.zengShui ];
        self.suijinLabel.text = [NSString stringWithFormat:@"¥%.2f", self.zengShui  * [self.dataDict[@"totalMoney"] floatValue]];
        self.shuiJin = self.zengShui  * [self.dataDict[@"totalMoney"] floatValue];

        self.bukaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.bukaiBtn.backgroundColor = [UIColor whiteColor];
        self.bukaiBtn.selected = NO;
        self.kaiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.kaiBtn.backgroundColor = [UIColor whiteColor];
        self.kaiBtn.selected = NO;
        self.fapiaoTaitouView.hidden = NO;
        self.fapiaoNeirongView.hidden = NO;
    } else {

        self.fapiaoTypeLabel.text = [NSString stringWithFormat:@"%.2f%%普通发票", self.puShui ];
        self.suijinLabel.text = [NSString stringWithFormat:@"¥%.2f", self.puShui  * [self.dataDict[@"totalMoney"] floatValue]];
        
        self.shuiJin = self.puShui * [self.dataDict[@"totalMoney"] floatValue];
        self.isSure = 2;

        self.zengzhiBtn.layer.borderColor = UIColorFromRGB(0xCCCCCC).CGColor;
        self.zengzhiBtn.backgroundColor = [UIColor whiteColor];
        self.zengzhiBtn.selected = NO;

        self.bukaiBtn.backgroundColor = [UIColor whiteColor];
        self.bukaiBtn.selected = NO;
        self.fapiaoTaitouView.hidden = NO;
        self.fapiaoNeirongView.hidden = NO;
    }
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
- (IBAction)morenBtnClick:(id)sender {
    self.morenBtn.selected = !self.morenBtn.selected;
}

//发票的设置
- (IBAction)sureFapiaoBtnClick:(id)sender {
    if (self.bukaiBtn.selected) {
        self.fapiaoXianshilabel.text = [NSString stringWithFormat:@"不开发票"];
        self.invoice = @"1";

    } else if (self.kaiBtn.selected) {
        if (self.isSelect == YES) {
            self.fapiaoXianshilabel.text = @"普票(个人)";
            self.invoice = @"0";
            self.invoice_type = 1;
        } else if (self.isSelect == NO) {

            self.fapiaoXianshilabel.text = @"普票(单位)";
            self.invoice = @"10";
            self.invoice_type = 1;
        }
    } else if (self.zengzhiBtn.selected) {
        if (self.isSelect == YES) {
            self.fapiaoXianshilabel.text = @"增值(个人)";
            self.invoice = @"0";
            self.invoice_type = 2;
        } else if (self.isSelect == NO) {
            self.fapiaoXianshilabel.text = @"增值(单位)";
            self.invoice = @"10";
            self.invoice_type = 2;
        }
    }
    [self.view layoutIfNeeded];
    [self.faPiaoView removeFromSuperview];
}

- (IBAction)jifenBtnCLick:(id)sender {
    self.jifenBtn.selected = !self.jifenBtn.selected;

    if (self.jifenBtn.selected) {
        self.isJifen = 1;
    } else {
        self.isJifen = 0;
    }
    float money = 0;
    if (!self.jifenBtn.selected) {
        self.jifenLabel.text = @"¥0";
        money = [self.dataDict[@"totalMoney"] floatValue] - self.youhuiquan + self.shuiJin + self.yunfei;
    } else {

        if (self.jifen > ([self.dataDict[@"totalMoney"] floatValue] + self.shuiJin + self.yunfei - self.youhuiquan)) {
            money = 0;
            self.jifenLabel.text = [NSString stringWithFormat:@"¥%.2f", [self.dataDict[@"totalMoney"] floatValue]  + self.shuiJin + self.yunfei - self.youhuiquan];
        } else {
            self.jifenLabel.text = [NSString stringWithFormat:@"¥%d", self.jifen];
            money = [self.dataDict[@"totalMoney"] floatValue] - self.jifen - self.youhuiquan + self.shuiJin + self.yunfei;
        }
    }
    NSLog(@"-----%d", self.youhuiquan);
    self.allPayLabel.text = [NSString stringWithFormat:@"%.2f", money];
    self.bottemMoneyLabel.text = [NSString stringWithFormat:@"¥%.2f", money];
    self.zhifuMoneyLabel.text = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", money];
}
//地址的选择
- (IBAction)addressBtnClick:(id)sender {
    //   [self.addressView removeFromSuperview];
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}
//确认添加地址
- (IBAction)addAddressBtnClicked:(id)sender {
    int isfault = 0;

    isfault = (self.morenBtn.selected == YES) ? 1 : 0;

    NSDictionary *params = @{
        @"region": self.addressStr,
        @"name": self.nameTF.text,
        @"phone": self.phoneTF.text,
        @"detail": self.detailAddressTF.text,
        @"isdefault": @(isfault)
    };
    [DZNetworkingTool postWithUrl:kAddressAdd
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                self.NameLabel.text = [NSString stringWithFormat:@"收件人:%@", self.nameTF.text];
                self.phoneLabel.text = self.phoneTF.text;
                self.detailLabel.text = [NSString stringWithFormat:@"详细地址:%@%@", self.addressBtn.titleLabel.text, self.detailAddressTF.text];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
    [self.addressView removeFromSuperview];
}
- (IBAction)peisongBtnClick:(id)sender {
    
    
}

#pragma mark – 懒加载
- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}
@end
