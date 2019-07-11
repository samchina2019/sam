//
//  MAlertView.h
//  IpadVideo
//
//  Created by 红沙尘 on 14-7-1.
//  Copyright (c) 2014年 红沙尘. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MAlertViewDelegate <NSObject>

- (void)malertviewDidMiss;

@end

@interface MAlertView : UIView
{
    IBOutlet UILabel *label;
}

@property (nonatomic, assign) id <MAlertViewDelegate> delegate;

- (void)showWithTitle:(NSString *)title inView:(UIView *)view;

@end
