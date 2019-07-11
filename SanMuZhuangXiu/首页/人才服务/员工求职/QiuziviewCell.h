//
//  QiuziviewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QiuziviewCell : UITableViewCell
//工作时间
@property (weak, nonatomic) IBOutlet UILabel *shijianLabel;
//学历
@property (weak, nonatomic) IBOutlet UILabel *xueliLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//工资
@property (weak, nonatomic) IBOutlet UILabel *gongziLabel;
//岗位
@property (weak, nonatomic) IBOutlet UILabel *gangweiLabel;

@end

NS_ASSUME_NONNULL_END
