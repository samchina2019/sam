//
//  CollectionViewCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imagev];
        [self addSubview:self.deleteButton];
    }
    return self;
}

- (UIImageView *)imagev{
    if (!_imagev) {
        self.imagev = [[UIImageView alloc] initWithFrame:self.bounds];
        //        _imagev.backgroundColor = [UIColor blueColor];
    }
    return _imagev;
}
- (UIButton *)deleteButton{
    if (!_deleteButton) {
        self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteButton .frame = CGRectMake(self.contentView.bounds.size.width-20, 0, 20, 20);
        [self.deleteButton  setImage:[UIImage imageNamed:@"icon_quxiao"] forState:UIControlStateNormal];
    }
    return _deleteButton ;
}
@end
