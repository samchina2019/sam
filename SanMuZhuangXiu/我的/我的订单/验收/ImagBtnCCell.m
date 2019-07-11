//
//  ImagBtnCCell.m
//  HOOLA
//
//  Created by 犇犇网络 on 2018/9/20.
//  Copyright © 2018年 Darius. All rights reserved.
//

#import "ImagBtnCCell.h"

@implementation ImagBtnCCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)buttonClicked:(UIButton *)sender {
    self.block((int)sender.tag);
}

@end
