//
//  MallSellerList.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/27.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MallSellerList : NSObject

//店铺id
@property(nonatomic,assign)NSInteger seller_id;
//店铺名
@property(nonatomic,strong)NSString *seller_name;
//店铺类型
@property(nonatomic,strong)NSString *seller_type_name;
//经营类型，店铺描述
@property(nonatomic,strong)NSString *store_desc;
//店铺经度
@property(nonatomic,assign)double lng;
//店铺纬度
@property(nonatomic,assign)double lat;
//店铺图片
@property(nonatomic,strong)NSString *store_avatar;
//评价星总和
@property(nonatomic,assign)NSInteger total_star;
//评价次数
@property(nonatomic,assign)NSInteger evalu_num;
//好评次数
@property(nonatomic,assign)NSInteger good_num;

//开始金额，运费就是起步金额，满减就是满多少
@property(nonatomic,assign)double man;
//结束金额，满减就是减多少
@property(nonatomic,assign)double subtract;
//好评比率
@property (nonatomic, assign) double ratio;
//距离单位km
@property(nonatomic,assign)double distance;
//等级
@property(nonatomic,assign)NSInteger level;

//已买多少人
@property(nonatomic,assign)NSInteger order_count;
//配送费
@property(nonatomic,strong)NSString *distribution_fee;

@end

NS_ASSUME_NONNULL_END
