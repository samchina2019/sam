//
//  SelectFriendsListViewController.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectFriendsListViewController : DZBaseViewController

@property (nonatomic, strong) void(^block)(NSArray *array);

@end

NS_ASSUME_NONNULL_END
