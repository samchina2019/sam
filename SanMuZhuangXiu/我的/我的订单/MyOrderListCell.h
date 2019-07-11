//
//  MyOrderListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"
#import "OrderModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgsView;
@property (weak, nonatomic) IBOutlet UIButton *limitBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UIButton *pingjiaBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *storeNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionrightBtn;
@property (weak, nonatomic) IBOutlet UIButton *functionleftBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;
//block
@property(copy, nonatomic) void (^quxiaoBlock)(void);
@property(copy, nonatomic) void (^rightBlock)(void);
@property(copy, nonatomic) void (^pingjiaBlock)(void);
@property(copy, nonatomic) void (^deleteBlock)(void);
//定时器
@property (assign, nonatomic) NSTimeInterval secondsCountDown;
@property (nonatomic, strong) OrderModel *model;
@property (nonatomic,assign) NSTimeInterval time;

@end

NS_ASSUME_NONNULL_END
