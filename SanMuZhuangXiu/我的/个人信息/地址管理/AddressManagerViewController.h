//
//  AddressManagerViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
@class AddressModel;
NS_ASSUME_NONNULL_BEGIN

@interface AddressManagerViewController : DZBaseViewController
@property (copy, nonatomic) void(^block)(AddressModel *model);
@end

NS_ASSUME_NONNULL_END
