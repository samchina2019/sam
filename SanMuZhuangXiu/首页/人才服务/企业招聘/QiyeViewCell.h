//
//  QiyeViewCell.h
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QiyeViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
//包食宿
@property (weak, nonatomic) IBOutlet UIButton *baoShiSuBtn;
//五险一金
@property (weak, nonatomic) IBOutlet UIButton *wuxianyijinBtn;
//双休
@property (weak, nonatomic) IBOutlet UIButton *shuangxiuBtn;
//¥5000
@property (weak, nonatomic) IBOutlet UILabel *gongziLabel;
//招聘Java工程师
@property (weak, nonatomic) IBOutlet UILabel *namelabel;
//朝阳区/3年/6人
@property (weak, nonatomic) IBOutlet UILabel *jinyanlabel;

@end

NS_ASSUME_NONNULL_END
