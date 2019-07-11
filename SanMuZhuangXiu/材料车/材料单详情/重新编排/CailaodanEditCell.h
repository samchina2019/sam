//
//  CailaodanEditCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"
#import "ReLayoutButton.h"
NS_ASSUME_NONNULL_BEGIN
typedef void (^moreBtnClickBlock)(void);

@interface CailaodanEditCell : UITableViewCell
@property (weak, nonatomic) IBOutlet PPNumberButton *numberBtn;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *pinpaiBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *guigeBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
//block
@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@property (copy, nonatomic) void(^guigeBlock)(void);
@property (copy, nonatomic) void(^numBlock)(CGFloat num );
@property (copy, nonatomic) void(^pinpaiBlock)(void);
@end

NS_ASSUME_NONNULL_END
