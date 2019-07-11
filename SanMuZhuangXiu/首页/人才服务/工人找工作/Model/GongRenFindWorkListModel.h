//
//  GongRenFindWorkListModel.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/17.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GongRenFindWorkListModel : NSObject

@property(nonatomic,assign)int jobId;
//用户头像
@property(nonatomic,strong)NSString *avatar;
//工地名称
@property(nonatomic,strong)NSString *username;
//工种名称
@property(nonatomic,strong)NSString *name;
//籍贯
@property(nonatomic,strong)NSString *native_place;
//工龄
@property(nonatomic,strong)NSString *work_year;
//特长
@property(nonatomic,strong)NSString *speciality;
//薪资
@property(nonatomic,strong)NSString *salary;


//*********员工求职列表
//姓名
@property(nonatomic,strong)NSString *realName;
//学历
@property(nonatomic,strong)NSString *education;
//求职岗位
@property(nonatomic,strong)NSString *recruitment_post;

@end

NS_ASSUME_NONNULL_END
