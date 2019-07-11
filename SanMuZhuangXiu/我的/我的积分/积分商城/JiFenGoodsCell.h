//
//  JiFenGoodsCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiFenGoodsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *fujiaPriceLabel;

@property (nonatomic, copy) void(^block)(void);

@end

NS_ASSUME_NONNULL_END
