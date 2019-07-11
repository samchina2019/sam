//
//  JiFenGoodsCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiFenGoodsCell.h"

@implementation JiFenGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)duihuanBtnClicked:(id)sender {
    self.block();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
