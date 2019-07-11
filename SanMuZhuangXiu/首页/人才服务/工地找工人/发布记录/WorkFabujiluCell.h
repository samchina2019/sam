//
//  WorkFabujiluCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YBPopupMenu.h"
typedef void (^moreBtnClickBlock)(NSInteger index);

NS_ASSUME_NONNULL_BEGIN

@interface WorkFabujiluCell : UITableViewCell<YBPopupMenuDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *moreView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *zanshiLabel;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;
//地址
@property (weak, nonatomic) IBOutlet UILabel *gongzuoAddressLabel;
@property (weak, nonatomic) IBOutlet UIButton *xiajiabtn;
//招聘工程师
@property (weak, nonatomic) IBOutlet UILabel *zhaopinNameLabel;
//日薪 ¥300
@property (weak, nonatomic) IBOutlet UILabel *rixinLabel;
//2小时前发布
@property (weak, nonatomic) IBOutlet UILabel *fabushijianLabel;
//浏览人数
@property (weak, nonatomic) IBOutlet UILabel *liulanNumLabel;
//特长要求
@property (weak, nonatomic) IBOutlet UILabel *techangLabel;
//上岗时间
@property (weak, nonatomic) IBOutlet UILabel *shanggangDateLabel;

@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@property (nonatomic, copy) void(^cellButtonClickedHandler)(id obj, UIButton *sender);



@end

NS_ASSUME_NONNULL_END
