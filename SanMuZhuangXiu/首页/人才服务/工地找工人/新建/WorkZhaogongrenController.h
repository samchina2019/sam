//
//  WorkZhaogongrenController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WorkZhaogongrenController : DZBaseViewController
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property(nonatomic,assign)BOOL isEdited;
@property(nonatomic,assign)NSInteger userId;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@end

NS_ASSUME_NONNULL_END
