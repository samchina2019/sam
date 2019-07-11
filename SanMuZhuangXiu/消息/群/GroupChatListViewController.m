//
//  GroupChatListViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GroupChatListViewController.h"
#import "CreateGroupViewController.h"
#import "GroupListCell.h"
#import "MessageGroupModel.h"
#import "ChatViewController.h"

@interface GroupChatListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@end

@implementation GroupChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"群聊";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [button setImage:[UIImage imageNamed:@"nav_icon_add"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"GroupListCell" bundle:nil] forCellReuseIdentifier:@"GroupListCell"];
    [self.tableView.mj_header beginRefreshing];
}
- (void)rightBarButtonItemClick
{
    CreateGroupViewController *viewController = [CreateGroupViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)refresh
{
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh
{
    [DZNetworkingTool postWithUrl:kXXGroupList params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in array) {
                MessageGroupModel *model = [MessageGroupModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];

        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
#pragma mark--- UITableViewDataSource and UITableViewDelegate Methods---
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
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GroupListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"GroupListCell" forIndexPath:indexPath];
    MessageGroupModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.group_name;
    cell.phoneLabel.text = @"";
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.group_image] placeholderImage:[UIImage imageNamed:@"img_head"]];
    if (model.group_owner) {
        cell.editBtn.hidden = NO;
    }else{
        cell.editBtn.hidden = YES;
    }
    cell.block = ^{
        CreateGroupViewController *viewController = [CreateGroupViewController new];
        viewController.groupModel = model;
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.isEdit = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    };
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
// 修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageGroupModel *model = self.dataArray[indexPath.row];
    if (model.group_owner) {
        return @"解散群";
    }else{
        return @"退群";
    }
}
// 定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}
// 进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MessageGroupModel *model = self.dataArray[indexPath.row];
        NSDictionary *params = @{@"group_id": @(model.group_id),
                                 @"del_ids":@""};
        [DZNetworkingTool postWithUrl:kXXManagerGroup params:params success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
            }else{
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        } IsNeedHub:NO];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    MessageGroupModel *model = self.dataArray[indexPath.row];
    //会话列表
    ChatViewController *conversationVC = [[ChatViewController alloc] init];
    conversationVC.hidesBottomBarWhenPushed = YES;
    conversationVC.conversationType = ConversationType_GROUP;
    conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)model.group_id];
    conversationVC.title = model.group_name;
    [self.navigationController pushViewController:conversationVC animated:YES];
}



@end
