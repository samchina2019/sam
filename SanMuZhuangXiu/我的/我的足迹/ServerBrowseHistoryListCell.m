//
//  ServerBrowseHistoryListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ServerBrowseHistoryListCell.h"

@implementation ServerBrowseHistoryListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 5;
    self.multipleSelectionBackgroundView = [UIView new];
    
}
#pragma mark – UI

-(void)layoutSubviews
{
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (self.selected) {
                        img.image=[UIImage imageNamed:@"icon_Radio"];
                    }else
                    {
                        img.image=[UIImage imageNamed:@"icon_Radio_pre"];
                    }
                }
            }
        }
    }
    [super layoutSubviews];
}


//适配第一次图片为空的情况
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    for (UIControl *control in self.subviews){
        if ([control isMemberOfClass:NSClassFromString(@"UITableViewCellEditControl")]){
            for (UIView *v in control.subviews)
            {
                if ([v isKindOfClass: [UIImageView class]]) {
                    UIImageView *img=(UIImageView *)v;
                    if (!self.selected) {
                        img.image=[UIImage imageNamed:@"icon_Radio"];
                    }
                }
            }
        }
    }
    
}
//删除
- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBlock();
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
