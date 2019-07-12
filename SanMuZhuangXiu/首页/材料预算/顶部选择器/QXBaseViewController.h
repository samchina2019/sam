//
//  QXBaseViewController.h
//  YoungDrill
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 czg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QXBaseViewController : UIViewController


@property (nonatomic, strong) NSString * titleStr;
// 设置UINvigationBar 左右键方法
- (void)setNavigationButtonItrmWithiamge:(NSString *)imagename withRightOrleft:(NSString*)f withtargrt:(id)t withAction:(SEL)s;
//提示
- (void)showLoadingWithTitle:(NSString *)text imageName:(NSString *)fileName;

- (void)removeKeyBoundNotification;

- (void)keyboardShow:(NSNotification *)aNotification;

- (void)keyboardHide:(NSNotification *)aNotification;

-(void)backDefault;

-(void)setBackView;

-(void)setLeftView;

-(void)leftClicked;

@end
