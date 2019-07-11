//
//  BaojiaDanDetailHeaderView.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaojiaDanDetailHeaderView : UITableViewHeaderFooterView
@property (weak, nonatomic) IBOutlet UILabel *headViewLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhongleiLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiangqingLabel;
@property (weak, nonatomic) IBOutlet UIButton *shanglaBtn;
//block
@property (copy, nonatomic) void(^shanglaBlock)(void);

@end

NS_ASSUME_NONNULL_END
