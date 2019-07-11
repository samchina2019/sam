//
//  WodeDakaModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WodeDakaModel : NSObject
@property(nonatomic,assign)int id;
@property(nonatomic,strong)NSString * current_auto;
@property(nonatomic,assign)int group_id;
@property(nonatomic,strong)NSString * group_name;
@property(nonatomic,strong)NSString * address;
@property(nonatomic,assign)double lng;
@property(nonatomic,assign)double lat;
@property(nonatomic,strong)NSString * clockin;
@property(nonatomic,strong)NSString * gooff_time;
@property(nonatomic,strong)NSString * clockin_time;
@property(nonatomic,strong)NSString * card_range;
@property(nonatomic,assign)BOOL  automatic_clockin;
@property(nonatomic,assign)BOOL  automatic_signback;
@property(nonatomic,strong)NSString * gotowork;
@property(nonatomic,strong)NSString * gooffwork;
@property(nonatomic,strong)NSString * middle;
@end

NS_ASSUME_NONNULL_END
