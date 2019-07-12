//
//  FriendsListCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FriendsListCell : UITableViewCell
///同意按钮
@property (weak, nonatomic) IBOutlet UIButton *tongyiButton;

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *chakanLabel;
//block
///删除
@property(copy ,nonatomic)void (^deleteBlock)(void);
///同意
@property(copy ,nonatomic)void (^tongyiBlock)(void);
@end

NS_ASSUME_NONNULL_END
