//
//  BaojiaDanDetailHeaderView.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BaojiaDanDetailHeaderView.h"

@implementation BaojiaDanDetailHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"BaojiaDanDetailHeaderView" owner:self options:nil][0];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
- (IBAction)shanglaBtnClick:(id)sender {
    self.shanglaBlock();
}

@end
