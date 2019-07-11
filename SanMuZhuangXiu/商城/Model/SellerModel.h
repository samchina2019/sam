//
//  SellerModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/30.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SellerModel : NSObject
//店铺id
@property(nonatomic,assign)NSInteger seller_id;
//店铺名
@property(nonatomic,strong)NSString *seller_name;
//店铺电话
@property(nonatomic,strong)NSString *seller_phone;
//店铺星级
@property(nonatomic,assign)NSInteger star_class;
//购买数
@property(nonatomic,assign)NSInteger purchase;
//距离
@property(nonatomic,assign)double distance;
//商品分类
@property(nonatomic,strong)NSArray *goods_category;
///评价数据
@property(nonatomic,assign)NSInteger evaluate;
//店铺详情
@property(nonatomic,strong)NSArray *seller_details;

@end

NS_ASSUME_NONNULL_END
