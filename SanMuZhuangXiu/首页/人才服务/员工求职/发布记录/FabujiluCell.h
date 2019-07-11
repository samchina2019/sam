//
//  FabujiluCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPopupMenu.h"

typedef void (^moreBtnClickBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface FabujiluCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yuexinLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//箭头view
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
//更多
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//下架
@property (weak, nonatomic) IBOutlet UIButton *xiajiaBtn;
//刷新
@property (weak, nonatomic) IBOutlet UIButton *shuaxinBtn;
//置顶
@property (weak, nonatomic) IBOutlet UIButton *zhidingBtn;
//更多view
@property (weak, nonatomic) IBOutlet UIView *moreView;
//block
@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@property (nonatomic, copy) void(^cellButtonClickedHandler)(id obj, UIButton *sender);
@end

NS_ASSUME_NONNULL_END
