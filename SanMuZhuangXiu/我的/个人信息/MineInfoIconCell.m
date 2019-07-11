//
//  MineInfoIconCell.m
//  WorkAssistant
//
//  Created by 赵江伟 on 16/8/3.
//  Copyright © 2016年 com.henanunicom. All rights reserved.
//

#import "MineInfoIconCell.h"

@implementation MineInfoIconCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ViewWidth - 80, 10, 40, 40)];
        self.iconBtn=[[UIButton alloc]initWithFrame:CGRectMake(ViewWidth - 80, 10, 40, 40)];
        [self.iconBtn addTarget:self action:@selector(setHeadImage:) forControlEvents:UIControlEventTouchUpInside];
        self.iconBtn.backgroundColor=[UIColor clearColor];
        [self addSubview:self.iconBtn];
        [self addSubview:self.iconImageView];
    }
    return self;
}
-(void)setHeadImage:(id)sender{
    self.btnBlock();
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
