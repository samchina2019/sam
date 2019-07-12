//
//  ServerFocusListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/29.
//  Copyright © 2018 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerFocusListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@property(copy, nonatomic) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
