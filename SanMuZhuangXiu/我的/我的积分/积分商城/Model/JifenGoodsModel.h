//
//  JifenGoodsModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JifenGoodsModel : NSObject
//商品ID
@property (nonatomic, assign) int goods_id;
//商品n名字
@property (nonatomic, strong) NSString *goods_name;
//分类ID
@property (nonatomic, assign) int category_id;
//商品名
@property (nonatomic, strong) NSString *line_price;
//图片
@property (nonatomic, strong) NSString *images;
//店铺ID
@property (nonatomic, strong) NSString *goods_price;
//店铺名
@property (nonatomic, strong) NSString *goods_score;
@end

NS_ASSUME_NONNULL_END
