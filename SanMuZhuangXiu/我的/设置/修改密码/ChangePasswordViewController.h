//
//  ChangePasswordViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/25.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import "FSSegmentTitleView.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordViewController : DZBaseViewController
@property(nonatomic,strong)NSString *phoneStr;

@property (nonatomic, strong) FSSegmentTitleView *segmentTitleView;
@end

NS_ASSUME_NONNULL_END
