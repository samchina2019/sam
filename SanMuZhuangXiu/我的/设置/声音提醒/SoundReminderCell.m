//
//  SoundReminderCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SoundReminderCell.h"

@implementation SoundReminderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _myswitch.transform = CGAffineTransformMakeScale(0.6, 0.6);

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)switchValueChanged:(UISwitch *)sender {
    
}

@end
