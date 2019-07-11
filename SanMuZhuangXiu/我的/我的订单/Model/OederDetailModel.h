//
//  OederDetailModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OederDetailModel : NSObject
@property(nonatomic,strong)NSString *order_name;
@property(nonatomic,assign)double pay_price;

@property(nonatomic,assign)double express_price;

@property(nonatomic,strong)NSString *express_no;

@property(nonatomic,assign)int createtime;
//发货时间
@property(nonatomic,assign)int updatetime;

@property(nonatomic,strong)NSString *order_no;
///发货时间
@property(nonatomic,strong)NSString *freight_time;

@property(nonatomic,assign)int invoice;

@property(nonatomic,strong)NSString * pay_status;

@property(nonatomic,strong)NSString * receipt_status;

@property(nonatomic,strong)NSString * freight_status;

@property(nonatomic,strong)NSString * order_status;

@property(nonatomic,assign)int seller_id;
//订单类型 20 材料单订单 10 普通订单 ******重要 判断依据
@property(nonatomic,assign)int order_type;

@property(nonatomic,strong)NSDictionary *seller;

@property(nonatomic,strong)NSArray *daibgou_data;

@property(nonatomic,strong)NSArray *bendian_dat;
//
@property(nonatomic,strong)NSDictionary *address;
//

//



@end

NS_ASSUME_NONNULL_END
