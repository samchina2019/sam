//
//  MessageGroupModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageGroupModel : NSObject

@property (nonatomic, strong) NSString *group_image;
@property (nonatomic, assign) NSInteger group_id;
@property (nonatomic, strong) NSString *group_name;
@property (nonatomic, assign) BOOL group_owner;

@end

NS_ASSUME_NONNULL_END
