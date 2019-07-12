//
//  AddressManagerViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/28.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "AddressManagerViewController.h"
#import "AddressManagerListCell.h"
#import "AddAddressViewController.h"
#import "AddressModel.h"

@interface AddressManagerViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation AddressManagerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.navigationItem.title = @"地址管理";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressManagerListCell" bundle:nil] forCellReuseIdentifier:@"AddressManagerListCell"];
    [self.tableView.mj_header beginRefreshing];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"新增" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    
}
#pragma mark-- function
- (void)rightBarButtonItemClicked
{
    AddAddressViewController *viewController = [AddAddressViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark – Network

- (void)refresh
{
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
-(void)loadMore{
    _page = _page +1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    NSDictionary *params = @{
                             @"token":[User getToken],
                             };
    [DZNetworkingTool getWithUrl:kAddressLists params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        //            if(isRefresh){
        [self.dataArray removeAllObjects];
        //            }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            for (NSDictionary *addDict in dict[@"list"]) {
                AddressModel *model=[AddressModel mj_objectWithKeyValues:addDict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
            
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
    
}
#pragma mark - Function
//设置为默认
-(void)defaultClickWithId:(int )addressId{
    
    
    NSDictionary *params = @{@"id":@(addressId)};
    
    [DZNetworkingTool postWithUrl:kSetdefault
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  [self refresh];
                                  
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}
//删除
-(void)deleteClickWithId:(int )addressId{
    NSDictionary *params = @{@"id":@(addressId)};
    
    [DZNetworkingTool postWithUrl:kSAddressDel
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  [self refresh];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}

#pragma mark--tableview deleteGate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.tableView.backgroundView = backgroundImageView;
        self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.tableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 125;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressManagerListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressManagerListCell" forIndexPath:indexPath];
    AddressModel *model=self.dataArray[indexPath.row];
    cell.nameLabel.text=model.name;
    cell.phoneLabel.text=model.phone;
    cell.addressLabel.text=[NSString stringWithFormat:@"%@%@%@%@",model.Area[@"province"],model.Area[@"city"],model.Area[@"region"],model.detail];
    if ([model.isdefault isEqualToString:@"0"]) {
        [cell.defaultBtn setSelected:NO];
    }else if([model.isdefault isEqualToString:@"1"]){
        [cell.defaultBtn setSelected:YES];
    }
    //设置默认
    cell.morenBlock = ^{
        [self defaultClickWithId:model.address_id];
    };
    //删除
    cell.deleteBlock = ^{
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定删除该订单吗？" preferredStyle:UIAlertControllerStyleAlert];
        [alertC addAction:[UIAlertAction actionWithTitle:@"否"
                                                   style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction *_Nonnull action){
                                                 }]];
        [alertC addAction:[UIAlertAction actionWithTitle:@"是"
                                                   style:UIAlertActionStyleCancel
                                                 handler:^(UIAlertAction *_Nonnull action) {
                                                     [self deleteClickWithId:model.address_id];
                                                     
                                                 }]];
        [self presentViewController:alertC animated:YES completion:nil];
        
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressModel *model=self.dataArray[indexPath.row];
    if (self.block){
        self.block(model);
        [self.navigationController popViewControllerAnimated:YES];
    }
}



@end
