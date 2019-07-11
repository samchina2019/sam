//
//  MessageHeaderView.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MessageHeaderView.h"

@implementation MessageHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"MessageHeaderView" owner:self options:nil][0];
        self.frame = frame;
        self.bgView1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.bgView1.layer.shadowOpacity = 0.5f;
        self.bgView1.layer.shadowRadius = 3.f;
        self.bgView1.layer.shadowOffset = CGSizeMake(0,0);
        
        self.bgView2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.bgView2.layer.shadowOpacity = 0.5f;
        self.bgView2.layer.shadowRadius = 3.f;
        self.bgView2.layer.shadowOffset = CGSizeMake(0,0);
        
        self.bgView3.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.bgView3.layer.shadowOpacity = 0.5f;
        self.bgView3.layer.shadowRadius = 3.f;
        self.bgView3.layer.shadowOffset = CGSizeMake(0,0);
        
        self.bgView4.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.bgView4.layer.shadowOpacity = 0.5f;
        self.bgView4.layer.shadowRadius = 3.f;
        self.bgView4.layer.shadowOffset = CGSizeMake(0,0);
        
        self.bgView5.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.bgView5.layer.shadowOpacity = 0.5f;
        self.bgView5.layer.shadowRadius = 3.f;
        self.bgView5.layer.shadowOffset = CGSizeMake(0,0);
        
        self.bgView6.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        self.bgView6.layer.shadowOpacity = 0.5f;
        self.bgView6.layer.shadowRadius = 3.f;
        self.bgView6.layer.shadowOffset = CGSizeMake(0,0);
    }
    return self;
}
- (IBAction)btnClicked:(UIButton *)sender {
    self.block(sender.tag);
}

@end
