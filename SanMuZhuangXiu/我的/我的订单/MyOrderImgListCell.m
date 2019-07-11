//
//  MyOrderImgListCell.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "MyOrderImgListCell.h"
#import "OrderContentCell.h"

#import "JYTimerUtil.h"
@interface MyOrderImgListCell()<JYTimerListener>
{
//    dispatch_source_t _timer;
}
@end
@implementation MyOrderImgListCell

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
    
    self.celltableView.delegate = self;
    self.celltableView.dataSource = self;
     [self.celltableView registerNib:[UINib nibWithNibName:@"OrderContentCell" bundle:nil] forCellReuseIdentifier:@"OrderContentCell"];
    self.celltableView.userInteractionEnabled=NO;

    //kvo监听time值改变（解决cell滚动时内容不及时刷新的问题）
    [self addObserver:self forKeyPath:@"time" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    [[JYTimerUtil sharedInstance] addListener:self];
    
}



#pragma mark--tableview deleteGate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.celltableView.backgroundView = backgroundImageView;
        self.celltableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.celltableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 110;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GoodsModel *model=self.dataArray[indexPath.row];
   
        OrderContentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OrderContentCell" forIndexPath:indexPath];
    if ([model.images  containsString:@"http"]) {
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.images]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }else{
        [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, model.images]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    }
  
    cell.nameLabel.text=model.goods_name;
    cell.priceLabel.text=[NSString stringWithFormat:@"¥%.2f",model.goods_price];
    cell.numberLabel.text=[NSString stringWithFormat:@"x%d",model.total_num ];
 
        return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
   
}
- (void)setModel:(OrderModel *)model
{
    _model = model;
    NSArray *goodsArray=model.goods;
    
    [self.dataArray removeAllObjects];
    for (NSDictionary *dict in goodsArray) {
        GoodsModel *goodsModel=[GoodsModel mj_objectWithKeyValues:dict];
        [self.dataArray addObject:goodsModel];
    }
      [self.celltableView reloadData];
    if (self.dataArray.count == 0) {
        self.cellTableViewHeight.constant = 0;
    }else{
        self.cellTableViewHeight.constant = ceil(_dataArray.count*110);
    }
  
}


#pragma mark – JYTimerListenerDelegate

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [self onTimer];
}

-(void)didOnTimer:(JYTimerUtil *)timerUtil timeInterval:(NSTimeInterval)timeInterval
{
    [self onTimer];
}
//定时器开始
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
       
        NSInteger days = (int)(secondsCountDown/(3600*24));
        NSInteger hours = (int)((secondsCountDown-days*24*3600)/3600);
        NSInteger minute = (int)(secondsCountDown-days*24*3600-hours*3600)/60;
        NSInteger second = secondsCountDown - days*24*3600 - hours*3600 - minute*60;
        NSString *strTime = [NSString stringWithFormat:@"剩余: %02ld : %02ld : %02ld", hours, minute, second];
        self.timeLabel.text = [NSString stringWithFormat:@"%@",strTime];
      
    }else {
      
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
#pragma mark --XibFunction
- (IBAction)rightBtnClick:(id)sender {
    self.rightBlock();
}
- (IBAction)leftBtnClick:(id)sender {
    self.quxiaoBlock();
}
- (IBAction)pingjiaBtnClick:(id)sender {
    self.pingjiaBlock();
}
- (IBAction)deleteBtnClick:(id)sender {
    self.deleteBlock();
}

#pragma mark – 懒加载
-(NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [NSMutableArray array];
        
    }
    return _dataArray;
}

@end
