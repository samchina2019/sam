//
//  QiyeJiluModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/18.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QiyeJiluModel : NSObject

@property(nonatomic,assign)int lookId;
//工地名称
@property(nonatomic,strong)NSString *name;
//薪资
@property(nonatomic,strong)NSString *salary;
//是否提供住宿：10=是；20=否；
@property(nonatomic,strong)NSString *recruitment_post;
//特长要求
@property(nonatomic,strong)NSString *work_region;
//结算时间周期
@property(nonatomic,strong)NSString *companyName;
//工作地址
@property(nonatomic,strong)NSString *status;

@end

NS_ASSUME_NONNULL_END
