//
//  HUTextView.m
//  WisdomPartyBuilding
//
//  Created by ChangLu on 2017/3/28.
//  Update by ChangLu on 2017/4/11
//  Copyright © 2017年 unicom. All rights reserved.
//

#import "HUTextView.h"

#define HUWordLimitShort  200

@implementation TextView

//禁止粘贴
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end

#pragma mark - ************************************分割线************************************

@implementation HUTextView

- (instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _infoTextView = [[TextView alloc] initWithFrame:CGRectMake(10,5, ViewWidth - 20,frame.size.height-30)];
        _infoTextView.backgroundColor = [UIColor clearColor];
        [_infoTextView setFont:[UIFont systemFontOfSize:17]];
        [_infoTextView setDelegate:self];
        [self addSubview:_infoTextView];
        //占位字
        _placeholderLabel = [[UILabel alloc] initWithFrame:CGRectMake(_infoTextView.frame.origin.x + 5, _infoTextView.frame.origin.y + 2, ViewWidth - 130, 30)];
        [_placeholderLabel setBackgroundColor:[UIColor clearColor]];
        [_placeholderLabel setFont:[UIFont systemFontOfSize:17]];
        [_placeholderLabel setTextColor:[UIColor grayColor]];
        [_placeholderLabel setAlpha:0.8f];
        [self addSubview:_placeholderLabel];
        
        //占位字
        _wordCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(_infoTextView.frame.origin.x + _infoTextView.frame.size.width - 90, _infoTextView.frame.origin.y + _infoTextView.frame.size.height, 80, 20)];
        [_wordCountLabel setBackgroundColor:[UIColor clearColor]];
        _wordCountLabel.textAlignment = NSTextAlignmentRight;
        [_wordCountLabel setFont:[UIFont systemFontOfSize:15]];
        [_wordCountLabel setTextColor:[UIColor grayColor]];
        [_wordCountLabel setAlpha:0.8f];
        _wordCountLabel.text = [NSString stringWithFormat:@"0/%ld",(long)HUWordLimitShort];
        [self addSubview:_wordCountLabel];
        
        
    }
    return self;
}


#pragma mark - 关闭键盘
// 触摸背景，关闭键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    UIView *view = (UIView *)[touch view];
    if (view == self)
    {
        [_infoTextView resignFirstResponder];
    }
}
#pragma mark  - textView代理方法
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([_delegate respondsToSelector:@selector(txbeginEditing:)]) {
        [_delegate txbeginEditing:textView];
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!(textView.text.length == 0)) {
        [_placeholderLabel setHidden:YES];
    }else{
        [_placeholderLabel setHidden:NO];
    }
}

//限制字符数
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    if (textView.text.length > HUWordLimitShort) {
        textView.text = [textView.text substringToIndex:HUWordLimitShort];
    }else
    {
        _wordCountLabel.text = [NSString stringWithFormat:@"%ld/%ld",(long)textView.text.length,(long)HUWordLimitShort];
    }
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    if ([[textView text] length] > HUWordLimitShort){
        [_placeholderLabel setHidden:YES];
        return NO;
    }

    NSString *string = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if ([string length] > HUWordLimitShort)
    {
        string = [string substringToIndex:HUWordLimitShort];
        textView.text = string;
        [_placeholderLabel setHidden:YES];
        return NO;
    }
    return YES;
}

@end
