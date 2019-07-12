//
//  GoodsDetailModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailModel : NSObject
@property(nonatomic,assign)int goods_id;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,assign)int category_id;
@property(nonatomic,assign)int stuff_id;
@property(nonatomic,strong)NSString *spec_type;
@property(nonatomic,strong)NSString *deduct_stock_type;
@property(nonatomic,strong)NSArray *contentimages;
@property(nonatomic,strong)NSString *paramsimages;
@property(nonatomic,assign)int sales_initial;
@property(nonatomic,assign)int sales_actual;
@property(nonatomic,assign)int goods_sort;
@property(nonatomic,assign)int delivery_id;
@property(nonatomic,strong)NSString *goods_status;
@property(nonatomic,strong)NSString *is_delete;
@property(nonatomic,assign)int createtime;
@property(nonatomic,assign)int updatetime;
@property(nonatomic,assign)int seller_id;
@property(nonatomic,assign)int evalu_num;
@property(nonatomic,assign)int total_star;
@property(nonatomic,assign)int good_times;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSArray *spec;
@property(nonatomic,strong)NSString *place_origin;
@property(nonatomic,strong)NSString *packing;
@property(nonatomic,assign)NSInteger stock_num;
@property(nonatomic,strong)NSString *instructions;
@property(nonatomic,strong)NSString *goods_price;
@property(nonatomic,strong)NSString *goods_no;
@property(nonatomic,strong)NSArray *brand_data;
@property(nonatomic,strong)NSArray *spec_data;
@property(nonatomic,strong)NSArray *imgs_url;
@property(nonatomic,strong)NSDictionary *category;
@property(nonatomic,assign)NSInteger goods_sales;
@property(nonatomic,strong)NSString *goods_introduce;
@end

NS_ASSUME_NONNULL_END
