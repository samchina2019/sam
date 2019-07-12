//
//  InputCaigoudanCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InputCaigoudanCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareByLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;

@property(copy ,nonatomic)void (^selectBlock)(BOOL isSelected);

@end

NS_ASSUME_NONNULL_END
