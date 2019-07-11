//
//  UITextField+IDCard.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextField (IDCard)
- (NSRange)selectedRange;
- (void)setSelectedRange:(NSRange) range;
@end

NS_ASSUME_NONNULL_END
