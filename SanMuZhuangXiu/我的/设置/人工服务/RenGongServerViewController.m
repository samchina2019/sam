//
//  RenGongServerViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/26.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "RenGongServerViewController.h"

@interface RenGongServerViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property(nonatomic,strong)NSString *corporateTelStr;
@property(nonatomic,strong)NSString *corporateNameStr;
@end

@implementation RenGongServerViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"人工服务";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}
-(void)loadData{
    [DZNetworkingTool postWithUrl:kUserServer params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            self.corporateTelStr=[NSString stringWithFormat:@"%@",dict[@"corporate_tel"]];
            self.corporateNameStr=[NSString stringWithFormat:@"%@",dict[@"corporate_name"]];
            [self.tableView reloadData];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"setting";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = UIColorFromRGB(0x101010);
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"公司名称";
            cell.detailTextLabel.text = self.corporateNameStr;
            break;
        case 1:
            cell.textLabel.text = @"电话";
            cell.detailTextLabel.text = self.corporateTelStr;
            break;
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row)
    {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            
        }
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}


@end
