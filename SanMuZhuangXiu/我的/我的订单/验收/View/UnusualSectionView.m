//
//  UnusualSectionView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "UnusualSectionView.h"

@implementation UnusualSectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle] loadNibNamed:@"UnusualSectionView" owner:self options:nil][0];
        self.frame = frame;
    }
    
    return self;
}
- (IBAction)zankaiBtnClick:(id)sender {
 
    self.zankaiBlock();

}

@end
