//
//  SystemMessageListCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SystemMessageListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end

NS_ASSUME_NONNULL_END
