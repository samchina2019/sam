//
//  HeadTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface HeadTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *guigeBtn;

@property (copy, nonatomic) void (^guigeBlock)(void);

@end

NS_ASSUME_NONNULL_END
