//
//  workViewCell.h
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface workViewCell : UITableViewCell
//招聘木工
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//日薪¥100
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//特长要求
@property (weak, nonatomic) IBOutlet UILabel *enjoyLabel;
//薪资待 遇包住宿  工资月结
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
//地址：
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

NS_ASSUME_NONNULL_END
