//
//  AddGuiGETableViewCell.h
//  SanMuZhuangXiu
//
//  Created by apple on 2019/7/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddGuiGeCell : UITableViewCell

@property (strong, nonatomic) UIButton       * addBtn;//添加按钮
@property (copy, nonatomic) void (^tianjiaBlock)(void);


@end

NS_ASSUME_NONNULL_END
