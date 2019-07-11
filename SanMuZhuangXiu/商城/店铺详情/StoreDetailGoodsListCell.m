//
//  StoreDetailGoodsListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreDetailGoodsListCell.h"

@implementation StoreDetailGoodsListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.ppNumberButton.currentNumber = 1;
    self.ppNumberButton.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        self.resultBlock(number);
    };
}
- (IBAction)addBtnClicked:(id)sender
{
    self.addBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
