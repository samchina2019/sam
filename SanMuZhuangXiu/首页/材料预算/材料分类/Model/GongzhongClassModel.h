//
//  GongzhongClassModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GongzhongClassModel : NSObject

//工种ID
@property(nonatomic,assign)NSInteger stuff_work_id;
//名称
@property(nonatomic,strong)NSString *name;
//图标
@property(nonatomic,strong)NSString *image;
//选中图标
@property(nonatomic,strong)NSString *selectimage;
//材料分类
@property(nonatomic,strong)NSArray *category;

//+(instancetype)gongzhongClassWithDict:(NSDictionary *)dict;
//-(instancetype)initWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
