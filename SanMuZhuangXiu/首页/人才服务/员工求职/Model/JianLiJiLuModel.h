//
//  JianLiJiLuModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/17.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JianLiJiLuModel : NSObject

@property(nonatomic,assign)int jobId;
//用户名称
@property(nonatomic,strong)NSString *username;
//工种名称
@property(nonatomic,strong)NSString *jobName;
//工龄
@property(nonatomic,strong)NSString *createtime;
//-1:删除；0：下架：1：正常
@property(nonatomic,strong)NSString *status;
//薪资
@property(nonatomic,strong)NSString *salary;

//求职岗位
@property(nonatomic,strong)NSString *recruitment_post;
//真实姓名
@property(nonatomic,strong)NSString *realName;


@end

NS_ASSUME_NONNULL_END
