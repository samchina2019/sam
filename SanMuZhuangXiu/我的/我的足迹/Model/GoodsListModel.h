//
//  GoodsListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/24.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsListModel : NSObject
@property (nonatomic, assign) int zujiId;
//商品id
@property (nonatomic, assign) int goods_id;
//商品名
@property (nonatomic, strong) NSString *goods_name;
///店铺id
@property (nonatomic, assign) int store_id;
//店铺名
@property (nonatomic, strong) NSString *store_name;
//商品图
@property (nonatomic, strong) NSString *goods_image;
//商品最低价
@property (nonatomic, strong) NSString *goods_price;
//最近访问时间
@property (nonatomic, assign) int updatetime;
@end

NS_ASSUME_NONNULL_END
