//
//  SetPeopleViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SetPeopleViewController : DZBaseViewController
@property (nonatomic,copy) void (^change)(NSArray* friendArray);
@property(nonatomic,assign)int group_id;

@end

NS_ASSUME_NONNULL_END
