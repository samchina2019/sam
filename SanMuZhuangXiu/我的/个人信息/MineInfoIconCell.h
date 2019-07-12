//
//  MineInfoIconCell.h
//  WorkAssistant
//
//  Created by 赵江伟 on 16/8/3.
//  Copyright © 2016年 com.henanunicom. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineInfoIconCell : UITableViewCell

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIButton *iconBtn;
@property(copy, nonatomic) void (^btnBlock)(void);
@end
