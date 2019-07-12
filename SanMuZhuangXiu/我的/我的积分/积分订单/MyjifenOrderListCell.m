//
//  MyjifenOrderListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyjifenOrderListCell.h"

@implementation MyjifenOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //阴影的颜色
    self.bgsView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgsView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgsView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgsView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgsView.layer.cornerRadius = 5;
    
    self.functionleftBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    self.functionleftBtn.layer.borderWidth = 1;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)rightBtnCLick:(id)sender {
     self.rightBlock();
    
}
- (IBAction)leftBtnClick:(id)sender {
    self.leftBlock();
}

@end
