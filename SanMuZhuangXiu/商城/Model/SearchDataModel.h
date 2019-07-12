//
//  SearchDataModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchDataModel : NSObject
//店铺id
@property(nonatomic,assign)NSInteger seller_id;
//店铺名
@property(nonatomic,strong)NSString *seller_name;
//商品id
@property(nonatomic,assign)NSInteger goods_id;
//商品名
@property(nonatomic,strong)NSString *goods_name;
//图片
@property(nonatomic,strong)NSString *images;
//好评次数
@property(nonatomic,assign)NSInteger good_times;
//总评级次数
@property(nonatomic,assign)NSInteger evalu_num;
//满
@property(nonatomic,strong)NSString * start_money;

//减
@property(nonatomic,strong)NSString * end_money;

//最低价
@property(nonatomic,strong)NSString * min_price;

//好评率
@property(nonatomic,strong)NSString * rate;
@end

NS_ASSUME_NONNULL_END
