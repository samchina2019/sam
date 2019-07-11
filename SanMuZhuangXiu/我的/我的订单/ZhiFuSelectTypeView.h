//
//  ZhiFuSelectTypeView.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZhiFuSelectTypeView : UIView

@property (weak, nonatomic) IBOutlet UIButton *yueBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhifuaboBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinBtn;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (nonatomic, copy) void(^block)(int type);
@end

NS_ASSUME_NONNULL_END
