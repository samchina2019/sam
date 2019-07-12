//
//  CartOrdeInfoModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartOrdeInfoModel : NSObject
//材料id
@property(nonatomic,assign)NSInteger stuff_id;
//材料分类id
@property(nonatomic,assign)NSInteger stuff_category_id;
//材料分类名称
@property(nonatomic,strong)NSString *stuff_category_name;

//材料信息数据
@property(nonatomic,strong)NSArray * stuff_info;



@end

NS_ASSUME_NONNULL_END
