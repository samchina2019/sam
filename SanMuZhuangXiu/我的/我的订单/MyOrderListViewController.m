//
//  MyOrderListViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MyOrderListViewController.h"
//跳转controller
#import "MyOrderDetailViewController.h"
#import "CaiLiaoFenLeiViewController.h"
#import "StoreDetailViewController.h"
#import "ChangePasswordViewController.h"
#import "UnusualViewController.h"
#import "AppraiseViewController.h"
#import "ChatViewController.h"
//cell
#import "MyOrderListCell.h"
#import "MyOrderImgListCell.h"
#import "ZhiFuSelectTypeView.h"
//model
#import "OrderModel.h"
#import "GoodsModel.h"
#import "MallSellerList.h"

#import "UIButton+Code.h"
#import "JYTimerUtil.h"
//支付
#import <AlipaySDK/AlipaySDK.h>
#import "WXApiManager.h"

@interface MyOrderListViewController ()

@property (strong, nonatomic) ZhiFuSelectTypeView *zhiFuSelectView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) NSString *orderNo;

@end

@implementation MyOrderListViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderListCell" bundle:nil] forCellReuseIdentifier:@"MyOrderListCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MyOrderImgListCell" bundle:nil] forCellReuseIdentifier:@"MyOrderImgListCell"];
    [self.tableView.mj_header beginRefreshing];

    [[JYTimerUtil sharedInstance] timerStart];
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

    NSDictionary *dict = @{
        @"type": @(self.type),
        @"page": @(_page),
        @"limit": @(8)
    };
    [DZNetworkingTool postWithUrl:kmyOrderList
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
                NSArray *array = responseObject[@"data"][@"data"];

                //字典转模型1
                //                NSArray *tempArray = [StoreModel mj_objectArrayWithKeyValuesArray:array];
                //                [self.dataArray addObjectsFromArray:tempArray];
                //字典转模型2
                for (NSDictionary *dict in array) {
                    OrderModel *model = [OrderModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
            }
             [self.tableView reloadData];
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
    OrderModel *model = self.dataArray[indexPath.row];
    if (model.order_type == 20) {
        return 200;
    } else {
        return model.goods.count * 110 + 140;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrderModel *model = self.dataArray[indexPath.row];

    if (model.order_type == 20) { //材料单订单
        MyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderListCell" forIndexPath:indexPath];
        cell.statusLabel.text = [NSString stringWithFormat:@"%@", model.order_status_name];

        NSInteger ststus = model.order_status_ing;
        cell.functionrightBtn.hidden = NO;

        if (ststus == 20) { //未支付
            cell.pingjiaBtn.hidden = YES;
            cell.functionleftBtn.hidden = NO;
            cell.deleteBtn.hidden = YES;

            [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            [cell.functionrightBtn setBackgroundColor:UIColorFromRGB(0x3FAEE9)];
            [cell.functionrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
            cell.functionrightBtn.layer.borderWidth = 1;

            cell.model = model;
            cell.timeLabel.hidden = NO;
            cell.pingjiaBlock = ^{

            };
            cell.deleteBlock = ^{

            };
            cell.quxiaoBlock = ^{
                [self cancelOrderWithId:model.order_id];
            };

            cell.rightBlock = ^{
                //label富文本
                self.orderNo = [NSString stringWithFormat:@"%@", model.order_no];
                NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
                NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", model.pay_price];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", model.pay_price]];
                [attrStr setAttributes:attributeDict range:range];

                //转场动画
                CATransition *animation = [CATransition animation];
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromTop;
                animation.duration = 0.25;
                [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];

                self.zhiFuSelectView.moneyLabel.attributedText = attrStr;

                [[DZTools getAppWindow] addSubview:self.zhiFuSelectView];

            };
        } else if (ststus == 30) { //待收货
            cell.deleteBtn.hidden = YES;
            cell.pingjiaBtn.hidden = YES;
            cell.timeLabel.hidden = YES;

            cell.deleteBlock = ^{

            };
            if ([model.order_status_name containsString:@"已发货"]) {
                cell.functionleftBtn.hidden = YES;

                [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.functionrightBtn setTitle:@"准备收货" forState:UIControlStateNormal];
                [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
                cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.functionrightBtn.layer.borderWidth = 1;
                cell.quxiaoBlock = ^{

                };
                cell.pingjiaBlock = ^{

                };
                cell.rightBlock = ^{
                    [self yichangOrder:model.order_id];
                };
            } else if ([model.order_status_name containsString:@"未发货"]) {
                cell.functionleftBtn.hidden = NO;
                [cell.functionleftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cell.functionleftBtn setBackgroundColor:[UIColor whiteColor]];
                cell.functionleftBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.functionleftBtn.layer.borderWidth = 1;
                if ([model.reminder isEqualToString:@"0"]) {
                    [cell.functionrightBtn setTitle:@"我要催单" forState:UIControlStateNormal];
                    cell.functionrightBtn.userInteractionEnabled = YES;
                } else {
                    cell.functionrightBtn.userInteractionEnabled = NO;
                    [cell.functionrightBtn setTitle:@"已催单" forState:UIControlStateNormal];
                }
                cell.pingjiaBlock = ^{

                };
                cell.quxiaoBlock = ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消订单需向商家赔偿¥100元" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         [self cancelOrderWithId:model.order_id];
                                                                     }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *_Nonnull action){

                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:nil];

                };
                cell.rightBlock = ^{
                    [self cuidanWithModel:model.order_id];
                };
            } else if ([model.order_status_name containsString:@"未接单"]) {
                cell.functionleftBtn.hidden = NO;
                [cell.functionleftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cell.functionleftBtn setBackgroundColor:[UIColor whiteColor]];
                cell.functionleftBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.functionleftBtn.layer.borderWidth = 1;
                if ([model.reminder isEqualToString:@"0"]) {
                    [cell.functionrightBtn setTitle:@"我要催单" forState:UIControlStateNormal];
                    cell.functionrightBtn.userInteractionEnabled = YES;
                } else {
                    cell.functionrightBtn.userInteractionEnabled = NO;
                    [cell.functionrightBtn setTitle:@"已催单" forState:UIControlStateNormal];
                }
                cell.pingjiaBlock = ^{

                };
                cell.quxiaoBlock = ^{
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消订单需向商家赔偿¥100元" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         [self cancelOrderWithId:model.order_id];
                                                                     }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *_Nonnull action){

                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:nil];
                };
                cell.rightBlock = ^{
                    [self cuidanWithModel:model.order_id];
                };
            } else if ([model.order_status_name isEqualToString:@"异常"]) {
                cell.functionleftBtn.hidden = YES;
                cell.functionrightBtn.hidden = YES;
            }
        } else if (ststus == 40) { //已取消
            cell.pingjiaBtn.hidden = YES;
            cell.deleteBtn.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.functionleftBtn.hidden = NO;

            [cell.functionleftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitle:@"继续购买" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
            cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
            cell.functionrightBtn.layer.borderWidth = 1;
            //            cell.statusLabel.text = @"已取消";
            cell.quxiaoBlock = ^{
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self deleteOrderWithModel:model.order_id];              }]];
                [self presentViewController:alertC animated:YES completion:nil];
            };

            cell.rightBlock = ^{
                self.hidesBottomBarWhenPushed = YES;
                CaiLiaoFenLeiViewController *vc = [[CaiLiaoFenLeiViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            };
            cell.pingjiaBlock = ^{

            };
        } else if (ststus == 50) {//已完成
            if (model.order_evalu == 0) { //没有评价
                cell.deleteBtn.hidden = NO;
                cell.pingjiaBtn.hidden = NO;
                [cell.pingjiaBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.pingjiaBtn setBackgroundColor:[UIColor whiteColor]];
                cell.pingjiaBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.pingjiaBtn.layer.borderWidth = 1;
                cell.pingjiaBlock = ^{ //评价
                    self.parentViewController.hidesBottomBarWhenPushed = YES;
                    AppraiseViewController *controller = [[AppraiseViewController alloc] init];
                    controller.idFromList = YES;
                    controller.order_type = model.order_type;
                    //                controller.nameLabel.text = @"给商品打分";
                    controller.order_id = model.order_id;
                    [self.navigationController pushViewController:controller animated:YES];
                    self.parentViewController.hidesBottomBarWhenPushed = YES;
                };
                [cell.deleteBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.deleteBtn setBackgroundColor:[UIColor whiteColor]];
                cell.deleteBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.deleteBtn.layer.borderWidth = 1;
                cell.deleteBlock = ^{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                             }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                                 [self deleteOrderWithModel:model.order_id];              }]];
                    [self presentViewController:alertC animated:YES completion:nil];
                };
            }else if(model.order_evalu == 1){//已经评价
                cell.deleteBtn.hidden = YES;
                cell.pingjiaBtn.hidden = NO;
                [cell.pingjiaBtn setTitle:@"删 除" forState:UIControlStateNormal];
                [cell.pingjiaBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.pingjiaBtn setBackgroundColor:[UIColor whiteColor]];
                cell.pingjiaBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.pingjiaBtn.layer.borderWidth = 1;
                cell.pingjiaBlock = ^{//删除
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                             }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                                 [self deleteOrderWithModel:model.order_id];              }]];
                    [self presentViewController:alertC animated:YES completion:nil];
                };
            }
          
            cell.timeLabel.hidden = YES;

            cell.functionleftBtn.hidden = NO;
            [cell.functionleftBtn setTitle:@"申请售后" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitle:@"再来一单" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
            cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
            cell.functionrightBtn.layer.borderWidth = 1;
            //            cell.statusLabel.text = @"已完成";
            cell.quxiaoBlock = ^{//售后
                [self shouhouWithModel:model];
            };

            cell.rightBlock = ^{
                //再来一单
                self.hidesBottomBarWhenPushed = YES;
                CaiLiaoFenLeiViewController *vc = [[CaiLiaoFenLeiViewController alloc] init];
                [self.navigationController pushViewController:vc animated:YES];
                self.hidesBottomBarWhenPushed = YES;
            };
        }
        NSDictionary *dict = model.seller;
        [cell.storeNameBtn setTitle:dict[@"seller_name"] forState:UIControlStateNormal];
        cell.classNumLabel.text = [NSString stringWithFormat:@"材料种类：%d", model.type_num];
        cell.numLabel.text = [NSString stringWithFormat:@"数量：%d", model.total_num];
        cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", model.pay_price];
        cell.orderNameLabel.text = model.order_name;

        return cell;
    } else { //c=购物车订单
        MyOrderImgListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyOrderImgListCell" forIndexPath:indexPath];
        cell.statusLabel.text = [NSString stringWithFormat:@"%@", model.order_status_name];
        [cell.storeNameBtn setTitle:model.order_name forState:UIControlStateNormal];
        cell.totalNumLabel.text = [NSString stringWithFormat:@"共 %d 件，实付款：", model.total_num];
        cell.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f", model.pay_price];
        NSInteger ststus = model.order_status_ing;
        cell.functionrightBtn.hidden = NO;

        if (ststus == 20) { //待付款
            cell.deleteBtn.hidden = YES;
            cell.timeLabel.hidden = NO;
            cell.pingjiaBtn.hidden = YES;
            cell.functionleftBtn.hidden = NO;

            [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitle:@"立即付款" forState:UIControlStateNormal];
            [cell.functionrightBtn setBackgroundColor:UIColorFromRGB(0x3FAEE9)];
            [cell.functionrightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0x3FAEE9).CGColor;
            cell.functionrightBtn.layer.borderWidth = 1;

            cell.quxiaoBlock = ^{ //取消
                [self cancelOrderWithId:model.order_id];
            };
            cell.pingjiaBlock = ^{

            };
            cell.rightBlock = ^{ //立即支付
                self.orderNo = [NSString stringWithFormat:@"%@", model.order_no];
                NSDictionary *attributeDict = @{NSForegroundColorAttributeName: [UIColor colorWithRed:252 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0]};
                NSString *textStr = [NSString stringWithFormat:@"请在24小时之内完成支付  金额¥%.2f元", model.pay_price];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:textStr];
                NSRange range = [textStr rangeOfString:[NSString stringWithFormat:@"¥%.2f", model.pay_price]];
                [attrStr setAttributes:attributeDict range:range];

                //转场动画
                CATransition *animation = [CATransition animation];
                animation.type = kCATransitionMoveIn;
                animation.subtype = kCATransitionFromTop;
                animation.duration = 0.25;
                [self.zhiFuSelectView.layer addAnimation:animation forKey:@"kTransitionAnimation"];

                self.zhiFuSelectView.moneyLabel.attributedText = attrStr;
                [[DZTools getAppWindow] addSubview:self.zhiFuSelectView];
            };

        } else if (ststus == 30) { //待付款
            cell.deleteBtn.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.pingjiaBtn.hidden = YES;
            if ([model.order_status_name containsString:@"已发货"]) {
                cell.functionleftBtn.hidden = YES;

                [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.functionrightBtn setTitle:@"准备收货" forState:UIControlStateNormal];
                [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
                cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.functionrightBtn.layer.borderWidth = 1;
                cell.pingjiaBlock = ^{
                };
                cell.quxiaoBlock = ^{
                };
                cell.rightBlock = ^{ //收货异常
                    [self yichangOrder:model.order_id];
                };
            } else if ([model.order_status_name containsString:@"未发货"]) {
                cell.functionleftBtn.hidden = NO;

                [cell.functionleftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cell.functionleftBtn setBackgroundColor:[UIColor whiteColor]];
                cell.functionleftBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.functionleftBtn.layer.borderWidth = 1;
                if ([model.reminder isEqualToString:@"0"]) {
                    [cell.functionrightBtn setTitle:@"我要催单" forState:UIControlStateNormal];
                    cell.functionrightBtn.userInteractionEnabled = YES;
                } else {
                    cell.functionrightBtn.userInteractionEnabled = NO;
                    [cell.functionrightBtn setTitle:@"已催单" forState:UIControlStateNormal];
                }
                cell.pingjiaBlock = ^{

                };
                cell.quxiaoBlock = ^{ //取消
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消订单需向商家赔偿¥100元" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         [self cancelOrderWithId:model.order_id];
                                                                     }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *_Nonnull action){

                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:nil];

                };

                cell.rightBlock = ^{ //催单
                    [self cuidanWithModel:model.order_id];
                };
            } else if ([model.order_status_name containsString:@"未接单"]) {
                cell.functionleftBtn.hidden = NO;
                [cell.functionleftBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.functionleftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [cell.functionleftBtn setBackgroundColor:[UIColor whiteColor]];
                cell.functionleftBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.functionleftBtn.layer.borderWidth = 1;

                if ([model.reminder isEqualToString:@"0"]) {
                    [cell.functionrightBtn setTitle:@"我要催单" forState:UIControlStateNormal];
                    cell.functionrightBtn.userInteractionEnabled = YES;
                } else {
                    [cell.functionrightBtn setTitle:@"已催单" forState:UIControlStateNormal];
                    cell.functionrightBtn.userInteractionEnabled = NO;
                }
                cell.pingjiaBlock = ^{

                };
                cell.quxiaoBlock = ^{ //取消
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"取消订单需向商家赔偿¥100元" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         [self cancelOrderWithId:model.order_id];
                                                                     }];
                    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消"
                                                                           style:UIAlertActionStyleDefault
                                                                         handler:^(UIAlertAction *_Nonnull action){

                                                                         }];
                    [alert addAction:cancelAction];
                    [alert addAction:okAction];

                    [self presentViewController:alert animated:YES completion:nil];
                };
                cell.rightBlock = ^{ //催单
                    [self cuidanWithModel:model.order_id];
                };
            } else if ([model.order_status_name containsString:@"异常"]) {
                cell.functionleftBtn.hidden = YES;
                cell.functionrightBtn.hidden = YES;
            }
        } else if (ststus == 40) { //已完成
            cell.pingjiaBtn.hidden = YES;
            cell.deleteBtn.hidden = YES;
            cell.timeLabel.hidden = YES;
            cell.pingjiaBlock = ^{

            };
            cell.functionleftBtn.hidden = NO;
            [cell.functionleftBtn setTitle:@"删除订单" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitle:@"继续购买" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
            cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
            cell.functionrightBtn.layer.borderWidth = 1;
            //            cell.statusLabel.text = @"已取消";
            cell.quxiaoBlock = ^{ //删除
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                         }]];
                [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                           style:UIAlertActionStyleCancel
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self deleteOrderWithModel:model.order_id];              }]];
                [self presentViewController:alertC animated:YES completion:nil];
            };

            cell.rightBlock = ^{
                NSDictionary *dict = model.seller;
                self.parentViewController.hidesBottomBarWhenPushed = YES;
                StoreDetailViewController *vc = [[StoreDetailViewController alloc] init];
                MallSellerList *list = [MallSellerList new];
                list.seller_id = [dict[@"seller_id"] intValue];
                vc.seller_id = list.seller_id;
                [self.navigationController pushViewController:vc animated:YES];
                self.parentViewController.hidesBottomBarWhenPushed = YES;

            };
        } else if (ststus == 50) { //取消
            if (model.order_evalu == 0) { //没有评价
                cell.deleteBtn.hidden = NO;
                cell.pingjiaBtn.hidden = NO;
                
                [cell.pingjiaBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.pingjiaBtn setBackgroundColor:[UIColor whiteColor]];
                cell.pingjiaBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.pingjiaBtn.layer.borderWidth = 1;
                cell.pingjiaBlock = ^{ //评价
                    self.parentViewController.hidesBottomBarWhenPushed = YES;
                    AppraiseViewController *controller = [[AppraiseViewController alloc] init];
                    controller.idFromList = YES;
                    controller.order_type = model.order_type;
                    //                controller.nameLabel.text = @"给商品打分";
                    controller.order_id = model.order_id;
                    [self.navigationController pushViewController:controller animated:YES];
                    self.parentViewController.hidesBottomBarWhenPushed = YES;
                };
                
                [cell.deleteBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.deleteBtn setBackgroundColor:[UIColor whiteColor]];
                cell.deleteBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.deleteBtn.layer.borderWidth = 1;
                cell.deleteBlock = ^{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                             }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                                 [self deleteOrderWithModel:model.order_id];              }]];
                    [self presentViewController:alertC animated:YES completion:nil];
                };
                
            }else if(model.order_evalu == 1){//已经评价
                cell.deleteBtn.hidden = YES;
                cell.pingjiaBtn.hidden = NO;
                 [cell.pingjiaBtn setTitle:@"删 除" forState:UIControlStateNormal];
                [cell.pingjiaBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
                [cell.pingjiaBtn setBackgroundColor:[UIColor whiteColor]];
                cell.pingjiaBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
                cell.pingjiaBtn.layer.borderWidth = 1;
                cell.pingjiaBlock = ^{
                    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *_Nonnull action){
                                                             }]];
                    [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *_Nonnull action) {
                                                                 [self deleteOrderWithModel:model.order_id];              }]];
                    [self presentViewController:alertC animated:YES completion:nil];
                };
                
            }

            cell.timeLabel.hidden = YES;

            cell.functionleftBtn.hidden = NO;
            [cell.functionleftBtn setTitle:@"申请售后" forState:UIControlStateNormal];
            [cell.functionrightBtn setTitle:@"再来一单" forState:UIControlStateNormal];

            [cell.functionrightBtn setTitleColor:UIColorFromRGB(0x666666) forState:UIControlStateNormal];
            [cell.functionrightBtn setBackgroundColor:[UIColor whiteColor]];
            cell.functionrightBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
            cell.functionrightBtn.layer.borderWidth = 1;

            cell.quxiaoBlock = ^{//售后
               [self shouhouWithModel:model];
            };
            
            cell.rightBlock = ^{ //再来一单
                NSDictionary *dict = model.seller;
                self.parentViewController.hidesBottomBarWhenPushed = YES;
                StoreDetailViewController *vc = [[StoreDetailViewController alloc] init];
                MallSellerList *list = [MallSellerList new];
                list.seller_id = [dict[@"seller_id"] intValue];
                vc.seller_id = list.seller_id;
                [self.navigationController pushViewController:vc animated:YES];
                self.parentViewController.hidesBottomBarWhenPushed = YES;

            };
        }
        cell.model = model;
        NSDictionary *dict = model.seller;
        [cell.storeNameBtn setTitle:dict[@"seller_name"] forState:UIControlStateNormal];

        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    OrderModel *model = self.dataArray[indexPath.row];
    int order_status = model.order_status;
    int ststus = model.order_status_ing;
    if (order_status == 40) { //详情（收货异常详情）
        self.parentViewController.hidesBottomBarWhenPushed = YES;
        UnusualViewController *usualViewController = [[UnusualViewController alloc] init];
        usualViewController.type = ststus;
        usualViewController.orderId = model.order_id;
        [self.navigationController pushViewController:usualViewController animated:YES];
        self.parentViewController.hidesBottomBarWhenPushed = YES;

    } else {
        //其他详情
        self.parentViewController.hidesBottomBarWhenPushed = YES;
        MyOrderDetailViewController *controller = [[MyOrderDetailViewController alloc] init];
        controller.type = ststus;
        controller.order_status_name = model.order_status_name;
        controller.order_evalu = model.order_evalu;
        controller.orderType = model.order_type;
        controller.orderId = model.order_id;
        // 进入后隐藏tabbar
        [self.navigationController pushViewController:controller animated:YES];
        self.parentViewController.hidesBottomBarWhenPushed = YES;
    }
}

