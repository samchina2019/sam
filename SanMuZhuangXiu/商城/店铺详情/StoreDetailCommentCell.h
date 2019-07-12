//
//  StoreDetailCommentCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HYBStarEvaluationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailCommentCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;

@property (weak, nonatomic) IBOutlet UIButton *iconBtn;
@property (weak, nonatomic) IBOutlet UILabel *nameBtn;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIView *starBgView;

@property (strong, nonatomic) HYBStarEvaluationView *starView;
@property (strong, nonatomic) NSArray *array;

@end

NS_ASSUME_NONNULL_END
