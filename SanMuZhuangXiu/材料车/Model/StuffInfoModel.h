//
//  StuffInfoModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuffInfoModel : NSObject
//材料id
@property(nonatomic,assign)int stuff_id;
//材料品牌id
@property(nonatomic,assign)NSInteger stuff_brand_id;
//材料数量
@property(nonatomic,strong)NSString * stuff_brand_name;
//材料名称
@property(nonatomic,strong)NSString *stuff_name;
//材料规格id
@property(nonatomic,strong)NSString * stuff_spec_id;
//材料规格名称
@property(nonatomic,strong)NSString *stuff_spec_name;
@property(nonatomic,strong)NSString *stuff_spec;
//材料单位
@property(nonatomic,strong)NSString *unit;
//数量
@property(nonatomic,assign)int number;
//材料data id 用于重新编辑时删除
@property(nonatomic,assign)int stuff_data_id;
@property(nonatomic,strong)NSArray *brand_list;
@property(nonatomic,strong)NSArray *spec_list;
//选中的规格

@property(nonatomic,strong)NSDictionary *selectsSpecDict;

@end

NS_ASSUME_NONNULL_END
