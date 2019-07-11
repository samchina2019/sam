//
//  GroupPeopleModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GroupPeopleModel : NSObject
@property(nonatomic,assign)int user_id;
@property(nonatomic,strong)NSString * nickname;
@property(nonatomic,strong)NSString * avatar;
@property(nonatomic,strong)NSString * mobile;
@property(nonatomic,strong)NSString * group_nickname;
@property(nonatomic,strong)NSString * status;
@property(nonatomic,strong)NSString * list_id;
@property(nonatomic,strong)NSString * personnel_management;
@property(nonatomic,strong)NSString * rule_management;
@property(nonatomic,strong)NSString * audit_management;
@property(nonatomic,strong)NSString * statistical_management;
@end

NS_ASSUME_NONNULL_END
