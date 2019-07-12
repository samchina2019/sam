//
//  QXSegmentedControl.h
//  YoungDrill
//
//  Created by mac on 2018/7/2.
//  Copyright © 2018年 czg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXSegmentView : UIView

@property (nonatomic, copy) void (^segmentClickBlock)(NSInteger index);


/**
 选中标题颜色
 */
@property (nonatomic, strong) UIColor       *selectedColor;

/**
 默认颜色
 */
@property (nonatomic, strong) UIColor       *normalColor;

/**
 下划线颜色
 */
@property (nonatomic, strong) UIColor       *lineColor;

/**
 标题数组
 */
@property (nonatomic, strong) NSArray       *titleArray;

/**
 初始化

 @param frame 坐标
 @param titleArr 标题数组
 @return 控制器
 */
- (id)initWithFrame:(CGRect)frame titleArray:(NSArray *)titleArr;

@end
