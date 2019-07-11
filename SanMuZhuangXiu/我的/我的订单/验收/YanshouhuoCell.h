//
//  YanshouhuoCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^nomalBtnClickBlock)(void);
typedef void (^unusualBtnClickBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface YanshouhuoCell : UITableViewCell
//总价
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
//单价
@property (weak, nonatomic) IBOutlet UILabel *onePriceLabel;
//规格：5cm 10cm 12cm
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
//材料名称 品牌名称 数量100
@property (weak, nonatomic) IBOutlet UILabel *cailiangNameLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *nomalBtn;
@property (weak, nonatomic) IBOutlet UIButton *unusualBtn;

//block
@property(nonatomic,copy) nomalBtnClickBlock nomalBlock;
@property(nonatomic,copy) unusualBtnClickBlock unusualBlock;
@end

NS_ASSUME_NONNULL_END
