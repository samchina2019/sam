//
//  StoreFocusListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "StoreFocusListCell.h"

@implementation StoreFocusListCell

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
- (IBAction)deleteBtnClicked:(id)sender {
    self.block();
}
@end
