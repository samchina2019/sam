//
//  BangDingPhoneView.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+Code.h"

NS_ASSUME_NONNULL_BEGIN

@interface BangDingPhoneView : UIView

@property (weak, nonatomic) IBOutlet UITextField *phoneTF;
@property (weak, nonatomic) IBOutlet UITextField *codeTF;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (strong, nonatomic) NSString *openid;
@property (strong, nonatomic) NSString *nickname;
@property (strong, nonatomic) NSString *type;
@property (nonatomic, copy) void(^block)(void);

@end

NS_ASSUME_NONNULL_END
