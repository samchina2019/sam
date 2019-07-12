//
//  GongChengFuWuCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GongChengFuWuCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewHeight;

@property (strong, nonatomic) NSArray *array;
//block
@property (nonatomic, copy) void(^block)(int fabuID, NSString *fabuName);

@end

NS_ASSUME_NONNULL_END
