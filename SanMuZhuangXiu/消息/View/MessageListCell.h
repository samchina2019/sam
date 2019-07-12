//
//  MessageListCell.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageListCell : RCConversationBaseCell

@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIImageView *imgView;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;
@property (strong, nonatomic) UILabel *numLabel;
@property (strong, nonatomic) UILabel *timeLabel;

@end

NS_ASSUME_NONNULL_END
