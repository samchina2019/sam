//
//  QiyeFabujiluCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPopupMenu.h"
typedef void (^moreBtnClickBlock)(NSInteger index);
NS_ASSUME_NONNULL_BEGIN

@interface QiyeFabujiluCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UILabel *zanshiLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//招聘Java工程师
@property (weak, nonatomic) IBOutlet UILabel *zhaopinNameLabel;
//¥6000
@property (weak, nonatomic) IBOutlet UILabel *xinziLabel;
//公司名称
@property (weak, nonatomic) IBOutlet UILabel *gongsiNameLabel;
//工作区域
@property (weak, nonatomic) IBOutlet UILabel *gognzuoquyuLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIButton *xiajiaBtn;
//block
@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@property (nonatomic, copy) void(^cellButtonClickedHandler)(id obj, UIButton *sender);
@end

NS_ASSUME_NONNULL_END
