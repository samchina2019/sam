//
//  ZidongTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZidongTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
//设置（点击修改）
@property (weak, nonatomic) IBOutlet UIButton *setBtn;
//工地名称
@property (weak, nonatomic) IBOutlet UILabel *gongdiLabel;
//打卡时间
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

NS_ASSUME_NONNULL_END
