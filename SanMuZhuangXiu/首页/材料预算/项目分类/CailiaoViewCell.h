//
//  CailiaoViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CailiaoViewCell : UITableViewCell
@property(weak, nonatomic) IBOutlet PPNumberButton *ppnumBtn;
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinpaiLabel;

@property (copy, nonatomic) void(^numBlock)(CGFloat num);

@end

NS_ASSUME_NONNULL_END
