//
//  MyJifenOrderListViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyJifenOrderListViewController.h"
#import "MyjifenOrderListCell.h"
#import "JiFenOrderDetailViewController.h"
#import "JiFenOrderModel.h"
#import "JiFenStoreViewController.h"
#import "ChangePasswordViewController.h"
#import "ZhiFuSelectTypeView.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface MyJifenOrderListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@property (strong, nonatomic) ZhiFuSelectTypeView *zhiFuSelectView;
@property (nonatomic, strong) NSString *order_no;

@end

@implementation MyJifenOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"我的订单";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyjifenOrderListCell" bundle:nil] forCellReuseIdentifier:@"MyjifenOrderListCell"];
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
    //    kJiFenOrderList
    NSDictionary *params = @{
        @"limit": @(20),
        @"page": @(_page)

    };
    [DZNetworkingTool postWithUrl:kJiFenOrderList
        params:params
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
                NSArray *array = responseObject[@"data"];

                for (NSDictionary *dict in array) {
                    JiFenOrderModel *model = [JiFenOrderModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.tableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
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
#pragma mark--UITableView DeleteGate
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
    return 210;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyjifenOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyjifenOrderListCell" forIndexPath:indexPath];
    JiFenOrderModel *model = self.dataArray[indexPath.row];
    cell.orderNumLabel.text = [NSString stringWithFormat:@"订单编号：%ld", (long) model.order_no];
    cell.statusLabel.text = [NSString stringWithFormat:@"%@", model.order_status_name];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.goods_img]];
    cell.orderNameLabel.text = [NSString stringWithFormat:@"%@", model.goods_name];

    cell.priceLabel.text = [NSString stringWithFormat:@"%@积分", model.goods_score];
    if ([model.pay_price integerValue] > 0) {
        cell.priceLabel.text = [NSString stringWithFormat:@"%@积分+¥%@", model.goods_score, model.pay_price];
    }
    NSString *stutes = model.order_status_ing;
    if ([stutes isEqualToString:@"10"]) {
        //        3FAEE9
        [cell.functionrightBtn setBackgroundColor:UIColorFromRGB(0x3FAEE9)];
        [cell.functionrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
        cell.functionrightBtn.layer.borderWidth = 1;
        [cell.functionrightBtn setTitle:@"确认付款" forState:UIControlStateNormal];
        [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        cell.leftBlock = ^{

            [self cancelOrder:model.order_id];
        };
        cell.rightBlock = ^{
            //

            self.order_no = [NSString stringWithFormat:@"%ld", (long) model.order_no];
            if ([model.pay_price floatValue] == 0) {
                NSDictionary *dict = @{ @"order_no": self.order_no };
                [DZNetworkingTool postWithUrl:kJiFenPay
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
            } else {
                NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
                NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", [model.pay_price floatValue]];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", [model.pay_price floatValue]]];
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
        };
    } else if ([stutes isEqualToString:@"20"]) {
        cell.functionleftBtn.hidden = YES;

        [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [cell.functionrightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
        cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        cell.functionrightBtn.layer.borderWidth = 1;
        cell.leftBlock = ^{

        };
        cell.rightBlock = ^{
            [self cancelOrder:model.order_id];

        };
    } else if ([stutes isEqualToString:@"30"]) {

        cell.functionleftBtn.hidden = NO;
        [cell.functionleftBtn setTitle:@"确认收货" forState:UIControlStateNormal];

        [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [cell.functionrightBtn setTitle:@"取消订单" forState:UIControlStateNormal];
        [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
        cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        cell.functionrightBtn.layer.borderWidth = 1;
        cell.leftBlock = ^{

            [self receiveOrder:model.order_id];

        };
        cell.rightBlock = ^{
            [self cancelOrder:model.order_id];
        };
    } else if ([stutes isEqualToString:@"40"]) {
        cell.functionleftBtn.hidden = YES;
        //        [cell.functionleftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
        [cell.functionrightBtn setTitle:@"继续购买" forState:UIControlStateNormal];
        [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
        cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        cell.functionrightBtn.layer.borderWidth = 1;
        cell.rightBlock = ^{
            self.hidesBottomBarWhenPushed = YES;
            JiFenStoreViewController *vc = [[JiFenStoreViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        };
        cell.leftBlock = ^{

        };
    } else if ([stutes isEqualToString:@"50"]) {
        cell.functionleftBtn.hidden = YES;
        //        [cell.functionleftBtn setTitle:@"申请售后" forState:UIControlStateNormal];
        [cell.functionrightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
        [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
        [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
        cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
        cell.functionrightBtn.layer.borderWidth = 1;
        cell.rightBlock = ^{
            self.hidesBottomBarWhenPushed = YES;
            JiFenStoreViewController *vc = [[JiFenStoreViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        };
        cell.leftBlock = ^{

        };
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    JiFenOrderModel *model = self.dataArray[indexPath.row];
    JiFenOrderDetailViewController *viewController = [JiFenOrderDetailViewController new];
    viewController.order_id = model.order_id;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - Function

- (void)receiveOrder:(NSInteger)orderId {
    NSDictionary *dict = @{
        @"order_id": @(orderId)
    };

    [DZNetworkingTool postWithUrl:kJiFenReceivingGoodsr
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
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
}
- (void)cancelOrder:(NSInteger)orderId {
    //
    NSDictionary *dict = @{
        @"order_id": @(orderId)
    };

    [DZNetworkingTool postWithUrl:kJiFenCancelOrder
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
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
                                                          handler:^(UIAlertAction *_Nonnull action) {
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
                                                              [self payByYueWithPassword:textField.text];
                                                          }]];
        [self presentViewController:alertController animated:true completion:nil];
    } else if (type == 4) {
        NSDictionary *params = @{ @"order_no": self.order_no
        };

        [DZNetworkingTool postWithUrl:kJiFenPay
            params:params
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
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
    } else if (type == 2) {

        NSDictionary *dict = @{
            @"type": @"ailpay",
            @"order_no": self.order_no,
            //                               @"pay_password":password
        };
        [DZNetworkingTool postWithUrl:kJiFenPay
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

                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            IsNeedHub:NO];
    } else if (type == 3) {
        NSDictionary *dict = @{
            @"type": @"wechat",
            @"order_no": self.order_no,
            //                               @"pay_password":password
        };
        [DZNetworkingTool postWithUrl:kJiFenPay
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
- (void)payByYueWithPassword:(NSString *)passWord {
    NSDictionary *params = @{ @"type": @"money",
                              @"order_no": self.order_no,
                              @"pay_password": passWord
    };

    [DZNetworkingTool postWithUrl:kJiFenPay
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self refresh];

            } else {
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
                }
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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
