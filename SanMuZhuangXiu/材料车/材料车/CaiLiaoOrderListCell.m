//
//  CaiLiaoOrderListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CaiLiaoOrderListCell.h"

@implementation CaiLiaoOrderListCell

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
   
}
- (IBAction)selectBtnClicked:(id)sender
{
    self.selectBtn.selected = !self.selectBtn.selected;
    self.selectBlock(self.selectBtn.selected);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
