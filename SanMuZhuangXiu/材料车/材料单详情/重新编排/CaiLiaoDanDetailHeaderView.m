//
//  OrderHeaderView.m
//  MaiDianShaDelivery
//
//  Created by 犇犇网络 on 2018/1/10.
//  Copyright © 2018年 benben. All rights reserved.
//

#import "CaiLiaoDanDetailHeaderView.h"

@implementation CaiLiaoDanDetailHeaderView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"CaiLiaoDanDetailHeaderView" owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
