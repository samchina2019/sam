//
//  CailaodanEditCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CailaodanEditCell.h"

@implementation CailaodanEditCell

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
//删除
- (IBAction)moreBtnClick:(id)sender {
    !self.moreBlock ? : self.moreBlock();
}
//品牌
- (IBAction)pinpaiBtnClick:(id)sender {
    self.pinpaiBlock();
}
//规格
- (IBAction)guigeBtnClick:(id)sender {
    self.guigeBlock();
}

@end
