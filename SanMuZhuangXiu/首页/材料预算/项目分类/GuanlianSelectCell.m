//
//  GuanlianSelectCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GuanlianSelectCell.h"

@implementation GuanlianSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}
- (IBAction)selectBtnClick:(id)sender {
    
    self.selectBlock();
}
- (IBAction)pinpaiBtnClick:(id)sender {
      self.pinpaiBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
