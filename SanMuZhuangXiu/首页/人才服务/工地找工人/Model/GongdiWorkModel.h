//
//  GongdiWorkModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/17.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GongdiWorkModel : NSObject

@property(nonatomic,assign)int lookId;
//薪资计算方式：10=日工，20=包工；
@property(nonatomic,strong)NSString * salary_way;
//工地名称
@property(nonatomic,strong)NSString *name;
//薪资
@property(nonatomic,strong)NSString *salary;
//是否提供住宿：10=是；20=否；
@property(nonatomic,strong)NSString *putup;
//特长要求
@property(nonatomic,strong)NSString *speciality;
//结算时间周期
@property(nonatomic,strong)NSString *settlement_time;
//工作地址
@property(nonatomic,strong)NSString *work_address;
//工作详细地址
@property(nonatomic,strong)NSString *work_addressInfo;
//创建时间
@property(nonatomic,strong)NSString *createtime;

@end

NS_ASSUME_NONNULL_END
