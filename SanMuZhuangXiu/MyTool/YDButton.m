//
//  YDButton.m
//  YoungDrill
//
//  Created by zh_mac on 2018/7/3.
//  Copyright © 2018年 czg. All rights reserved.
//

#import "YDButton.h"
#define CORNERRADIUS 4      //圆角大小
@implementation YDButton
+(YDButton *)buttonWithFrame:(CGRect)frame
                         title:(NSString *)title{
    YDButton * yxbBtn = [YDButton buttonWithType:UIButtonTypeCustom];
    yxbBtn.frame = frame;
    [yxbBtn setTitle:title forState:UIControlStateNormal];
    [yxbBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [yxbBtn setBackgroundColor:[UIColor redColor]];
    yxbBtn.layer.masksToBounds = YES;
    yxbBtn.layer.cornerRadius = CORNERRADIUS;
    return yxbBtn;
    
}



/**
 按钮背景颜色     默认颜色为
 */
-(void)setBgColor:(UIColor *)bgColor{
    [self setBackgroundColor:bgColor];
}
/**
 按钮文字颜色     默认颜色为
 */
-(void)setTitleColor:(UIColor *)titleColor{
    [self setTitleColor:titleColor forState:UIControlStateNormal];
}
/**
 按钮边框样式     默认无
 */
-(void)setStyle:(YDBbuttonBorderStyle)style{
    [self setStyle:style];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
