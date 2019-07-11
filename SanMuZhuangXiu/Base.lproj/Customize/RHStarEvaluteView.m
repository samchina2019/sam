//
//  RHStarEvaluteView.m
//  ZSHY(B2)
//
//  Created by LiuZhengli on 17/3/26.
//  Copyright © 2017年 unicom. All rights reserved.
//

#import "RHStarEvaluteView.h"
#define STAR_WIDTH  50
#define STAR_HEIGHT 48

@implementation RHStarEvaluteView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.selectedImage = [UIImage imageNamed:@"star"];
        self.unselectedImage = [UIImage imageNamed:@"unstar"];
        CGFloat x = frame.size.width / 2; // center of the width
        self.star1 = [[UIButton alloc] initWithFrame:CGRectMake(x - 2.5*STAR_WIDTH, 0, STAR_WIDTH, STAR_HEIGHT)];
        self.star2 = [[UIButton alloc] initWithFrame:CGRectMake(x - 1.5*STAR_WIDTH, 0, STAR_WIDTH, STAR_HEIGHT)];
        self.star3 = [[UIButton alloc] initWithFrame:CGRectMake(x - 0.5*STAR_WIDTH, 0, STAR_WIDTH, STAR_HEIGHT)];
        self.star4 = [[UIButton alloc] initWithFrame:CGRectMake(x + 0.5*STAR_WIDTH, 0, STAR_WIDTH, STAR_HEIGHT)];
        self.star5 = [[UIButton alloc] initWithFrame:CGRectMake(x + 1.5*STAR_WIDTH, 0, STAR_WIDTH, STAR_HEIGHT)];
        [self.star1 setImage:self.selectedImage forState:UIControlStateNormal];
        [self.star2 setImage:self.selectedImage forState:UIControlStateNormal];
        [self.star3 setImage:self.selectedImage forState:UIControlStateNormal];
        [self.star4 setImage:self.selectedImage forState:UIControlStateNormal];
        [self.star5 setImage:self.selectedImage forState:UIControlStateNormal];
        [self.star1 addTarget:self action:@selector(star1Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.star2 addTarget:self action:@selector(star2Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.star3 addTarget:self action:@selector(star3Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.star4 addTarget:self action:@selector(star4Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.star5 addTarget:self action:@selector(star5Clicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.star1];
        [self addSubview:self.star2];
        [self addSubview:self.star3];
        [self addSubview:self.star4];
        [self addSubview:self.star5];
        self.evaluate = 5;
    }
    return self;
}

- (void)star1Clicked:(UIButton *)sender
{
    self.evaluate = 1;
    [self.star2 setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.star3 setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.star4 setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.star5 setImage:self.unselectedImage forState:UIControlStateNormal];
}

- (void)star2Clicked:(UIButton *)sender
{
    self.evaluate = 2;
    [self.star2 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star3 setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.star4 setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.star5 setImage:self.unselectedImage forState:UIControlStateNormal];
}

- (void)star3Clicked:(UIButton *)sender
{
    self.evaluate = 3;
    [self.star2 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star3 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star4 setImage:self.unselectedImage forState:UIControlStateNormal];
    [self.star5 setImage:self.unselectedImage forState:UIControlStateNormal];
}

- (void)star4Clicked:(UIButton *)sender
{
    self.evaluate = 4;
    [self.star2 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star3 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star4 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star5 setImage:self.unselectedImage forState:UIControlStateNormal];
}

- (void)star5Clicked:(UIButton *)sender
{
    self.evaluate = 5;
    [self.star2 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star3 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star4 setImage:self.selectedImage forState:UIControlStateNormal];
    [self.star5 setImage:self.selectedImage forState:UIControlStateNormal];
}

@end
