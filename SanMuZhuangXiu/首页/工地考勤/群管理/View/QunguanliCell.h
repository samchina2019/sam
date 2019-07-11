//
//  QunguanliCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QunguanliCell : UITableViewCell
//打卡时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//花藤北塘木工打卡组
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
//状态
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
//下标未读信息
@property (weak, nonatomic) IBOutlet UIButton *xiabiaoBtn;
//管理人员：5
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//群组人数：3
@property (weak, nonatomic) IBOutlet UILabel *groupLabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

NS_ASSUME_NONNULL_END
