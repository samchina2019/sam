//
//  CreateGroupViewController.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import "MessageGroupModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateGroupViewController : DZBaseViewController

@property (nonatomic, assign) BOOL isEdit;
@property (nonatomic, strong) MessageGroupModel *groupModel;

@end

NS_ASSUME_NONNULL_END
