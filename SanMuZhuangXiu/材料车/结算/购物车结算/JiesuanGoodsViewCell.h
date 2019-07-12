//
//  JiesuanGoodsViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/21.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JiesuanGoodsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;

@end

NS_ASSUME_NONNULL_END
