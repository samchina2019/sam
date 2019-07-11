//
//  HUFunctionCollectionCell.m
//  SuiYangPartyBuilding
//
//  Created by 赵江伟 on 2017/3/25.
//  Copyright © 2017年 unicom. All rights reserved.
//

#import "HUFunctionCollectionCell.h"

@implementation HUFunctionCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
                
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 24, 24)];
        self.imageView.center = CGPointMake(self.contentView.center.x, self.contentView.center.y - 10);
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.imageView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 8, self.contentView.bounds.size.width, 12)];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

@end
