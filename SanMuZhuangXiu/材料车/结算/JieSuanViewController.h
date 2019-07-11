//
//  JieSuanViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface JieSuanViewController : DZBaseViewController
@property(nonatomic,strong)NSDictionary *dataDict;
@property(nonatomic,assign)BOOL isFromCart;
@property(nonatomic,assign)BOOL isFromSeller;
@end

NS_ASSUME_NONNULL_END
