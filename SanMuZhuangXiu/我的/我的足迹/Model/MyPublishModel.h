//
//  MyPublishModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyPublishModel : NSObject
@property (nonatomic, assign) int recruit_id;

@property (nonatomic, strong) NSString *name;

@property (nonatomic, strong) NSString *type;

@property (nonatomic, strong) NSString *status;

@property (nonatomic, strong) NSString *company;

@property (nonatomic, strong) NSString *address;

@property (nonatomic, assign) int user_id;

@property (nonatomic, strong) NSString *time_text;

@property (nonatomic, assign) int createtime;
@end

NS_ASSUME_NONNULL_END
