//
//  MessageListCell.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MessageListCell.h"

@implementation MessageListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 8, ViewWidth - 20, 64)];
        self.bgView.backgroundColor = [UIColor whiteColor];
        //阴影的颜色
        self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        //阴影的透明度
        self.bgView.layer.shadowOpacity = 0.5f;
        //阴影的圆角
        self.bgView.layer.shadowRadius = 3.f;
        //阴影偏移量
        self.bgView.layer.shadowOffset = CGSizeMake(0,0);
        self.bgView.layer.masksToBounds = NO;
        self.bgView.clipsToBounds = NO;
        [self.contentView addSubview:self.bgView];
        
        
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 14, 36, 36)];
        self.imgView.cornerRadius = 5;
        [self.bgView addSubview:self.imgView];
        
        self.numLabel = [[UILabel alloc]initWithFrame:CGRectMake(ViewWidth - 46, 22, 18, 18)];
        self.numLabel.textColor = [UIColor whiteColor];
        self.numLabel.backgroundColor = UIColorFromRGB(0xFA5458);
        self.numLabel.font = [UIFont systemFontOfSize:10];
        self.numLabel.cornerRadius = 10;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self.bgView addSubview:self.numLabel];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 14, ViewWidth - 46 - 10 - 56, 18)];
        [self.bgView addSubview:self.titleLabel];
        
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(56, 32, ViewWidth - 46 - 10 - 56, 18)];
        self.contentLabel.textColor = UIColorFromRGB(0x999999);
        self.contentLabel.font = [UIFont systemFontOfSize:12];
        [self.bgView addSubview:self.contentLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
