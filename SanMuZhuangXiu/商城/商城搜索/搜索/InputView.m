//
//  InputView.m
//  ZhongRenJuMei
//
//  Created by benben on 2019/4/8.
//  Copyright © 2019 刘寒. All rights reserved.
//

#import "InputView.h"

@interface InputView ()<UITextFieldDelegate>
{
    BOOL _isEidt;
}

@end

@implementation InputView

- (id)initWithFrame:(CGRect)frame isEidt:(BOOL)isEidt{
    self = [super initWithFrame:frame];
    if (self) {
        _isEidt = isEidt;
        [self.layer setCornerRadius:3];
        [self setBackgroundColor:[UIColor colorWithRed:245 green:245 blue:245 alpha:1]];
        
        [self setUpInputView];
    }
    return self;
    
}


- (void)setUpInputView{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [imageView setCenter:CGPointMake(25.5, self.frame.size.height/2.0)];
    [imageView setImage:[UIImage imageNamed:@"icon_search"]];
    [self addSubview:imageView];
    
    self.inputView = [[UITextField alloc] initWithFrame:CGRectMake(43, 0, self.frame.size.width-65, self.frame.size.height)];
    [self.inputView setPlaceholder:@"请输入搜索内容"];
    [self.inputView setFont:[UIFont systemFontOfSize:14]];
    [self.inputView setReturnKeyType:(UIReturnKeySearch)];
    [self.inputView setDelegate:self];
    [self addSubview:self.inputView];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.textFieldAction) {
        self.textFieldAction();
    }
    return _isEidt;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (self.searchKeyword) {
        [self endEditing:YES];
        self.searchKeyword(textField.text);
        textField.text = @"";
    }
   
    return YES;
}

- (NSString *)getKeyword{
    return self.inputView.text;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
