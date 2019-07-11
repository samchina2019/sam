//
//  MyjifenOrderListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyjifenOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgsView;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *functionrightBtn;
@property (weak, nonatomic) IBOutlet UIButton *functionleftBtn;

@property(copy, nonatomic) void (^leftBlock)(void);
@property(copy, nonatomic) void (^rightBlock)(void);

@end

NS_ASSUME_NONNULL_END
