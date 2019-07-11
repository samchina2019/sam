//
//  ForgetPasswordViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/24.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ForgetPasswordViewController : DZBaseViewController

@property (nonatomic, copy) void(^block)(NSString* mobile, NSString* password);

@end

NS_ASSUME_NONNULL_END
