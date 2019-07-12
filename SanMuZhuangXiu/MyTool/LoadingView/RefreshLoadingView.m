//
//  RefreshLoadingView.m
//  SuperSoccer
//
//  Created by up72_01 on 16/6/1.
//  Copyright © 2016年 up72_01. All rights reserved.
//

#import "RefreshLoadingView.h"
#import "UIView+UIViewRect.h"
@implementation RefreshLoadingView


- (void)dealloc {
//    NSLogFunction;
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setFrameWidth:46];
        [self setFrameHeight:46];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
        
        [backView setCenter:self.center];
        
        [self addSubview:backView];
        
        loadingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 46, 46)];
        [loadingImageView setImage:[UIImage imageNamed:@"loading"]];
        [loadingImageView setCenter:CGPointMake(backView.frame.size.width / 2, loadingImageView.center.y)];
        [backView addSubview:loadingImageView];
        
        UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 13, 46, 46)];
        [topImageView setImage:[UIImage imageNamed:@"loadingTop"]];
        [topImageView setCenter:loadingImageView.center];
        [backView addSubview:topImageView];
        
        angle = 360.0;
        animationing = YES;
        
    }
    return self;
}

- (void)startAnimation {
    if (!animationing) {
        return;
    }
    
    angle -= 90;
    if (angle <= 0) {
        angle = 360;
    }
    
    __weak typeof (loadingImageView) weakLoadingImageView = loadingImageView;
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [weakLoadingImageView setTransform:CGAffineTransformMakeRotation(angle * M_PI / 180.0)];
    } completion:^(BOOL finished) {
        if (animationing) {
            [weakSelf startAnimation];
        }
    }];
    
}

- (void)stopAnimation {
    animationing = NO;
    [self removeFromSuperview];
}




@end
