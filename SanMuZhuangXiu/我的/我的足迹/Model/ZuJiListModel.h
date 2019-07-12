//
//  ZuJiListModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZuJiListModel : NSObject
//id
@property (nonatomic, assign) int zuji_id;
//店铺id
@property (nonatomic, assign) int store_id;
//访问人id
@property (nonatomic, assign) int user_id;
//足迹状态:-1=已删除,1=正常
@property (nonatomic, strong) NSString *status;
//好评比率
@property (nonatomic, strong) NSString *ratio;
//店铺名
@property (nonatomic, strong) NSString *seller_name;
//店铺头像
@property (nonatomic, strong) NSString *store_avatar;
//主营
@property (nonatomic, strong) NSString *seller_type_name;
//星级
@property (nonatomic, assign) int level;
//满
@property (nonatomic, strong) NSString *man;
//减
@property (nonatomic, strong) NSString *subtract;
//付款订单总户数
@property (nonatomic, assign) int order_count;
//距离，（为负值，表示用户或店铺中有一人未上传经纬度）
@property (nonatomic, assign) float distance;
@end

NS_ASSUME_NONNULL_END
