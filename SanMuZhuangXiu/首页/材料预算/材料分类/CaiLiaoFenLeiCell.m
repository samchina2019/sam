//
//  CaiLiaoFenLeiCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CaiLiaoFenLeiCell.h"

@implementation CaiLiaoFenLeiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.jiajianBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        if (number == 0) {
            self.jiajianBtn.hidden = YES;
            self.addBtn.hidden = NO;
        }
        self.numBlock(number);
    };
}
//addBtn
- (IBAction)addBtnCLicked:(id)sender {
    self.tianjiaBlock();
}
//选择品牌
- (IBAction)selectPinpai:(id)sender {
    self.pinpaiBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)yixyanBtnClick:(id)sender {
    self.yixuanBlock();
}

@end
