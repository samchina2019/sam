//
//  UIAlertView+Block.h
//  YoungDrill
//
//  Created by zh_mac on 2018/7/3.
//  Copyright © 2018年 czg. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^CompleteBlock) (NSInteger buttonIndex);

@interface UIAlertView (Block)
// 用Block的方式回调，这时候会默认用self作为Delegate
- (void)showAlertViewWithCompleteBlock:(CompleteBlock) block;


@end
