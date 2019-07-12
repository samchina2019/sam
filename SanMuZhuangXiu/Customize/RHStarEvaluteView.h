//
//  RHStarEvaluteView.h
//  ZSHY(B2)
//
//  Created by LiuZhengli on 17/3/26.
//  Copyright © 2017年 unicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RHStarEvaluteView : UIView

@property (nonatomic, strong) UIButton *star1;
@property (nonatomic, strong) UIButton *star2;
@property (nonatomic, strong) UIButton *star3;
@property (nonatomic, strong) UIButton *star4;
@property (nonatomic, strong) UIButton *star5;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;
@property (nonatomic) CGFloat evaluate;

@end
