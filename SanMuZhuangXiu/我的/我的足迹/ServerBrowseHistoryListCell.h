//
//  ServerBrowseHistoryListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerBrowseHistoryListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jieshaoLabel;
@property(copy, nonatomic) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
