//
//  PinpaiModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PinpaiModel : NSObject
//品牌id
@property(nonatomic,assign)NSInteger stuff_brand_id;
//
@property(nonatomic,assign)NSInteger stuff_id;
//名称
@property(nonatomic,strong)NSString *name;
@end

NS_ASSUME_NONNULL_END
