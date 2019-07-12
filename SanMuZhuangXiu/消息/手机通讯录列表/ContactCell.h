//
//  ContactCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/24.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactCell : UITableViewCell

//电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//buttn
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;

@end

NS_ASSUME_NONNULL_END
