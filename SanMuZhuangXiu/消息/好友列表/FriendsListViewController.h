//
//  FriendsListViewController.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
@class FriendsListModel;
NS_ASSUME_NONNULL_BEGIN

@interface FriendsListViewController : DZBaseViewController
@property(nonatomic,assign)BOOL isFromCart;
@property (copy, nonatomic) void(^block)( FriendsListModel  *model);
@end

NS_ASSUME_NONNULL_END
