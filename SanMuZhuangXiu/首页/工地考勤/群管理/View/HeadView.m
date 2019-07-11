//
//  HeadView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "HeadView.h"

@implementation HeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"HeadView" owner:self options:nil][0];
        self.frame = frame;
        self.backgroundColor = [UIColor whiteColor];
//        self.titleLable.layer.cornerRadius=3;
    
    }
    return self;
}

- (IBAction)searchClick:(id)sender {
    !self.searchBlock?:self.searchBlock();
}
//
- (IBAction)allPeopleBtnClick:(id)sender {
    !self.moreBlock ? : self.moreBlock();

}

@end
