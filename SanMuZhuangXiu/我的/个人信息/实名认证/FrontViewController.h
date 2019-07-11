//
//  FrontViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import "JYBDCardIDInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface FrontViewController : DZBaseViewController

// 身份证信息
@property (nonatomic,strong) JYBDCardIDInfo *IDInfo;

@end

NS_ASSUME_NONNULL_END
