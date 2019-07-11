//
//  GoodsHuoDongCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/5/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsHuoDongCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet ReLayoutButton *storeName;
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgV;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *huodongLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pingjialabel;


@end

NS_ASSUME_NONNULL_END
