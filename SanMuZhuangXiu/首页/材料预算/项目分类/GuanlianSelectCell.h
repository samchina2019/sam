//
//  GuanlianSelectCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuanlianSelectCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pinpaiLabel;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *pinpaiBtn;
//block
@property(copy, nonatomic) void (^pinpaiBlock)(void);
@property (copy, nonatomic) void(^selectBlock)(void);



@end

NS_ASSUME_NONNULL_END
