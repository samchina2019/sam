//
//  SelectStoreListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SelectStoreListCell.h"

@implementation SelectStoreListCell

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
    
    self.starView = [[HYBStarEvaluationView alloc]initWithFrame:self.starBgView.bounds numberOfStars:5 isVariable:NO];
    self.starView.actualScore = 4;
    self.starView.fullScore = 5;
    self.starView.isContrainsHalfStar = YES;
    [self.starBgView addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//查看详情
- (IBAction)lookDetailBtnClicked:(id)sender {
    self.block();
}


@end
