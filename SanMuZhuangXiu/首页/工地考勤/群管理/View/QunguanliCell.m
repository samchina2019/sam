//
//  QunguanliCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QunguanliCell.h"

@implementation QunguanliCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    //设置圆角
    self.bgView.layer.cornerRadius = 3;
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
   
    
    
    
}

@end
