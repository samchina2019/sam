//
//  ContactModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/24.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FriendsListModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) BOOL isPingTaiUser;
@property (nonatomic, strong) FriendsListModel *userInfo;
/** 联系人电话数组,因为一个联系人可能存储多个号码*/
@property (nonatomic, strong) NSMutableArray *mobileArray;

@end

NS_ASSUME_NONNULL_END
