//
//  RefreshLoadingView.h
//  SuperSoccer
//
//  Created by up72_01 on 16/6/1.
//  Copyright © 2016年 up72_01. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshLoadingView : UIView {
    
    
    UIImageView *loadingImageView;
    
    BOOL animationing;
    
    CGFloat angle;
    
}

- (void)startAnimation;

- (void)stopAnimation;

@end
