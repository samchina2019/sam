//
//  BaojiadanGoodsModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaojiadanGoodsModel : NSObject

@property (nonatomic, assign) int category_id;
///后台没标注
@property (nonatomic, assign) int con_price;

@property (nonatomic, assign) float pay_price;
@property (nonatomic, assign) int goods_id;

@property (nonatomic, strong) NSString *goods_name;
@property (nonatomic, strong) NSString *goods_price;
@property (nonatomic, assign) int number;
@property (nonatomic, assign) int total_num;
@property (nonatomic, assign) int stuff_brand_id;
@property (nonatomic, strong) NSString *stuff_brand_name;
@property (nonatomic, assign) int stuff_id;
@property (nonatomic, strong) NSString  *stuff_spec_id;
@property (nonatomic, strong) NSString *stuff_spec_name;
//type==1分类 2工种 0材料
@property (nonatomic, assign) int type;
@property (nonatomic, assign) int selection;
@property (nonatomic, strong) NSString *seller_name;
@property (nonatomic, strong) NSString *data_id;
@property (nonatomic, assign) int num;
@property (nonatomic, assign) int typenum;
@property (nonatomic, assign) float price;
@property (nonatomic, strong) NSArray *stuff_spec;
///是否异常 yes 是
@property (nonatomic, assign) BOOL isYichang;
///破损图片
@property (nonatomic, strong) NSArray *posunUrlArray;
///发错图片
@property (nonatomic, strong) NSArray *facuoUrlArray;
///备注
@property (nonatomic, strong) NSString *beizu;
///商品编号
@property (nonatomic, strong) NSString *goods_sku;
@property (nonatomic, assign) int shidaoNumber;
@property (nonatomic, assign) int facuoNumber;
@property (nonatomic, assign) int posunNumber;
@end

NS_ASSUME_NONNULL_END
