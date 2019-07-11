//
//  MyOrderImgListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"
#import "GoodsModel.h"
#import "OrderModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface MyOrderImgListCell : UITableViewCell<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgsView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *storeNameBtn;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *limitBtn;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *totalNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionrightBtn;
@property (weak, nonatomic) IBOutlet UIButton *functionleftBtn;
@property (weak, nonatomic) IBOutlet UIButton *pingjiaBtn;
@property (weak, nonatomic) IBOutlet UITableView *celltableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cellTableViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,assign)CGFloat cellHeight;

@property(nonatomic ,strong) OrderModel *model;
//block
@property(copy, nonatomic) void (^rightBlock)(void);
@property(copy, nonatomic) void (^pingjiaBlock)(void);
@property(copy, nonatomic) void (^quxiaoBlock)(void);
@property(copy, nonatomic) void (^deleteBlock)(void);


//定时器
@property (assign, nonatomic) NSTimeInterval secondsCountDown;
@property (nonatomic,assign) NSTimeInterval time;

@end

NS_ASSUME_NONNULL_END
