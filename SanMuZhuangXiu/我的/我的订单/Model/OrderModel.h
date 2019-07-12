//
//  OrderModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject
//订单id
@property(nonatomic,assign)NSInteger order_id;
//定单编号
@property(nonatomic,strong)NSString *order_no;
//订单名称
@property(nonatomic,strong)NSString *order_name;
//价格
@property(nonatomic,assign)double pay_price;
//支付状态:10=未支付,20=已支付
@property(nonatomic,assign)int pay_status;
//收货状态:10=未收货,20=已收货
@property(nonatomic,assign)int receipt_status;
//发货状态:10=未发货,20=已发货
@property(nonatomic,assign)int freight_status;
//订单状态 10=进行中,20=取消,30=已完成,40=订单异常
@property(nonatomic,assign)int order_status;
//订单类型 20 材料单订单 10 普通订单 ******重要 判断依据
@property(nonatomic,assign)int order_type;

@property(nonatomic,assign)int order_status_ing;
//评价状态 0待评价 1已评价 已完成时显示
@property(nonatomic,assign)int order_evalu;
//商品种类数
@property(nonatomic,assign)int type_num;
//商品总数量
@property(nonatomic,assign)int total_num;
//
@property(nonatomic,strong)NSDictionary *seller;
//
@property(nonatomic,strong)NSArray *goods;

@property(nonatomic,assign)NSInteger createtime;
@property(nonatomic,assign)NSInteger payment_term;

@property(nonatomic,strong)NSString *order_status_name;
@property(nonatomic,strong)NSString *reminder;
@end

NS_ASSUME_NONNULL_END
