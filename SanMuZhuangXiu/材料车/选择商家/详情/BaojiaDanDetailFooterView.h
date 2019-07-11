//
//  BaojiaDanDetailFooterView.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaojiaDanDetailFooterView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *daigouLabel;
@property (weak, nonatomic) IBOutlet UILabel *daigounameLabel;
@property (weak, nonatomic) IBOutlet UIButton *xiugaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *chaidanBtn;


//block
@property (copy, nonatomic) void(^sureBlock)(BOOL isSelect);
@property (copy, nonatomic) void(^cancelBlock)(void);
@property (copy, nonatomic) void(^xiugaiBlock)(void);
@property (copy, nonatomic) void(^chaidanBlock)(void);

@end

NS_ASSUME_NONNULL_END
