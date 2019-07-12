//
//  SoundReminderCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SoundReminderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *myswitch;

@end

NS_ASSUME_NONNULL_END
