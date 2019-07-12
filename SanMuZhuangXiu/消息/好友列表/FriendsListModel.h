//
//  FriendsListModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsListModel : NSObject

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *py;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, assign) NSInteger apply_id;
@property (nonatomic, strong) NSString *status;  //通讯录：0 好友 1 不是好友可以添加 2 邀请
@property (nonatomic, strong) NSString *updatetime;

@property (nonatomic, strong) NSString *group_nickname;
@property (nonatomic, strong) NSString *user_type;//3 ：群主 1：成员

@end

NS_ASSUME_NONNULL_END
