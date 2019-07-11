//
//  GoodsSkuModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSkuModel : NSObject
@property(nonatomic,assign)NSInteger goods_id;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *goods_price;
@property(nonatomic,strong)NSString *images;
@property(nonatomic,assign)NSInteger sales_actual;
@property(nonatomic,strong)NSArray *spec_sku;
@property(nonatomic,assign)int number;
//选中的规格
@property(nonatomic,strong)NSDictionary *selectsGoodsDict;
@end

NS_ASSUME_NONNULL_END
