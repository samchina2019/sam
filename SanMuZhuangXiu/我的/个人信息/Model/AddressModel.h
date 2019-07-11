//
//  AddressModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressModel : NSObject
@property(nonatomic,assign)int address_id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *phone;
@property(nonatomic,assign)int province_id;
@property(nonatomic,assign)int city_id;
@property(nonatomic,assign)int region_id;
@property(nonatomic,strong)NSString *detail;
@property(nonatomic,assign)int user_id;
//是否默认:0=非默认,1=默认地址
@property(nonatomic,strong)NSString *isdefault;
@property(nonatomic,assign)int createtime;
@property(nonatomic,assign)int updatetime;
@property(nonatomic,strong)NSString *lng;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSDictionary *Area;
//1:上次 0:不是上次
@property(nonatomic,strong)NSString *last_time;

@end

NS_ASSUME_NONNULL_END
