//
//  ServerVisitListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/30.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ServerVisitListModel : NSObject
///足迹ID
@property (nonatomic, assign) int zujiId;
///服务id
@property (nonatomic, assign) int recruit_id;
///标题
@property (nonatomic, strong) NSString *name;
///服务类型:1=工地找人,2=工人找工作,3=企业招聘,4=员工求职,5=工程服务
@property (nonatomic, assign) int type;
///初次时间
@property (nonatomic, strong) NSString *createtime;
///最近时间
@property (nonatomic, strong) NSString *updatetime;
///公司
@property (nonatomic, strong) NSString *company;
///地址
@property (nonatomic, strong) NSString *address;

///简介
@property (nonatomic, strong) NSString *brief;

///足迹人
@property (nonatomic, assign) int user_id;
///服务总表ID
@property (nonatomic, assign) int rid;
@end

NS_ASSUME_NONNULL_END
