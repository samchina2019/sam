//
//  PeopleManagerViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeopleManagerViewController : DZBaseViewController
@property(nonatomic,assign)int group_id;
///群名称
@property (nonatomic, strong) NSString * groupName;
///人员管理 3：读写 2：读
@property(nonatomic,strong)NSString *personnel_management;

@end

NS_ASSUME_NONNULL_END
