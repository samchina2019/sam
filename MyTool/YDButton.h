//
//  YDButton.h
//  YoungDrill
//
//  Created by zh_mac on 2018/7/3.
//  Copyright © 2018年 czg. All rights reserved.
//

#import <UIKit/UIKit.h>
//按钮样式  待扩展
typedef enum {
    YDbuttonBorderStyleNone = 0,   //无边框
    YDBbuttonBorderStyleLace        //花边框
    
}YDBbuttonBorderStyle;
@interface YDButton : UIButton
/**
 按钮背景颜色     默认颜色为
 */
@property (nonatomic, strong) UIColor   *bgColor;


/**
 按钮文字颜色     默认颜色为
 */
@property (nonatomic, strong) UIColor   *titleColor;


/**
 按钮边框样式
 */
@property (nonatomic, assign) YDBbuttonBorderStyle style;


/**
 初始化button
 
 @param frame 按钮frame
 @param title 按钮标题
 @return return YXB_Button
 */
+(YDButton *)buttonWithFrame:(CGRect)frame
                         title:(NSString *)title
;
@end
