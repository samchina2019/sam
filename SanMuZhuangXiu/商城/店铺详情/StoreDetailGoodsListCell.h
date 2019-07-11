//
//  StoreDetailGoodsListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailGoodsListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet PPNumberButton *ppNumberButton;
@property (weak, nonatomic) IBOutlet UILabel *haoAndMayLabel;
@property (weak, nonatomic) IBOutlet UIButton *addressLabel;
//block
@property (nonatomic, copy) void(^resultBlock)(NSInteger number);
@property (nonatomic, copy) void(^addBlock)(void);

@end

NS_ASSUME_NONNULL_END
