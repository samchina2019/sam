//
//  GuanlianCailiaoCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GuanlianCailiaoCell.h"

@implementation GuanlianCailiaoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.jiajianBtn.currentNumber=1;
    self.jiajianBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        
        self.numBlock(number);
    };
}
//选择型号
- (IBAction)xinhaoBtnCLicked:(id)sender {
    self.xinghaoBlock();
}
//选择品牌
- (IBAction)selectPinpai:(id)sender {
    self.pinpaiBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
