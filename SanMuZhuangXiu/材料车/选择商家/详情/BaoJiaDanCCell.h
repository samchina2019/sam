//
//  BaoJiaDanCCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBStarEvaluationView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaoJiaDanCCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *juliLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyLabel;
@property (weak, nonatomic) IBOutlet UILabel *haopingLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *pipeiLabel;

@property (strong, nonatomic) HYBStarEvaluationView *starView;

@end

NS_ASSUME_NONNULL_END
