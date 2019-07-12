//
//  GroupListCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (nonatomic, strong) void(^block)(void);
@end

NS_ASSUME_NONNULL_END
