//
//  JifenListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JifenListModel : NSObject
//商品ID
@property (nonatomic, assign) int id;
//商品n名字
@property (nonatomic, strong) NSString *memo;
//分类ID
@property (nonatomic, strong) NSString *score;
@property (nonatomic, strong) NSString * createtime;
//商品名
@property (nonatomic, strong) NSString *createtime_text;
//图片
@property (nonatomic, strong) NSString *log_type;
//店铺ID
@property (nonatomic, strong) NSString *user_id;
//店铺名
@property (nonatomic, strong) NSString *goods_score;
@end

NS_ASSUME_NONNULL_END
