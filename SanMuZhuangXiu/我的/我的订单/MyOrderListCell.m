//
//  MyOrderListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MyOrderListCell.h"
#import "JYTimerUtil.h"
@interface MyOrderListCell()<JYTimerListener>
{
//    dispatch_source_t _timer;
}
@end
@implementation MyOrderListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //阴影的颜色
    self.bgsView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgsView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgsView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgsView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgsView.layer.cornerRadius = 5;
    
    self.storeNameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.functionleftBtn.layer.borderColor = UIColorFromRGB(0xDDDDDD).CGColor;
    self.functionleftBtn.layer.borderWidth = 1;
    
    
    //kvo监听time值改变（解决cell滚动时内容不及时刷新的问题）
    [self addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    //添加监听者
    [[JYTimerUtil sharedInstance] addListener:self];
    
}

#pragma mark - Function
//kvo监听time值改变（解决cell滚动时内容不及时刷新的问题）
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self onTimer];
}

-(void)didOnTimer:(JYTimerUtil *)timerUtil timeInterval:(NSTimeInterval)timeInterval
{
    [self onTimer];
}
//开启 定时器
-(void)onTimer
{
    // 时间戳 -> NSDate *
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.model.payment_term];
    //设置时间格式
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //将时间转换为字符串
    NSString *timeStr = [formatter stringFromDate:date];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatDay = [[NSDateFormatter alloc] init];
    formatDay.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    ///当前时间
    NSString *dayStr = [formatDay stringFromDate:now];
    ///计算时间差
    NSInteger secondsCountDown = [self getDateDifferenceWithNowDateStr:dayStr deadlineStr:timeStr];

    if (secondsCountDown>0) {
//        int seconds = timeout;
        NSInteger days = (int)(secondsCountDown/(3600*24));
        NSInteger hours = (int)((secondsCountDown-days*24*3600)/3600);
        NSInteger minute = (int)(secondsCountDown-days*24*3600-hours*3600)/60;
        NSInteger second = secondsCountDown - days*24*3600 - hours*3600 - minute*60;
        NSString *strTime = [NSString stringWithFormat:@"剩余: %02ld : %02ld : %02ld", hours, minute, second];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",strTime];
//          [self.ti setTitle: forState:UIControlStateNormal];
    }else {
//         [self.limitBtn setTitle:@"" forState:UIControlStateNormal];
        self.timeLabel.text =@"";
    }
}


/**
 *  获取时间差值  截止时间-当前时间
 *  nowDateStr : 当前时间
 *  deadlineStr : 截止时间
 *  @return 时间戳差值
 */
- (NSInteger)getDateDifferenceWithNowDateStr:(NSString *)nowDateStr deadlineStr:(NSString *)deadlineStr {
    
    NSInteger timeDifference = 0;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy-MM-dd HH:mm:ss"];
    NSDate *nowDate = [formatter dateFromString:nowDateStr];
    NSDate *deadline = [formatter dateFromString:deadlineStr];
    NSTimeInterval oldTime = [nowDate timeIntervalSince1970];
    NSTimeInterval newTime = [deadline timeIntervalSince1970];
    timeDifference = newTime - oldTime;
    
    return timeDifference;
}
//销毁

-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"time"];
    [[JYTimerUtil sharedInstance] removeListener:self];
}
#pragma mark – XibFunction

//取消订单
- (IBAction)quxiaoBtnCLick:(id)sender {
    self.quxiaoBlock();
}
//右边按钮的点击
- (IBAction)rightBtnClick:(id)sender {
    
    self.rightBlock();
}
//评价按钮的点击
- (IBAction)pingjiaBtnClick:(id)sender {
    self.pingjiaBlock();
}
//删除按钮的点击
- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBlock();
}

@end
