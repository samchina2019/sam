//
//  SearchViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SearchViewCell.h"

@implementation SearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
- (IBAction)addBtnClick:(id)sender {
    self.addBlock();
}
- (IBAction)shareBtnClick:(id)sender {
    self.shareBlock();
}

@end
