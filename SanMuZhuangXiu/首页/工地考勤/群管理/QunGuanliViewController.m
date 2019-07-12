//
//  QunGuanliViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QunGuanliViewController.h"
#import "QunguanliCell.h"
#import "QunDetailViewController.h"
#import "GroupModel.h"

@interface QunGuanliViewController ()
@property (weak, nonatomic) IBOutlet UITableView *workTableView;

@property (strong, nonatomic) NSMutableArray *dataArray;

@property (nonatomic) NSInteger page;
@end

@implementation QunGuanliViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=@"群管理";
    
    if (@available(iOS 11.0, *)) {
        self.workTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    /// 数据修改 不确定
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
//    [button setTitle:@"跳过" forState:UIControlStateNormal];
//    [button setTitleColor:UIColorFromRGB(0x101010) forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
//    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
//
//
    
    [self.workTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    self.workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.workTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    
    [self.workTableView registerNib:[UINib nibWithNibName:@"QunguanliCell" bundle:nil] forCellReuseIdentifier:@"QunguanliCell"];
    [self.workTableView.mj_header beginRefreshing];
}

#pragma mark – Network

- (void)refresh
{
//    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
-(void)loadMore{
    //    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    
        [DZNetworkingTool postWithUrl:kGroupList params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];
//                if (isRefresh) {
                    [self.dataArray removeAllObjects];
//                }
                for (NSDictionary *dict in array) {
                    GroupModel *model=[GroupModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                [self.workTableView reloadData];
            }else
            {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        } IsNeedHub:NO];

}


#pragma mark - <UITableViewDelegate和DataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.workTableView.backgroundView = backgroundImageView;
        self.workTableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.workTableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 130;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
///section头 不确定数据
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.sectionHeaderView;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QunguanliCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QunguanliCell" forIndexPath:indexPath];
       GroupModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text=[NSString stringWithFormat:@"%@",model.group_name];
    if (model.clockin_time.length==0) {
         cell.timeLabel.text=@"";
    }else{
         cell.timeLabel.text=[NSString stringWithFormat:@"%@打卡",model.clockin_time];
    }
   
    cell.addressLabel.text=[NSString stringWithFormat:@"%@",model.address];
    cell.numberLabel.text=[NSString stringWithFormat:@"管理人员:%d",model.group_admin];
    cell.groupLabel.text=[NSString stringWithFormat:@"群管理人数:%d",model.group_user_num];
    
    if (model.status==1) {
        cell.stateLabel.text=@"开工";
        cell.stateLabel.layer.borderColor =[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0].CGColor;
        [cell.stateLabel setTextColor: [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0]];
        cell.stateLabel.layer.borderWidth = 1;
    }else if(model.status==2){
        cell.stateLabel.layer.borderColor =[UIColor colorWithRed:250/255.0 green:84/255.0 blue:88/255.0 alpha:1.0].CGColor;
        cell.stateLabel.layer.borderWidth = 1;
        [cell.stateLabel setTextColor:[UIColor colorWithRed:250/255.0 green:84/255.0 blue:88/255.0 alpha:1.0]];
        cell.stateLabel.text=@"暂停";
    }else{
        cell.stateLabel.layer.borderColor =[UIColor lightGrayColor].CGColor;
        cell.stateLabel.layer.borderWidth = 1;
        [cell.stateLabel setTextColor:[UIColor lightGrayColor]];
        cell.stateLabel.text=@"结束";
    }
    if (model.unread==0) {
         cell.xiabiaoBtn.hidden=YES;
    }else{
        cell.xiabiaoBtn.hidden=NO;
         [cell.xiabiaoBtn setTitle:[NSString stringWithFormat:@"%d",model.unread] forState:UIControlStateNormal];
    }
 
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GroupModel *model = self.dataArray[indexPath.row];
    
    
    if (_isSelectStatus) {
        self.block(model.group_id);
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
//
    self.hidesBottomBarWhenPushed=YES;
    QunDetailViewController *controller = [[QunDetailViewController alloc] init];

     controller.rule_management = model.rule_management;
     controller.personnel_management = model.personnel_management;
     controller.audit_management = model.audit_management;
     controller.statistical_management = model.statistical_management;
     controller.status = model.status;
     controller.groupName = model.group_name;
     controller.groupId = model.group_id;
    
    [self.navigationController pushViewController:controller animated:YES];
    self.hidesBottomBarWhenPushed=YES;
    
    
}

@end
