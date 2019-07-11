//
//  UnusualDataCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnusualDataCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *pinpaiLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *onePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

@end

NS_ASSUME_NONNULL_END
