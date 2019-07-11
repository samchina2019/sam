//
//  QunGuanliViewController.h
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QunGuanliViewController : DZBaseViewController

@property (nonatomic, assign) BOOL isSelectStatus;
@property (nonatomic, strong) void(^block)(int gongdiGroupID);
@property (nonatomic, assign) NSInteger groupId;
@end

NS_ASSUME_NONNULL_END
