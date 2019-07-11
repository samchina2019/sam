//
//  JiFenOrderModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiFenOrderModel : NSObject
//商品ID
@property (nonatomic, assign) NSInteger order_id;
//商品n名字
@property (nonatomic, strong) NSString *pay_price;
//分类ID
@property (nonatomic, assign) NSInteger order_no;
//商品名
@property (nonatomic, strong) NSString *pay_status;
//图片
@property (nonatomic, strong) NSString *freight_status;
//店铺ID
@property (nonatomic, strong) NSString *receipt_status;
//店铺名
@property (nonatomic, strong) NSString *order_status;
//商品ID
@property (nonatomic, assign) int user_id;
//商品ID
@property (nonatomic, assign) int createtime;
//店铺名
@property (nonatomic, strong) NSString *score;
//店铺名
@property (nonatomic, strong) NSString *goods_name;
//店铺名
@property (nonatomic, strong) NSString *goods_img;
//店铺名
@property (nonatomic, strong) NSString *goods_price;

@property (nonatomic, assign) int goods_num;
//店铺名
@property (nonatomic, strong) NSString *goods_score;
//店铺名
@property (nonatomic, strong) NSString *order_status_name;
//店铺名
@property (nonatomic, strong) NSString *order_status_ing;

@end

NS_ASSUME_NONNULL_END
