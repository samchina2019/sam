//
//  SectionView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "SectionView.h"

@implementation SectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"SectionView" owner:self options:nil][0];
        self.frame = frame;
    }

    return self;
}





@end
