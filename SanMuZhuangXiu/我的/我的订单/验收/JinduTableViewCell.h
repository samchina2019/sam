//
//  JinduTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/15.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JinduTableViewCell : UITableViewCell
//进度状态
@property (weak, nonatomic) IBOutlet UIButton *jinDuBtn;
//商家信息状态
@property (weak, nonatomic) IBOutlet UILabel *shangjiaMessageLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
