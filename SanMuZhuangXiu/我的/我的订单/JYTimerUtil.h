//
//  JYTimerUtil.h
//  TimeDemo
//
//  Created by 翔梦01 on 2018/5/9.
//  Copyright © 2018年 JY.Hoo. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JYTimerUtil;

@protocol JYTimerListener <NSObject>
//kvo监听time值改变（解决cell滚动时内容不及时刷新的问题）
-(void)didOnTimer:(JYTimerUtil *)timerUtil timeInterval:(NSTimeInterval) timeInterval;

@end

@interface JYTimerUtil : NSObject
//单例定时器管理
+(instancetype)sharedInstance;
//添加监听者
-(void)addListener:(id<JYTimerListener>) listener;
//移除监听者
-(void)removeListener:(id<JYTimerListener>) listener;
//定时器暂停
-(void)timerPause;
//定时器继续
-(void)timerStart;
//从新设置定时器
-(void)resetServerTime;
//获取时间差
-(NSTimeInterval)lefTimeInterval:(NSTimeInterval) time;

@end
