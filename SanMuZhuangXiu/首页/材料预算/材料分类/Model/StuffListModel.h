//
//  StuffListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface StuffListModel : NSObject
//材料名称
@property(nonatomic ,strong)NSString *stuff_name;
//材料图标
@property(nonatomic ,strong)NSString *image;
//单位
@property(nonatomic ,assign) NSString * unit;
//关联材料IDS
@property(nonatomic ,assign) NSString * relation_stuff;
//自动计算类型
@property(nonatomic ,assign) NSInteger auto_type;
//自动计算规则
@property(nonatomic,assign)NSInteger auto_count;
//材料ID
@property(nonatomic ,assign) NSInteger stuff_id;
//是否自动取整
@property(nonatomic,assign)NSInteger auto_integer;
//比例
@property(nonatomic,assign)NSInteger scale;
//材料品牌
@property(nonatomic,strong)NSArray *brand;
//材料规格
@property(nonatomic,strong)NSArray *spec;
//选中的品牌
@property(nonatomic,strong)NSDictionary *selectBrandDict;

//选中的规格
@property(nonatomic,strong)NSDictionary *selectsSpecDict;

@property(nonatomic,assign)int number;
///是否存在
@property(nonatomic,assign)int isCunzai;

@end

NS_ASSUME_NONNULL_END
