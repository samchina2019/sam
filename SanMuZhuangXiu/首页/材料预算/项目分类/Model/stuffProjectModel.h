//
//  stuffProjectModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface stuffProjectModel : NSObject
@property(nonatomic,assign)NSInteger work_category_id;

//名称
@property(nonatomic,strong)NSString *name;
//图标
@property(nonatomic,strong)NSString *image;
//选中图标
@property(nonatomic,strong)NSString *selectimage;

@property(nonatomic,strong)NSArray *project;
@end

NS_ASSUME_NONNULL_END
