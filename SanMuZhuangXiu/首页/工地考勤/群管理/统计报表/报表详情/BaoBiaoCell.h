//
//  BaoBiaoCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaoBiaoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shangbanLabel;
@property (weak, nonatomic) IBOutlet UILabel *xiabanLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiabanLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
