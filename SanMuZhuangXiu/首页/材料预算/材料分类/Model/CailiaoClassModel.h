//
//  CailiaoClassModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CailiaoClassModel : NSObject
@property(nonatomic ,strong)NSString *name;
@property(nonatomic ,strong)NSString *image;
@property(nonatomic ,assign) NSInteger category_id;
@property(nonatomic ,assign) NSInteger status;
@property(nonatomic ,assign) NSInteger stuff_work_id;

@end

NS_ASSUME_NONNULL_END
