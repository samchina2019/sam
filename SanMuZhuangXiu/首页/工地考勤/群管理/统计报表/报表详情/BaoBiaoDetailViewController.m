//
//  BaoBiaoDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BaoBiaoDetailViewController.h"
#import "BaoBiaoCell.h"
#import "detailDateModel.h"

@interface BaoBiaoDetailViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *tongjiYueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongjiRiLabel;
@property (weak, nonatomic) IBOutlet UILabel *tongjiJiabanLabel;
@property (weak, nonatomic) IBOutlet UILabel *chidaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *zaotuiLabel;
@property (weak, nonatomic) IBOutlet UILabel *kuanggongLabel;
@property (weak, nonatomic) IBOutlet UILabel *yueLabel;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end

@implementation BaoBiaoDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"详情";
    self.dataArray=[NSMutableArray array];
    [self initTableView];
   
    [self loadBasicData];
}
-(void)loadBasicData{
    if (self.groupId==0) {
        [DZTools showNOHud:@"请选择群以后再看详情" delay:2];
        return;
    }
    NSString *yueStr=@"";

     yueStr=self.month_date;
    NSDictionary *dict=@{
                         @"month_date":yueStr,
                         @"group_id":@(self.groupId)
                         };
    NSLog(@",,,,,,,%@",dict);
    [DZNetworkingTool postWithUrl: kMonthCount params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue ]==SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
        
            if ([yueStr isEqualToString:@"0"]) {
                 self.yueLabel.text=@"2019";
            }else{
                self.yueLabel.text=[NSString stringWithFormat:@"%@",self.month_date];
            }
 
            self.tongjiYueLabel.text=[NSString stringWithFormat:@"考勤人数:%@人",dict[@"peoplenum"]];
            self.tongjiRiLabel.text=[NSString stringWithFormat:@"总计日工:%@",dict[@"total"]];
            self.tongjiJiabanLabel.text=[NSString stringWithFormat:@"累计加班工时:%@",dict[@"cumulative"]];
            self.chidaoLabel.text=[NSString stringWithFormat:@"迟到次数:%@",dict[@"late"]];
            self.zaotuiLabel.text=[NSString stringWithFormat:@"早退次数:%@",dict[@"leave_early"]];
            self.kuanggongLabel.text=[NSString stringWithFormat:@"矿工次数:%@",dict[@"absenteeism"]];
            NSArray *array=dict[@"list"];
            
            for (NSDictionary *temp in array) {
                detailDateModel *model=[detailDateModel mj_objectWithKeyValues:temp];
                [self.dataArray addObject:model];
                
            }
            
            [self.tableView reloadData];
        }else{
            
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
-(void)initTableView{
    self.tableView.backgroundColor=[UIColor whiteColor];
    //阴影的颜色
    self.tableView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.tableView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.tableView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.tableView.layer.shadowOffset = CGSizeMake(0, 0);
    
    
     self.headView.frame = CGRectMake(0, 0, ViewWidth, 150);
    self.tableView.tableHeaderView = self.headView;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        self.tableView.rowHeight = 30;
    [self.tableView registerNib:[UINib nibWithNibName:@"BaoBiaoCell" bundle:nil] forCellReuseIdentifier:@"BaoBiaoCell"];
   
}

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (self.dataArray.count+1);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   BaoBiaoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BaoBiaoCell"];
   
    if (indexPath.row==0) {
        
    }else{
         detailDateModel *model=self.dataArray[indexPath.row-1];
        
        if ([model.over_time isEqualToString:@"未打卡"]) {
            cell.xiabanLabel.textColor=UIColorFromRGB(0xE9B73F);
        }else if (model.late!=0 ){
             cell.xiabanLabel.textColor=UIColorFromRGB(0xFA5458);
        }else{
             cell.xiabanLabel.textColor=UIColorFromRGB(0x333333);
        }
        
        if ([model.leave_time isEqualToString:@"未打卡"]) {
            cell.jiabanLabel.textColor=UIColorFromRGB(0xE9B73F);
        }else if (model.leave_early!=0 ){
            cell.jiabanLabel.textColor=UIColorFromRGB(0xFA5458);
        }else{
            cell.jiabanLabel.textColor=UIColorFromRGB(0x333333);
        }

        cell.nameLabel.text=[NSString stringWithFormat:@"%@",model.name];
        cell.shangbanLabel.text=[NSString stringWithFormat:@"%@",model.work_type];
        cell.xiabanLabel.text=[NSString stringWithFormat:@"%@",model.over_time];
        cell.jiabanLabel.text=[NSString stringWithFormat:@"%@ ",model.leave_time];
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",model.overtime];
    }
    
    return cell;
}

@end
