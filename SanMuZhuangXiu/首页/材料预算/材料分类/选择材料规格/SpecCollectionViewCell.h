//
//  SpecCollectionViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecGuigeModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface SpecCollectionViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;

@property (nonatomic, assign) NSInteger lastNum;

@property (nonatomic, strong) NSArray *dataArray;
//block
@property (copy, nonatomic) void (^cellBlock)(SpecGuigeModel *model);
@end

NS_ASSUME_NONNULL_END
