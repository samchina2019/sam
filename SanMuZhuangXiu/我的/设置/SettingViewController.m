//
//  SettingViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/25.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "SettingViewController.h"

#import "ChangePasswordViewController.h"
#import "WebViewViewController.h"
#import "SoundReminderViewController.h"
#import "RenGongServerViewController.h"

@interface SettingViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"设置";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.rowHeight = 50;
    [self.view addSubview:self.tableView];
}
#pragma mark UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return section == 0 ? 5 : 1;
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    if (indexPath.section == 1) {
        cell.textLabel.text = @"退出当前";
        return cell;
    }
    
    switch (indexPath.row + 1)
    {
        case 1:
            cell.textLabel.text = @"修改密码";
            break;
//        case 2:
//            cell.textLabel.text = @"声音提醒";
//            break;
        case 2:
            cell.textLabel.text = @"帮助与反馈";
            break;
        case 3:
            cell.textLabel.text = @"免责声明";
            break;
        case 4:
            cell.textLabel.text = @"人工服务";
            break;
        case 5:
            cell.textLabel.text = @"当前版本";
            cell.detailTextLabel.text = [NSString stringWithFormat:@"版本%@",[DZTools getAppVersion]];
            break;
        case 6:
            cell.textLabel.text = @"软件更新";
            break;
        case 7:
            cell.textLabel.text = @"去评分";
            break;
    }
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        [User deleUser];
        [[RCIM sharedRCIM] disconnect:NO];
        [self.navigationController popToRootViewControllerAnimated:YES];
        return;
    }
    
    switch (indexPath.row + 1)
    {
        case 1:
        {
            ChangePasswordViewController *viewController = [ChangePasswordViewController new];
            self.hidesBottomBarWhenPushed = YES;
            viewController.phoneStr=self.phoneStr;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
//        case 2:
//        {
//            SoundReminderViewController *viewController = [SoundReminderViewController new];
//            self.hidesBottomBarWhenPushed = YES;
//            [self.navigationController pushViewController:viewController animated:YES];
//        }
//            break;
        case 2:
        {
            
         
            NSDictionary *dict=@{
                                 @"keywords":@"user_help"
                                 };
            [DZNetworkingTool postWithUrl:kArticleInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSDictionary *temp=responseObject[@"data"];
                    NSString *urlStr=[NSString stringWithFormat:@"%@",temp[@"url"]];
                    
                    WebViewViewController *viewController = [WebViewViewController new];
                    viewController.urlStr = urlStr;
                    viewController.titleStr = @"帮助与反馈";
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }else
                {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:RequestServerError delay:2.0];
            } IsNeedHub:NO];

         
        }
            break;
        case 3:
        {
            NSDictionary *dict=@{
                                 @"keywords":@"disclaimer"
                                 };
            [DZNetworkingTool postWithUrl:kArticleInfo params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSDictionary *temp=responseObject[@"data"];
                     NSString *urlStr=[NSString stringWithFormat:@"%@",temp[@"url"]];
                    
                    WebViewViewController *viewController = [WebViewViewController new];
                    viewController.urlStr = urlStr;
                    viewController.titleStr = @"免责申明";
                    self.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:viewController animated:YES];
                }else
                {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:RequestServerError delay:2.0];
            } IsNeedHub:NO];
        }
            break;
        case 4:
        {
            RenGongServerViewController *viewController = [RenGongServerViewController new];
            self.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
        }
            break;
        case 5:
        {
            [DZTools showText:[NSString stringWithFormat:@"当前版本：%@",[DZTools getAppVersion]] delay:2];
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section == 1 ? 10 : 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
