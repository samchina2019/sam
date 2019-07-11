//
//  CailiaoViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CailiaoViewCell.h"

@implementation CailiaoViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ppnumBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        self.numBlock(number);
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
