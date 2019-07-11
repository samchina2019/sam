//
//  ShenheModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShenheModel : NSObject
@property(nonatomic,assign)int list_id;
@property(nonatomic,strong)NSString * reason;
@property(nonatomic,strong)NSString * remarks;
@property(nonatomic,strong)NSString * reason_time;
@property(nonatomic,strong)NSString * name;
@property(nonatomic,strong)NSString * phone;
@property(nonatomic,assign)int user_id;

@end

NS_ASSUME_NONNULL_END
