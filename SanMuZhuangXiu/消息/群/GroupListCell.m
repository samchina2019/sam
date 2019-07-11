//
//  GroupListCell.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GroupListCell.h"

@implementation GroupListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)editBtnClicked:(id)sender {
    self.block();
}

@end
