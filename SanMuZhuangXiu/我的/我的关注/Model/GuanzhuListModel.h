//
//  GuanzhuListModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuanzhuListModel : NSObject
//关注id
@property (nonatomic, assign) int follow_id;
//类型
@property (nonatomic, strong) NSString *type;
//type=10 商品id type=20 店铺id
@property (nonatomic, assign) int follow_data_id;
//商品名
@property (nonatomic, strong) NSString *name;
//图片
@property (nonatomic, strong) NSString *img;
//店铺ID
@property (nonatomic, assign) int seller_id;
//店铺名
@property (nonatomic, strong) NSString *seller_name;
//价格
@property (nonatomic, strong) NSString *price;
//
@property (nonatomic, strong) NSString *goods_sku;
//
@property (nonatomic, strong) NSString *service_type;
//
@property (nonatomic, assign) int createtime;
//
@property (nonatomic, assign) int user_id;
//
@property (nonatomic, strong) NSString *seller_img;
//星级
@property (nonatomic, assign) int star_class;
//销售数
@property (nonatomic, assign) int purchase;
//主营
@property (nonatomic, strong) NSString *notice;
// 活动
@property (nonatomic, strong) NSString *sales;
// 运费
@property (nonatomic, strong) NSString *express_price;
//距离
@property (nonatomic, assign) float distance;

@property(nonatomic,strong)NSString *address;
@property(nonatomic,strong)NSString *time_text;



@end

NS_ASSUME_NONNULL_END
