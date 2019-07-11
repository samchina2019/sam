//
//  FriendsListCell.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FriendsListCell.h"

@implementation FriendsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
//删除按钮的点击
- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBlock();
}
//同意按钮的点击
- (IBAction)tongyiBtnClick:(id)sender {
    self.tongyiBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
