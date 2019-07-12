//
//  SetTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SetTableViewCell : UITableViewCell
//电话
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
//姓名（头衔）
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//状态按钮
@property (weak, nonatomic) IBOutlet UIButton *stateBtn;
//删除按钮
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;
//头像

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//声明一个名为 setPeopleBlock  无返回值，参数为PeopleViewCell 类型的block
@property (weak, nonatomic) IBOutlet UIButton *editBtn;

//block
typedef void (^SetPeopleBlock) (SetTableViewCell *);

@property(nonatomic, copy) SetPeopleBlock setPeopleBlock;

//删除
@property(copy, nonatomic) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
