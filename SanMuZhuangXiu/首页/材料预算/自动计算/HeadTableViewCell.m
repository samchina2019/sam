//
//  HeadTableViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "HeadTableViewCell.h"

@implementation HeadTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)guigeBtnClick:(id)sender {
    self.guigeBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
