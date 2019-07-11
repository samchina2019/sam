//
//  ZidingyiYCViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ZidingyiYCViewController.h"
#import "ZidingyiYIchangCell.h"
#import "PPNumberButton.h"
#import "JinduTableViewCell.h"
@interface ZidingyiYCViewController ()
//未到退货
@property (weak, nonatomic) IBOutlet PPNumberButton *tuihuoNumberButton;
//未到补货
@property (weak, nonatomic) IBOutlet PPNumberButton *buhuoNumberButton;
//
@property (strong, nonatomic) IBOutlet UIView *yichangChuliView;
//破损补齐
@property (weak, nonatomic) IBOutlet PPNumberButton *huanhuoNumberButton;

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UIView *basicView;

//宜家居家装设计装修官方旗舰店
@property (weak, nonatomic) IBOutlet UILabel *shangjiaNamelabel;
//订单编号：20180230230656000236
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
//下单时间：2018-11-12 12:12
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

//收件人：张三
@property (weak, nonatomic) IBOutlet UILabel *shoujianrenNamelabel;
//13526567147
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//河南省郑州市管城回族区南曹乡美景鸿城七里河小区
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//已收货商品
@property (weak, nonatomic) IBOutlet UILabel *ysspLabel;
//异常货物区域
@property (weak, nonatomic) IBOutlet UILabel *yichangquyuLabel;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;


@end

@implementation ZidingyiYCViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
  
    [self.navigationController setNavigationBarHidden:NO  animated:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if (@available(iOS 11.0, *)) {
        self.detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    [self initBasicView];
    [self initDetailTableView];
    
    self.huanhuoNumberButton.currentNumber=3;
    self.buhuoNumberButton.currentNumber=3;
    self.tuihuoNumberButton.currentNumber=3;
    
}

-(void)initDetailTableView{
    self.headView.frame = CGRectMake(0, 0, ViewWidth, 350);
    self.detailTableView.tableHeaderView = self.headView;
    self.footView.frame = CGRectMake(0, 0, ViewWidth, 65);
    
    self.detailTableView.tableFooterView = self.footView;
    
    [self.detailTableView  setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.detailTableView registerNib:[UINib nibWithNibName:@"ZidingyiYIchangCell" bundle:nil] forCellReuseIdentifier:@"ZidingyiYIchangCell"];
    
      [self.detailTableView registerNib:[UINib nibWithNibName:@"JinduTableViewCell" bundle:nil] forCellReuseIdentifier:@"JinduTableViewCell"];
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    self.detailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.detailTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    
    
    [self.detailTableView.mj_header beginRefreshing];
    
}
-(void)initBasicView{
    //阴影的颜色
    self.basicView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.basicView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.basicView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.basicView.layer.shadowOffset = CGSizeMake(0,0);
    self.basicView.layer.cornerRadius = 5;
}


- (void)refresh
{
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    //    NSDictionary *params = @{@"uid":[User getUserID],
    //                             @"token":[User getToken],
    //                             @"p":@(_page)};
    //    [DZNetworkingTool postWithUrl:kMineMyFansURL params:params success:^(NSURLSessionDataTask *task, id responseObject) {
    //        if (self.tableView.mj_footer.isRefreshing) {
    //            [self.tableView.mj_footer endRefreshing];
    //        }
    //        if (self.tableView.mj_header.isRefreshing) {
    //            [self.tableView.mj_header endRefreshing];
    //        }
    //        if ([responseObject[@"code"] intValue] == SUCCESS) {
    //            NSDictionary *dict = responseObject[@"data"];
    //            if (isRefresh) {
    //                [self.dataArray removeAllObjects];
    //            }
    //            [self.dataArray addObjectsFromArray:dict[@"list"]];
    //            [self.tableView reloadData];
    //            if (self.dataArray.count == [dict[@"total"] intValue]) {
    //                [self.tableView.mj_footer endRefreshingWithNoMoreData];
    //            }
    //        }else
    //        {
    //            [DZTools showNOHud:responseObject[@"msg"] delay:2];
    //        }
    //    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
    //        if (self.tableView.mj_footer.isRefreshing) {
    //            [self.tableView.mj_footer endRefreshing];
    //        }
    //        if (self.tableView.mj_header.isRefreshing) {
    //            [self.tableView.mj_header endRefreshing];
    //        }
    //        [DZTools showNOHud:RequestServerError delay:2.0];
    //    } IsNeedHub:NO];
    if (self.detailTableView.mj_footer.isRefreshing) {
        [self.detailTableView.mj_footer endRefreshing];
    }
    if (self.detailTableView.mj_header.isRefreshing) {
        [self.detailTableView.mj_header endRefreshing];
    }
    if (isRefresh) {
        [self.dataArray removeAllObjects];
    }
    for (int i = 0; i < 3; i++) {
        [self.dataArray addObject:@{@"name":@"购买商品",@"time":@"2018-11-22 12:00:22",@"money":@"-10"}];
        [self.dataArray addObject:@{@"name":@"佣金收入",@"time":@"2018-11-12 12:00:22",@"money":@"+40"}];
    }
    [self.detailTableView reloadData];
}
-(void)loadMore{
    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}

#pragma mark--tableview deleteGate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        if (self.dataArray.count == 0) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.detailTableView.backgroundView = backgroundImageView;
            self.detailTableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.detailTableView.backgroundView = nil;
        }
        return self.dataArray.count;
    }else{
        
        return 3;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        return 120;
    }
    return 60;
    
}
- (UIView *)tableView:(UITableView *)tableView vieworHeaderInSection:(NSInteger)section
{
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
    return view;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        return 10;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0) {
        ZidingyiYIchangCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZidingyiYIchangCell" forIndexPath:indexPath];
        NSDictionary *dict = self.dataArray[indexPath.row];
        
        
        
        return cell;
    }else{
        
        JinduTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"JinduTableViewCell" forIndexPath:indexPath];
        if (indexPath.row==0) {
            cell.jinDuBtn.selected=YES;
            
        }else{
            cell.shangjiaMessageLabel.text=@"商家审核通过";
            cell.jinDuBtn.selected=NO;
        }
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
#pragma mark --XibFunction
///打电话
- (IBAction)callBtnClick:(id)sender {
}
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//聊天
- (IBAction)chatBtnClick:(id)sender {
}

//展开点击事件
- (IBAction)zhankaiBtnClick:(id)sender {
}
//未到补齐
- (IBAction)weidaobuhuoBtnClick:(id)sender {
}
//破损补齐
- (IBAction)posunbuqiBtnClick:(id)sender {
}
//未到退货
- (IBAction)weidaotuihuoBtnClick:(id)sender {
}

//X按钮的点击事件
- (IBAction)wrongBtnClick:(id)sender {
    [self.yichangChuliView removeFromSuperview];
}
//确定按钮的点击事件
- (IBAction)sureBtnClick:(id)sender {
    [self.yichangChuliView removeFromSuperview];
}

//申诉点击事件
- (IBAction)shensuBtnClick:(id)sender {
  
    //alertViewController的自定义文字颜色
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"申诉" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField){
        textField.placeholder = @"请输入您要申诉的原因";
        
    }];
    
    //
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"处理" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self chuliPay];
    }];
    // 设置按钮的title颜色
    
    [okAction setValue: [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [okAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [alert addAction:okAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}
//处理点击事件
-(void)chuliPay{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//申请处理点击事件
- (IBAction)shenqingChuliBtnClick:(id)sender {
    
}

- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}
@end
