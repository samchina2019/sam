//
//  HebingCartModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HebingCartModel : NSObject
//
@property(nonatomic,assign)int number;
//
@property(nonatomic,assign)int stuff_id;
//
@property(nonatomic,assign)int stuff_brand_id;
//
@property(nonatomic,strong)NSString *stuff_brand_name;
//
@property(nonatomic,assign)int stuff_spec_id;
//
@property(nonatomic,strong)NSString *stuff_spec_name;
//
@property(nonatomic,strong)NSString *stuff_name;
@end

NS_ASSUME_NONNULL_END
