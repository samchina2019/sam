//
//  InputCaigoudanCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "InputCaigoudanCell.h"

@implementation InputCaigoudanCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 5;
    
    self.shareLabel.layer.borderColor = TabbarColor.CGColor;
    self.buyLabel.layer.borderColor = UIColorFromRGB(0xFA5458).CGColor;
}


- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected=!sender.selected;
    self.selectBlock(sender.selected);
}


@end
