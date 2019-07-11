//
//  ZidingyiYIchangCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^moreBtnClickBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ZidingyiYIchangCell : UITableViewCell
//补货:49 换货:1 退货:0
@property (weak, nonatomic) IBOutlet UIView *buhuoLabel;
//破损：1
@property (weak, nonatomic) IBOutlet UILabel *posunLabel;
//实到：50
@property (weak, nonatomic) IBOutlet UILabel *shidaoNumberlabel;
//规格：18厚
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
//数量：100
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

//品牌：金秋
@property (weak, nonatomic) IBOutlet UILabel *pingpaiLabel;
//18厚木板
@property (weak, nonatomic) IBOutlet UILabel *houmubanLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
//block
@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@end

NS_ASSUME_NONNULL_END
