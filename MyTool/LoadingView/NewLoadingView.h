//
//  NewLoadingView.h
//  SuperSoccer
//
//  Created by up72_01 on 16/5/31.
//  Copyright © 2016年 up72_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewLoadingView : UIView {
    
    
    UIImageView *loadingImageView;
    
    BOOL animationing;
    
    CGFloat angle;
    
}

- (void)stopAnimation;


@property (nonatomic, assign) BOOL loadingViewAlpha;

@end
