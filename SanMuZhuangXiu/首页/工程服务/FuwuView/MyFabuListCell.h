//
//  MyFabuListCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPopupMenu.h"

typedef void (^moreBtnClickBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface MyFabuListCell : UITableViewCell<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *fuwutypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *timelabel;
@property (weak, nonatomic) IBOutlet UILabel *moneylabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiajiabtn;
@property (weak, nonatomic) IBOutlet UIButton *shuaxinBtn;
@property (weak, nonatomic) IBOutlet UIButton *zhidingBtn;
@property (weak, nonatomic) IBOutlet UILabel *zhanshiLabel;


//block
@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@property (nonatomic, copy) void(^cellButtonClickedHandler)(id obj, UIButton *sender);
@end

NS_ASSUME_NONNULL_END
