//
//  PeopleViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PeopleViewCell : UITableViewCell
//电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
//头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

//声明一个名为 AddToCartsBlock  无返回值，参数为PeopleViewCell 类型的block
typedef void (^AddPeopleBlock) (PeopleViewCell *);
@property(nonatomic, copy) AddPeopleBlock addToCartsBlock;


@end

NS_ASSUME_NONNULL_END
