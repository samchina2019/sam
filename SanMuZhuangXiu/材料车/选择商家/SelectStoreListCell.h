//
//  SelectStoreListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBStarEvaluationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectStoreListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UIView *starBgView;
@property (weak, nonatomic) IBOutlet UILabel *fenLabel;
@property (weak, nonatomic) IBOutlet UILabel *pipeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *manjianLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongchengLabel;
@property (weak, nonatomic) IBOutlet UILabel *huodaofuLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *adLabel;
@property (weak, nonatomic) IBOutlet UILabel *fapiaoLabel;

@property (strong, nonatomic) HYBStarEvaluationView *starView;

//block
@property (copy, nonatomic) void(^block)(void);

@end

NS_ASSUME_NONNULL_END
