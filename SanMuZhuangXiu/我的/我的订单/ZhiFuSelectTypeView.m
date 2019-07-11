//
//  ZhiFuSelectTypeView.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ZhiFuSelectTypeView.h"

@implementation ZhiFuSelectTypeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"ZhiFuSelectTypeView" owner:self options:nil][0];
        self.frame = frame;
    }
    return self;
}
- (IBAction)selectChongzhiType:(UIButton *)sender {
    sender.selected = YES;
    if (sender.tag == 1) {
        _weixinBtn.selected = NO;
        _zhifuaboBtn.selected = NO;
    } else if (sender.tag == 2) {
        _weixinBtn.selected = NO;
        _yueBtn.selected = NO;
    } else if (sender.tag == 3) {
        _zhifuaboBtn.selected = NO;
        _yueBtn.selected = NO;
    }
}
//提交订单
- (IBAction)tijiaoOrderClicked:(id)sender {
    if (_yueBtn.selected) {
        self.block(1);
    }else if (_zhifuaboBtn.selected) {
        self.block(2);
    }else{
        self.block(3);
    }
}
//取消
- (IBAction)cancleClicked:(id)sender {
    [self removeFromSuperview];
}

@end
