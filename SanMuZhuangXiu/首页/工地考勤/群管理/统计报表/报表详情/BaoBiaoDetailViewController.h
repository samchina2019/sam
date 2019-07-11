//
//  BaoBiaoDetailViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaoBiaoDetailViewController : DZBaseViewController
@property(nonatomic,assign)int groupId;
@property(nonatomic,strong)NSString *month_date;
@property(nonatomic,assign)BOOL isYuetongji;

@end

NS_ASSUME_NONNULL_END
