//
//  CartGoodListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartGoodListModel : NSObject
@property(nonatomic,strong)NSString * cart_id;
@property(nonatomic,assign)int category_id;
//
@property(nonatomic,assign)int goods_id;
//
@property(nonatomic,strong)NSString *goods_name;
//
@property(nonatomic,strong)NSString *images;

@property(nonatomic,assign)int deduct_stock_type;
//
@property(nonatomic,assign)int seller_id;
@property(nonatomic,strong)NSString *seller_name;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *goods_sku_id;

@property(nonatomic,assign)float lng;
@property(nonatomic,assign)float lat;
@property(nonatomic,strong)NSString *goods_spec_id;
@property(nonatomic,strong)NSString *goods_no;
@property(nonatomic,strong)NSString *line_price;
///品牌
@property(nonatomic,strong)NSString *stuff_brand_name;
///规格
@property(nonatomic,strong)NSString *stuff_spec_name;
//
@property(nonatomic,assign)int total_num;
@property (nonatomic, strong) NSString *goods_price;
//
@property(nonatomic,assign)int show_error;
@property(nonatomic,strong)NSString *total_price;
@property(nonatomic,strong)NSString *score_deduction;
///1，代表可以
@property(nonatomic,strong)NSString *score_deduction_if;
// "score_deduction" = "0.05";
//"score_deduction_if" = 1;

@end

NS_ASSUME_NONNULL_END
