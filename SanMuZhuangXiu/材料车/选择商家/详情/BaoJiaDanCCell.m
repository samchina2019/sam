//
//  BaoJiaDanCCell.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BaoJiaDanCCell.h"

@implementation BaoJiaDanCCell

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
    
    self.starView = [[HYBStarEvaluationView alloc]initWithFrame:CGRectMake(0, 0, 90, 15) numberOfStars:5 isVariable:NO];
    self.starView.actualScore = 1;
    self.starView.fullScore = 5;
    self.starView.isContrainsHalfStar = YES;
    [self.starBgView addSubview:self.starView];
}

@end
