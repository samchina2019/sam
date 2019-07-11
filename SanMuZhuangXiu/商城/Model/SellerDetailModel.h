//
//  SellerDetailModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/30.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SellerDetailModel : NSObject
//地址
@property(nonatomic,strong)NSString *seller_addr;
//店铺名
@property(nonatomic,strong)NSString *seller_name;
//店铺电话
@property(nonatomic,strong)NSString *seller_phone;
//送货时间
@property(nonatomic,strong)NSString *delivery_time;
//经营类别
@property(nonatomic,strong)NSString * business;
//公告
@property(nonatomic,strong)NSString * notice;
//公告
@property(nonatomic,strong)NSArray * seller_imgs;
@end

NS_ASSUME_NONNULL_END
