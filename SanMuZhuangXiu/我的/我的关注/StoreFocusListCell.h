//
//  StoreFocusListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBStarEvaluationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreFocusListCell : UITableViewCell
//商品头像
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//商店名
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
//距离
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
//评价
@property (weak, nonatomic) IBOutlet UIView *starBgView;
//评价内容
@property (weak, nonatomic) IBOutlet UILabel *pingjiaLabel;
//已购人数
@property (weak, nonatomic) IBOutlet UILabel *yimaiLabel;
//主营商品
@property (weak, nonatomic) IBOutlet UILabel *goodsLabel;
//活动
@property (weak, nonatomic) IBOutlet UILabel *huodongLabel;
//配送费
@property (weak, nonatomic) IBOutlet UILabel *peisongLabel;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;

@property (strong, nonatomic) HYBStarEvaluationView *starView;

@property (copy, nonatomic) void(^block)(void);

@end

NS_ASSUME_NONNULL_END
