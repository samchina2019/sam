//
//  BlockAlertView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@class BlockAlertView;
@protocol CQDeclareAlertViewDelegate <NSObject>

/** 弹窗按钮点击的回调 */
- (void)AlertView:(BlockAlertView *)alertView clickedButtonWithTag:(NSInteger)tag;

@end



@interface BlockAlertView : UIView

@property (nonatomic, weak) id <CQDeclareAlertViewDelegate> delegate;
- (instancetype)initWithdelegate:(id)delegate;
- (void)show;
- (void)dismiss;
@end

NS_ASSUME_NONNULL_END
