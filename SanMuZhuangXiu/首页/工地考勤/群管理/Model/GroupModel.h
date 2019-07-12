//
//  GroupModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface GroupModel : NSObject
@property(nonatomic,assign)int group_id;
@property(nonatomic,assign)int group_owner;
@property(nonatomic,strong)NSString * group_name;
@property(nonatomic,assign)int group_admin;
@property(nonatomic,assign)NSInteger  status;
@property(nonatomic,strong)NSString * address;
@property(nonatomic,assign)int group_user_num;
@property(nonatomic,assign)int unread;
@property(nonatomic,assign)int user_id;
@property(nonatomic,assign)int user_type;
@property(nonatomic,strong)NSString * clockin;
@property(nonatomic,strong)NSString * clockin_time;
@property(nonatomic,strong)NSString * personnel_management;
@property(nonatomic,strong)NSString * rule_management;
@property(nonatomic,strong)NSString * audit_management;
@property(nonatomic,strong)NSString * statistical_management;
@end

NS_ASSUME_NONNULL_END
