//
//  BaojiaDanDetailFooterView.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BaojiaDanDetailFooterView.h"

@implementation BaojiaDanDetailFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"BaojiaDanDetailFooterView" owner:self options:nil][0];
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark – XibFunction

- (IBAction)sureBtnClick:(UIButton *)sender {
    
    sender.selected =! sender.selected;
    self.sureBlock(sender.selected);

}


- (IBAction)xiugaiBtnClick:(id)sender {
    self.xiugaiBlock();
}

- (IBAction)caidanBtnCLick:(id)sender {
    self.chaidanBlock();
}

@end
