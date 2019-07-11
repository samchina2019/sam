//
//  ShenheManagerCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShenheManagerCell : UITableViewCell
//申请时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//备注
@property (weak, nonatomic) IBOutlet UILabel *beizhuLabel;
//电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIView *bgView;
//状态
@property (weak, nonatomic) IBOutlet UILabel *stateLable;


@end

NS_ASSUME_NONNULL_END
