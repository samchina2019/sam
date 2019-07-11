//
//  SpecGoodsModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/15.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecGoodsModel : NSObject
@property(nonatomic,assign)int goods_spec_id;
@property(nonatomic,strong)NSString *goods_price;
@property(nonatomic,strong)NSString * spec_sku_id;
@property(nonatomic,assign)int stock_num;
@property(nonatomic,strong)NSString *goods_no;
@property(nonatomic,strong)NSString *line_price;
@property(nonatomic,strong)NSString *spec_image;
@property(nonatomic,assign)int goods_sales;
@end

NS_ASSUME_NONNULL_END
