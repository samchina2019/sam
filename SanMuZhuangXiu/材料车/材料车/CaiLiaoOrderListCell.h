//
//  CaiLiaoOrderListCell.h
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CaiLiaoOrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *storeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *shareByLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@property(strong,nonatomic)NSMutableArray *selectArray;
//block
@property(copy ,nonatomic)void (^selectBlock)(BOOL isSelected);
@end

NS_ASSUME_NONNULL_END
