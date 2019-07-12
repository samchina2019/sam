//
//  StoreDetailInfoCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface StoreDetailInfoCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *imgCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (strong, nonatomic) NSArray *array;

@end

NS_ASSUME_NONNULL_END
