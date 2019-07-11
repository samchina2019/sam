//
//  YanshouhuoCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "YanshouhuoCell.h"

@implementation YanshouhuoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 5;
    
    
    //设置圆角的半径
    [self.unusualBtn.layer setCornerRadius:3];
    //切割超出圆角范围的子视图
    self.unusualBtn.layer.masksToBounds = YES;
    //设置边框的颜色
    [self.unusualBtn.layer setBorderColor:[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0].CGColor];
    //设置边框的粗细
    [self.unusualBtn.layer setBorderWidth:1.0];
    
    //设置圆角的半径
    [self.nomalBtn.layer setCornerRadius:3];
    //切割超出圆角范围的子视图
    self.nomalBtn.layer.masksToBounds = YES;
    //设置边框的颜色
    [self.nomalBtn.layer setBorderColor:[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0].CGColor];
    //设置边框的粗细
    [self.nomalBtn.layer setBorderWidth:1.0];
    
}
- (IBAction)nomalBtnClick:(id)sender {
     !self.nomalBlock ? : self.nomalBlock();
}


- (IBAction)unusualBtnClick:(id)sender {
     !self.unusualBlock ? : self.unusualBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
