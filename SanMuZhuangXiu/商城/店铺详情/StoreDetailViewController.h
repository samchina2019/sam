//
//  StoreDetailViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import "MallSellerList.h"
NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailViewController : DZBaseViewController
@property(nonatomic,assign) NSInteger seller_id;
@property(nonatomic,strong) NSString *storeName;
@end

NS_ASSUME_NONNULL_END
