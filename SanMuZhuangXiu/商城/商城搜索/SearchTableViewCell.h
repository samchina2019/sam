//
//  SearchTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/15.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *mallNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *manjianLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *haopinLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@end

NS_ASSUME_NONNULL_END
