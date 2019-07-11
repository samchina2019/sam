//
//  ImgTitleCollectionCell.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ImgTitleCollectionCell.h"

@implementation ImgTitleCollectionCell

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        self.imageView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - 10);
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 8, self.contentView.bounds.size.width, 12)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:11];
        self.textLabel.textColor = UIColorFromRGB(0x333333);
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}
@end
