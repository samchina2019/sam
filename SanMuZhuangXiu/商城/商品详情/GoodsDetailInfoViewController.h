//
//  GoodsDetailInfoViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailInfoViewController : DZBaseViewController
@property(nonatomic,assign)NSInteger goodsId;
@property(nonatomic,assign)NSInteger mallId;
@property(nonatomic,strong) NSString *storeName;
@property(nonatomic,strong) NSString *image;
@property (nonatomic, strong) NSDictionary *dataDict;

@property (copy, nonatomic) void(^Block)(NSString *num, BOOL isNumChange);

- (void)refreshWithDict:(NSDictionary *)dict;
- (void)refreshGoodsInfoWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
