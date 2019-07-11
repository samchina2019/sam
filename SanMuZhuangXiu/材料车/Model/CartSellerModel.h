//
//  CartSellerModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartSellerModel : NSObject
@property(nonatomic, assign) int seller_id;
@property(nonatomic, strong) NSString *seller_name;
@property(nonatomic, assign) int seller_num;
@property(nonatomic, assign) float express_price;
@property(nonatomic, assign) float seller_price;
@property(nonatomic, assign) int coupon;
@property(nonatomic, assign) int haoping;
@property(nonatomic, assign) float seller_taxes;
@property(nonatomic, assign) int seller_coupon;
@property(nonatomic, assign) float seller_pay_price;
@property(nonatomic, strong) NSArray *data;
@property(nonatomic, strong) NSDictionary *invoice;
@property(nonatomic, strong) NSArray *coupons;
@property(nonatomic, assign) float lng;
@property(nonatomic, assign) float lat;
@property(nonatomic, strong) NSDictionary *selectInvoce;
@property(nonatomic, strong) NSDictionary *selectCoupon;
@property(nonatomic, strong) NSDictionary *selectIntegran;

@property(nonatomic, assign) double taxes;

@property(nonatomic, assign) double couponMoney;
//是否存在
@property(nonatomic, assign) BOOL isExist;
//是否删除
@property(nonatomic, assign) BOOL isDelete;
/// 积分使用率
@property(nonatomic, strong) NSString *score_deduction;
///是否可以使用积分
@property(nonatomic, strong) NSString *score_deduction_if;
///使用积分
@property(nonatomic, assign) float yongJifen;
@end

NS_ASSUME_NONNULL_END
