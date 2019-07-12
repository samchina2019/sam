//
//  SelectSpecTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectSpecTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
@property (weak, nonatomic) IBOutlet PPNumberButton *numberBtn;

///删除
@property (copy, nonatomic) void(^deleteBlock)(void);
@property (copy, nonatomic) void(^numBlock)(NSInteger num );
@end

NS_ASSUME_NONNULL_END
