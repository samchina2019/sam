//
//  SetTableViewCell.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SetTableViewCell.h"

@implementation SetTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
//    self.stateBtn.
    self.headImageView.layer.cornerRadius=3;
     self.headImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
//设置信息
- (IBAction)addSetBtnClick:(id)sender {
    if (self.setPeopleBlock) {
        self.setPeopleBlock(self);
    }
    
}
//删除
- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBlock();
}

@end
