//
//  CartListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CartListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
///规格
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet PPNumberButton *ppNumberButton;
//block
@property (nonatomic, copy) void(^resultBlock)(NSInteger number,BOOL increaseStatus);
@property(copy ,nonatomic)void (^selectBlock)(BOOL isSelected);
@end

NS_ASSUME_NONNULL_END
