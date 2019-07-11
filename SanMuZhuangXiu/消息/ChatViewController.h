//
//  ChatViewController.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : RCConversationViewController
///是否为售后
@property (nonatomic , assign)BOOL isShouhou;
///订单编号
@property (nonatomic , assign)NSInteger orderId;
@end

NS_ASSUME_NONNULL_END
