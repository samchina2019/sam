//
//  detailDateModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface detailDateModel : NSObject

@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * overtime;
@property(nonatomic,assign)NSInteger late;
@property(nonatomic,assign)NSInteger leave_early;
@property(nonatomic,strong)NSString * over_time;
@property(nonatomic,strong)NSString * leave_time;
@property(nonatomic,strong)NSString * date;
@property(nonatomic,strong)NSString * work_type;
@end

NS_ASSUME_NONNULL_END
