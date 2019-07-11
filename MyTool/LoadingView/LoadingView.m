//
//  LoadingView.m
//  iMobbyMobile
//
//  Created by up72 on 13-7-23.
//  Copyright (c) 2013年 up72. All rights reserved.
//

#import "LoadingView.h"

@implementation LoadingView


- (id)initWithFrame:(CGRect)frame withText:(NSString *)text
{
    
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *loadingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 156, 129)];
        loadingView.backgroundColor = [UIColor blackColor];
        loadingView.alpha = 0.5f;
        loadingView.layer.masksToBounds = YES;
        loadingView.layer.cornerRadius = 5.0f;
        loadingView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:loadingView];
        
        UIActivityIndicatorView *testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        
        [testActivityIndicator setTag:8000];
        testActivityIndicator.center = loadingView.center;//只能设置中心，不能设置大小
        
        [testActivityIndicator startAnimating];
        
        [self addSubview:testActivityIndicator];
        
        
        CGFloat y = CGRectGetMaxY(loadingView.frame) - 25.0f;
        CGFloat height = loadingView.frame.origin.y + loadingView.frame.size.height - y;
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(loadingView.frame.origin.x,
                                                                       y,
                                                                       loadingView.frame.size.width,
                                                                       height)];
        textLabel.text = text;
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.textColor = [UIColor whiteColor];
        textLabel.backgroundColor = [UIColor clearColor];
        [textLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self addSubview:textLabel];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
