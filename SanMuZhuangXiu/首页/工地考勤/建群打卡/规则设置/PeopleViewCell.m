//
//  PeopleViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "PeopleViewCell.h"
#import "SetPeopleViewController.h"

@implementation PeopleViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headImageView.layer.cornerRadius=3;
    self.headImageView.clipsToBounds = YES;
}
- (IBAction)addBtnClicked:(id)sender {
    if (self.addToCartsBlock) {
        self.addToCartsBlock(self);
    }
  
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
