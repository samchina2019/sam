//
//  StoreClassListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBStarEvaluationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreClassListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UILabel *pingjiaLabel;
@property (weak, nonatomic) IBOutlet UILabel *yimaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *huodongLabel;
@property (weak, nonatomic) IBOutlet UILabel *peisongLabel;

@property (strong, nonatomic) HYBStarEvaluationView *starView;

@end

NS_ASSUME_NONNULL_END
