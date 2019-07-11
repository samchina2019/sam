//
//  SpecGuigeModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/17.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecGuigeModel : NSObject
//规格id
@property(nonatomic,assign)NSInteger stuff_spec_id;
//
@property(nonatomic,assign)NSInteger stuff_id;
//名称
@property(nonatomic,strong)NSString *name;
//数量
@property(nonatomic,assign)NSInteger number;

@property (nonatomic) BOOL isSelected;

@end

NS_ASSUME_NONNULL_END
