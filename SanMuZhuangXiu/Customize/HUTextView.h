//
//  HUTextView.h
//  WisdomPartyBuilding
//
//  Created by ChangLu on 2017/3/28.
//  Copyright © 2017年 unicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextView : UITextView

@end

#pragma mark - ************************************分割线************************************

@protocol HUTextViewDelegate <NSObject>
@optional

//开始编辑
- (void)txbeginEditing:(UITextView *)textView;
//结束编辑
- (void)txendEditing:(UITextView *)textView;

@end

@interface HUTextView : UIView<UITextViewDelegate>

@property (nonatomic,strong) TextView *infoTextView;
@property (nonatomic,strong) UILabel    *placeholderLabel;

@property (nonatomic,strong) UILabel    *wordCountLabel;      //字数统计
@property (nonatomic, weak) id<HUTextViewDelegate> delegate;

@end


