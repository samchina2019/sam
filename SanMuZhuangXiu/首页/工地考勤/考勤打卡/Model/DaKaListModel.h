//
//  DaKaListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DaKaListModel : NSObject<NSCoding>
@property(nonatomic ,assign)int id;
@property(nonatomic ,strong)NSString *current_auto;
@property(nonatomic ,assign) int group_id;
@property(nonatomic ,strong)NSString * group_name;
@property(nonatomic ,strong) NSString * address;
//1:上班打卡2:下班打卡（早退）3:上班迟到打卡 4:午休开始打卡 5:午休结束打卡 6:下班打卡（早退）7：下班打卡
@property(nonatomic ,strong) NSString * clockin_type;
@property(nonatomic ,assign)float lng;
@property(nonatomic ,assign)float lat;
//上班打卡时间
@property(nonatomic ,strong)NSString * clockin;
@property(nonatomic ,strong) NSString * gooff_time;
@property(nonatomic ,strong) NSString * clockin_time;
@property(nonatomic ,assign) float card_range;
//@property(nonatomic ,assign) BOOL  automatic_clockin;
//@property(nonatomic ,assign) BOOL  automatic_signback;
@property(nonatomic ,strong) NSString * gotowork;
@property(nonatomic ,strong) NSString * gooffwork;
@property(nonatomic ,strong) NSString * noon_start;
@property(nonatomic ,strong) NSString * noon_end;
@property(nonatomic ,strong) NSString * wxwork;
@property(nonatomic ,strong) NSString * wxtowork;
+ (void)saveDakaInfo:(DaKaListModel *)dakaInfo;
+ (DaKaListModel *)getdakaInfo;
+ (void)deledakaInfo;

@end

NS_ASSUME_NONNULL_END
