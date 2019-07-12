//
//  SearchViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
//block
@property(copy, nonatomic) void (^addBlock)(void);
@property(copy, nonatomic) void (^shareBlock)(void);
@end

NS_ASSUME_NONNULL_END
