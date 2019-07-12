//
//  GoodsModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/30.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsModel : NSObject
//商品ID
@property(nonatomic,assign)int goods_id;
//商品名字
@property(nonatomic,strong)NSString *goods_name;
//商品图片
@property(nonatomic,strong)NSString *images;
//价格
@property(nonatomic,assign)double goods_price;
//数量
@property(nonatomic,assign)int total_num;
@end

NS_ASSUME_NONNULL_END
