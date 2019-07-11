//
//  MessageFooterView.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MessageFooterView.h"

@implementation MessageFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MessageFooterView" owner:self options:nil][0];
        self.frame = frame;
        //阴影的颜色
        self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        //阴影的透明度
        self.bgView.layer.shadowOpacity = 0.5f;
        //阴影的圆角
        self.bgView.layer.shadowRadius = 3.f;
        //阴影偏移量
        self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    }
    return self;
}

- (IBAction)btnClicked:(UIButton *)sender {
    self.block();
}

@end
