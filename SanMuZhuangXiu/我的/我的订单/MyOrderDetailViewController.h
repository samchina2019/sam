//
//  MyOrderDetailViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderDetailViewController : DZBaseViewController
@property(nonatomic,assign)NSInteger orderId;
@property(nonatomic,assign)NSInteger orderType; //20：材料单订单 10 订单
@property (assign, nonatomic) int type;//20 待付款 30待收货 40已取消 50 已完成
@property (nonatomic , strong) NSString *order_status_name;//评价状态
@property(nonatomic,assign)NSInteger order_evalu;
@end

NS_ASSUME_NONNULL_END
