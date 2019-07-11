//
//  StoreClassListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "StoreClassListCell.h"

@implementation StoreClassListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.starView = [[HYBStarEvaluationView alloc]initWithFrame:self.starBgView.bounds numberOfStars:5 isVariable:NO];
    self.starView.actualScore = 1;
    self.starView.fullScore = 5;
    self.starView.isContrainsHalfStar = YES;
    [self.starBgView addSubview:self.starView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
