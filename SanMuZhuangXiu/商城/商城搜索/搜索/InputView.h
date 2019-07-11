//
//  InputView.h
//  ZhongRenJuMei
//
//  Created by benben on 2019/4/8.
//  Copyright © 2019 刘寒. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputView : UIView

- (id)initWithFrame:(CGRect)frame isEidt:(BOOL)isEidt;
@property (nonatomic,strong) UITextField *inputView;
@property (nonatomic,copy) void (^searchKeyword)(NSString *keyword);
@property (nonatomic,copy) void (^textFieldAction)(void);
- (NSString *)getKeyword;
@end

NS_ASSUME_NONNULL_END
