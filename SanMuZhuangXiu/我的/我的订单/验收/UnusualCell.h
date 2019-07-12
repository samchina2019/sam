//
//  UnusualCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UnusualCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *bgView;
//材料名称
@property (weak, nonatomic) IBOutlet UILabel *cailiaoNameLabel;
//品牌名称
@property (weak, nonatomic) IBOutlet UILabel *pinpaiNameLabel;
//数量：100
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//实到：50
@property (weak, nonatomic) IBOutlet UILabel *shijiNumberLabel;
//破损：1
@property (weak, nonatomic) IBOutlet UILabel *posunLabel;
//规格：5cm 10cm 15cm 20cm
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
//补货:49 换货:1 退货:0
@property (weak, nonatomic) IBOutlet UILabel *buhuoLabel;
//单价
@property (weak, nonatomic) IBOutlet UILabel *onePriceLabel;
//总价
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

@end

NS_ASSUME_NONNULL_END
