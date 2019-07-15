//
//  AddGuiGETableViewCell.m
//  SanMuZhuangXiu
//
//  Created by apple on 2019/7/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddGuiGeCell.h"
@interface AddGuiGeCell ()
@end

@implementation AddGuiGeCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initViews];
    }
    return self;
}
-(void)initViews{
    
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
