//
//  SelectSpecTableViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SelectSpecTableViewCell.h"

@implementation SelectSpecTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.numberBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
      
        self.numBlock(number);
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBlock();
}

@end
