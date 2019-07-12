//
//  XiangmuFenleiCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/4.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface XiangmuFenleiCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pinpaiText;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet PPNumberButton *jiajianBtn;
@property (weak, nonatomic) IBOutlet UIButton *pinpaiBtn;
@property (weak, nonatomic) IBOutlet UIButton *yixuanBtn;
//block
@property (copy, nonatomic) void(^tianjiaBlock)(void);
@property (copy, nonatomic) void(^numBlock)(CGFloat num);
@property (copy, nonatomic) void(^pinpaiBlock)(void);
@property (copy, nonatomic) void(^yixuanBlock)(void);
@end

NS_ASSUME_NONNULL_END
