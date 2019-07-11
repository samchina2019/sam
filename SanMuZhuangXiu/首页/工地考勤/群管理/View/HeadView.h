//
//  HeadView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^moreBtnClickBlock)(void);
typedef void(^searchClickBlock)(void);

@interface HeadView : UIView
- (IBAction)searchClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
//搜索小图片
@property (weak, nonatomic) IBOutlet UIImageView *searchImageView;
//群组人员
@property (weak, nonatomic) IBOutlet UILabel *titleLable;
//block
@property(nonatomic,copy) moreBtnClickBlock moreBlock;
@property(nonatomic,copy)searchClickBlock searchBlock;


@end

NS_ASSUME_NONNULL_END
