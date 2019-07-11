//
//  CategoryListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CategoryListModel : NSObject
@property(nonatomic,assign)NSInteger category_id;
@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *image;
@property(nonatomic,strong)NSArray *bannerlist;

@end

NS_ASSUME_NONNULL_END
