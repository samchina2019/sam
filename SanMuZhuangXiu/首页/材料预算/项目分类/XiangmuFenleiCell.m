//
//  XiangmuFenleiCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/4.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "XiangmuFenleiCell.h"

@implementation XiangmuFenleiCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.jiajianBtn.resultBlock = ^(PPNumberButton *ppBtn, CGFloat number, BOOL increaseStatus) {
        self.numBlock(number);
    };
    
}
//addBtn
- (IBAction)addBtnCLicked:(id)sender {
    self.tianjiaBlock();
}
//选择品牌
- (IBAction)selectPinpai:(id)sender {
    self.pinpaiBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
- (IBAction)yixuanBtnClick:(id)sender {
    self.yixuanBlock();
}

@end
