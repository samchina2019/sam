//
//  CaiLiaoFenLeiCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface CaiLiaoFenLeiCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *pinpaiTF;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet PPNumberButton *jiajianBtn;
@property (weak, nonatomic) IBOutlet UIButton *yixuanBtn;
//block
@property (copy, nonatomic) void(^tianjiaBlock)(void);
@property (copy, nonatomic) void(^numBlock)(CGFloat num );
@property (copy, nonatomic) void(^pinpaiBlock)(void);
@property (copy, nonatomic) void(^yixuanBlock)(void);
@end

NS_ASSUME_NONNULL_END
