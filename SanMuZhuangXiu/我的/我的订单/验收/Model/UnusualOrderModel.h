//
//  UnusualOrderModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnusualOrderModel : NSObject
@property(nonatomic,assign)int goods_id;
@property(nonatomic,assign)int total_num;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *goods_price;
@property(nonatomic,strong)NSString *stuff_brand_name;
@property(nonatomic,strong)NSArray *stuff_spec_name;
@property(nonatomic,strong)NSString *goods_sku;
@end

NS_ASSUME_NONNULL_END
