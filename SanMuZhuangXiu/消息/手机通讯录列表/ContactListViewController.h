//
//  ContactListViewController.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/24.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface ContactListViewController : DZBaseViewController

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSString *phoneStr;

@end

NS_ASSUME_NONNULL_END
