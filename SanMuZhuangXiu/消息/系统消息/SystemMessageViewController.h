//
//  SystemMessageViewController.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SystemMessageViewController : DZBaseViewController

@property (nonatomic, assign) NSInteger type;//1.系统消息2.考勤消息3.物流消息
@property (nonatomic, assign) NSInteger xiaoxitype;

@end

NS_ASSUME_NONNULL_END
