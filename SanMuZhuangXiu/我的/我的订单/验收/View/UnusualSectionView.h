//
//  UnusualSectionView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"
NS_ASSUME_NONNULL_BEGIN

@interface UnusualSectionView : UIView
@property (weak, nonatomic) IBOutlet UILabel *sectionNameLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *zankaiBtn;

@property(copy, nonatomic) void (^zankaiBlock)(void);

@end

NS_ASSUME_NONNULL_END
