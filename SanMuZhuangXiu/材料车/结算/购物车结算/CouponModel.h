//
//  CouponModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/21.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CouponModel : NSObject

//优惠券id
@property(nonatomic,assign)NSInteger coupon_id;
//金额
@property(nonatomic,strong)NSString *money;
//门槛
@property(nonatomic,strong)NSString *threshold;

@end

NS_ASSUME_NONNULL_END
