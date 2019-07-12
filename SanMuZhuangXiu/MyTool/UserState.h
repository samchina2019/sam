//
//  UserState.h
//  YoungDrill
//
//  Created by mac on 2018/10/19.
//  Copyright © 2018年 czg. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserState : NSObject

// 是否显示过版本更新提示
@property (nonatomic,assign) BOOL isShowVersionAlert;


+ (UserState *)instance;


@end

NS_ASSUME_NONNULL_END
