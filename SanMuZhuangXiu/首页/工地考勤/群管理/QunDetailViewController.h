//
//  QunDetailViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface QunDetailViewController : DZBaseViewController
///选中的cell序号
@property (nonatomic, assign) NSInteger selectIndex;
///群ID
@property (nonatomic, assign) int groupId;
///群名称
@property (nonatomic, strong) NSString * groupName;
///人员管理 3：读写 2：读
@property (nonatomic, strong) NSString * personnel_management;
///规则管理 3：读写 2：读
@property (nonatomic, strong) NSString * rule_management;
///审核管理 3：读写 2：读
@property (nonatomic, strong) NSString * audit_management;
///统计管理 3：读写 2：读
@property (nonatomic, strong) NSString * statistical_management;
///1,正常，2，停工，3，结束
@property (nonatomic, assign) NSInteger status;
@end

NS_ASSUME_NONNULL_END
