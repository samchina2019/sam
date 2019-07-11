//
//  MyOrderCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyOrderCell : UITableViewCell
//石板膏
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//品牌名称
@property (weak, nonatomic) IBOutlet UILabel *pinpaiLabel;
//合计
@property (weak, nonatomic) IBOutlet UILabel *allPriceLabel;
//单价
@property (weak, nonatomic) IBOutlet UILabel *onePriceLabel;
//型号
@property (weak, nonatomic) IBOutlet UILabel *xinghaoLabel;
//数量
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

NS_ASSUME_NONNULL_END
