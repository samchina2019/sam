//
//  AddressManagerListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "AddressManagerListCell.h"

@implementation AddressManagerListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)deleteBtnCLick:(id)sender {
    
    self.deleteBlock();
}
- (IBAction)defaultBtnClick:(id)sender {
    
    self.morenBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
