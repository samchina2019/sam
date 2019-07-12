//
//  AddFriendViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddFriendViewController.h"
#import "AddFriendCell.h"
#import "FriendsListModel.h"

@interface AddFriendViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@end

@implementation AddFriendViewController

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.searchBar.delegate = nil;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"添加朋友";

    self.dataArray = [NSMutableArray arrayWithCapacity:0];

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"AddFriendCell" bundle:nil] forCellReuseIdentifier:@"AddFriendCell"];
    [self.searchBar becomeFirstResponder];
    self.navigationController.navigationBar.translucent = YES;
    self.searchBar.translucent = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.extendedLayoutIncludesOpaqueBars = YES;
}
- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    if (self.searchBar.text.length == 0) {
        [self.dataArray removeAllObjects];
        [self.tableView reloadData];
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        [DZTools showText:@"请输入搜索内容" delay:2];
        return;
    }
    NSDictionary *params = @{@"phone":self.searchBar.text,
                             @"page":@(_page),
                             @"limit":@(20)};
    [DZNetworkingTool postWithUrl:kSearchFriend params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            for (NSDictionary *dict in array) {
                FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:dict];
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
#pragma mark - <UITableViewDelegate和DataSource>
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddFriendCell" forIndexPath:indexPath];
    FriendsListModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.nickname;
    cell.phoneLabel.text = model.mobile;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendsListModel *model = self.dataArray[indexPath.row];
    NSDictionary *params = @{@"friend_id":@(model.user_id)};
    [DZNetworkingTool postWithUrl:kApplyFriend params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
           AddFriendCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.shenqingLabel.text = @"已申请";
//            cell.shenqingLabel.backgroundColor = [UIColor c];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    } IsNeedHub:NO];
}
#pragma mark - UISerchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    NSLog(@"search");
    [self.tableView.mj_header beginRefreshing];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    [self.tableView.mj_header beginRefreshing];
    NSLog(@"cancel");
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
