//
//  GuanlianCailiaoCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface GuanlianCailiaoCell : UITableViewCell
@property(weak, nonatomic) IBOutlet UILabel *nameLabel;
@property(weak, nonatomic) IBOutlet ReLayoutButton *pinpaiBtn;
@property(weak, nonatomic) IBOutlet ReLayoutButton *xinghaoBtn;
@property(weak, nonatomic) IBOutlet PPNumberButton *jiajianBtn;
@property (weak, nonatomic) IBOutlet UILabel *guigeLabel;

//block
@property(copy, nonatomic) void (^xinghaoBlock)(void);
@property(copy, nonatomic) void (^numBlock)(CGFloat num);
@property(copy, nonatomic) void (^pinpaiBlock)(void);

@end

NS_ASSUME_NONNULL_END