#pragma mark - Function
-(void)shouhouWithModel:(OrderModel *)model{
    //申请售后
    NSDictionary *dict = @{
                           @"user_id": model.seller[@"seller_id"]
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
                                  conversationVC.targetId = [NSString stringWithFormat:@"%@", model.seller[@"seller_id"]];
                                  conversationVC.title = title;
                                  conversationVC.isShouhou = YES;
                                  conversationVC.orderId = model.order_id;
                                  RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                                  rcduserinfo_.name = title;
                                  rcduserinfo_.userId = [NSString stringWithFormat:@"%@", model.seller[@"seller_id"]];
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
//催单
- (void)cuidanWithModel:(NSInteger)orderId {
    NSDictionary *dict = @{
        @"id": @(orderId)
    };
    [DZNetworkingTool postWithUrl:kReminder
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
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
//删除订单
- (void)deleteOrderWithModel:(NSInteger)orderId {
    //
    NSDictionary *dict = @{
        @"order_id": @(orderId)
    };
    [DZNetworkingTool postWithUrl:kDelOrder
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
//收货异常
- (void)yichangOrder:(NSInteger)orderId {
    NSDictionary *params = @{
        @"order_id": @(orderId),
        @"abnormal": @(1),

    };
    NSLog(@"%@", params);
    [DZNetworkingTool postWithUrl:kReceivGoods
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
}
//取消订单
- (void)cancelOrderWithId:(NSInteger)orderId {
    NSDictionary *dict = @{
        @"cancel_order": @(20),
        @"order_id": @(orderId)
    };

    [DZNetworkingTool postWithUrl:kCancelOrder
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
//余额支付
- (void)payByYueWithPassword:(NSString *)password {
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

                [self.tableView.mj_header beginRefreshing];

            } else {
                NSString *mima = responseObject[@"msg"];
                if ([mima containsString:@"请先设置支付密码"]) {
                    //                    修改密码提示框
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置支付密码，无法支付。是否现在去设置支付密码？" preferredStyle:UIAlertControllerStyleAlert];

                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定"
                                                                       style:UIAlertActionStyleDestructive
                                                                     handler:^(UIAlertAction *_Nonnull action) {
                                                                         //跳转到修改密码
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
//支付类型选择
- (void)zhifufounction:(int)type {
    if (type == 1) { //1余额 2支付宝 3微信
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请输入支付密码" preferredStyle:UIAlertControllerStyleAlert];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.frame = CGRectMake(15, 64, 240, 30);
            textField.placeholder = @"请输入支付密码";
            //设置暗文
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
            @"order_no": self.orderNo,
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
            @"order_no": self.orderNo,
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

#pragma mark – 懒加载
- (ZhiFuSelectTypeView *)zhiFuSelectView {
    if (!_zhiFuSelectView) {
        _zhiFuSelectView = [[ZhiFuSelectTypeView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(MyOrderListViewController *) weakSelf = self;
        _zhiFuSelectView.block = ^(int type) {
           
            [weakSelf zhifufounction:type];
 
            [weakSelf.zhiFuSelectView removeFromSuperview];
        }; //1余额 2支付宝 3微信
    }
    return _zhiFuSelectView;
}
@end
