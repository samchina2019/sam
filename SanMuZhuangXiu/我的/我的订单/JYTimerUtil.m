//
//  JYTimerUtil.m
//  TimeDemo
//
//  Created by 翔梦01 on 2018/5/9.
//  Copyright © 2018年 JY.Hoo. All rights reserved.
//

#import "JYTimerUtil.h"

@interface JYTimerUtil ()

@property (nonatomic,strong) NSTimer *timer;

@property (nonatomic,strong) NSHashTable <id<JYTimerListener>> *map;
//活动最终时间
@property (nonatomic,assign) NSTimeInterval serverTimeInterval;
//活动现在时间
@property (nonatomic,assign) NSTimeInterval nowTimeInterval;

@end

static NSTimeInterval reloadTimeInterval = 15;

@implementation JYTimerUtil
//单例
+(instancetype)sharedInstance
{
    static JYTimerUtil *timerUtil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        timerUtil = [[JYTimerUtil alloc] init];
    });
    return timerUtil;
}
//初始化
-(instancetype)init
{
    if (self = [super init]) {
        [self setupBase];
    }
    return self;
}
//设置定时器
-(void)setupBase
{
    self.serverTimeInterval = 0;
    self.nowTimeInterval = [NSDate date].timeIntervalSince1970;
    self.map = [NSHashTable weakObjectsHashTable];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:true block:^(NSTimer * _Nonnull timer) {
        [self onTimer];
    }];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    [self timerPause];
}
//添加监听者
-(void)addListener:(id<JYTimerListener>) listener
{
    [self.map addObject:listener];
}
//移除监听者
-(void)removeListener:(id<JYTimerListener>) listener
{
    [self.map removeObject:listener];
}
//开始定时器
-(void)onTimer
{
    self.nowTimeInterval = [NSDate date].timeIntervalSince1970 - self.serverTimeInterval;
    
    for ( id<JYTimerListener> listener in self.map.allObjects) {
        [listener didOnTimer:self timeInterval:self.nowTimeInterval];
    }
    
}
//定时暂停
-(void)timerPause
{
    [self.timer setFireDate:[NSDate distantFuture]];
}
//定时继续
-(void)timerStart
{
    [self.timer setFireDate:[NSDate distantPast]];
}
//从新设置定时器
-(void)resetServerTime
{
    // 从服务器请求最新的时间
    BOOL success = YES;
    
    if (success) {
        self.serverTimeInterval = 0;
    }else {
        [self performSelector:@selector(resetServerTime) withObject:nil afterDelay:reloadTimeInterval];
    }
}
/// 提供时间差值计算方法
///
/// - Parameter time: 比如限时活动开始时间、结束时间
/// - Returns: 时间差
-(NSTimeInterval)lefTimeInterval:(NSTimeInterval) time
{
    NSTimeInterval lefTime = time-self.nowTimeInterval;
    return lefTime;
}

@end
