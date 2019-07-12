//
//  SpecSkuModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecSkuModel : NSObject
@property(nonatomic,assign)NSInteger brand_id;
@property(nonatomic,strong)NSString *brand;
@property(nonatomic,strong)NSString *goods_price;
@property(nonatomic,strong)NSString *spec;
@property(nonatomic,assign)NSInteger spec_id;
@property(nonatomic,strong)NSString *spec_image;
@property(nonatomic,strong)NSString *spec_sku_id;
@property(nonatomic,assign)NSInteger stock_num;
@end

NS_ASSUME_NONNULL_END
