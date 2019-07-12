//
//  GoodsDetailPageViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsDetailPageViewController : DZBaseViewController
@property(nonatomic,assign)NSInteger goodsId;
@property(nonatomic,assign)NSInteger mallId;
@property(nonatomic,strong) NSString *storeName;
@property(nonatomic,strong) NSString *image;



@end

NS_ASSUME_NONNULL_END
