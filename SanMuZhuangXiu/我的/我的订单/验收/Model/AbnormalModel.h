//
//  AbnormalModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AbnormalModel : NSObject
@property(nonatomic,assign)int goods_id;
@property(nonatomic,assign)int user_id;
@property(nonatomic,assign)int order_id;
@property(nonatomic,assign)int true_to;
@property(nonatomic,assign)int damaged;
@property(nonatomic,assign)int mistake;
@property(nonatomic,strong)NSString *damaged_img;
@property(nonatomic,strong)NSString *mistake_img;
@property(nonatomic,strong)NSString *examine;
@property(nonatomic,strong)NSString *goods_sku;
@property(nonatomic,strong)NSString *goods_name;
@property(nonatomic,strong)NSString *brand_name;
@property(nonatomic,strong)NSString *stuff_brand_name;
@property(nonatomic,strong)NSArray *spec_name;
@end

NS_ASSUME_NONNULL_END
