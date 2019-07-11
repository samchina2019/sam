//
//  MyOrderListViewController.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListViewController : DZBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger type;

@end

NS_ASSUME_NONNULL_END
