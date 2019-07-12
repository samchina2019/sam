//
//  GuigeModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GuigeModel : NSObject
//品牌id
@property(nonatomic,assign)NSInteger spec_rel_id;
//
@property(nonatomic,assign)NSInteger stuff_id;
//
@property(nonatomic,assign)NSInteger spec_id;

//名称
@property(nonatomic,strong)NSString *spec_name;
//名称
@property(nonatomic,strong)NSArray *data;

@end

NS_ASSUME_NONNULL_END
