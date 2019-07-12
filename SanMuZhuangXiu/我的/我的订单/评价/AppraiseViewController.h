//
//  AppraiseViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AppraiseViewController : DZBaseViewController
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property(nonatomic, assign) int order_type;
///订单ID
@property(nonatomic,assign)NSInteger order_id;
///是否来自订单列表
@property(nonatomic,assign)BOOL idFromList;

@property (strong, nonatomic) NSDictionary *dataDic;
@end

NS_ASSUME_NONNULL_END
