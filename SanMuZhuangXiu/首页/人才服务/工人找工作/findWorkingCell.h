//
//  findWorkingCell.h
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface findWorkingCell : UITableViewCell
//姓名
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//工作年限
@property (weak, nonatomic) IBOutlet UILabel *workTimeLabel;
//工种：
@property (weak, nonatomic) IBOutlet UILabel *workKindLabel;
//擅长类型：
@property (weak, nonatomic) IBOutlet UILabel *shanchangLabel;
//籍贯
@property (weak, nonatomic) IBOutlet UILabel *jiguanLabel;
//期望薪资：
@property (weak, nonatomic) IBOutlet UILabel *xinziLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

NS_ASSUME_NONNULL_END
