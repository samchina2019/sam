//
//  AddFriendsListViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddFriendsListViewController.h"
#import "FriendsListCell.h"
#import "AddFriendViewController.h"
#import <Contacts/Contacts.h>
#import "ContactListViewController.h"
#import "ContactModel.h"
#import "FriendsListModel.h"
#import "AddFriendDetailViewController.h"

@interface AddFriendsListViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic) NSInteger page;

@property (nonatomic , assign) NSInteger userId;

@end

@implementation AddFriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"新朋友";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void){
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsListCell" bundle:nil] forCellReuseIdentifier:@"FriendsListCell"];
    [self.tableView.mj_header beginRefreshing];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [button setTitle:@"添加朋友" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    button.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}
- (void)rightBarButtonItemClicked {
    AddFriendViewController *viewController = [AddFriendViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
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
    NSDictionary *params = @{@"page":@(_page),
                             @"limit":@(20)};
    [DZNetworkingTool postWithUrl:kApplyFriendList params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if (self.tableView.mj_footer.isRefreshing) {
            [self.tableView.mj_footer endRefreshing];
        }
        if (self.tableView.mj_header.isRefreshing) {
            [self.tableView.mj_header endRefreshing];
        }
        if (isRefresh) {
            [self.dataArray removeAllObjects];
        }
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            
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
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell" forIndexPath:indexPath];
    FriendsListModel *model = self.dataArray[indexPath.row];
    cell.nameLabel.text = model.nickname;
    cell.phoneLabel.text = model.mobile;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    if ([model.status intValue] == 0) {
        cell.chakanLabel.text = @"已添加";
        cell.chakanLabel.backgroundColor = [UIColor whiteColor];
    }else if ([model.status intValue] == 1){
        cell.chakanLabel.text = @"已拒绝";
        cell.chakanLabel.backgroundColor = UIColorFromRGB(0xFA5458);
        cell.tongyiButton.hidden = NO;
        [cell.tongyiButton setTitle:@"加好友" forState:UIControlStateNormal];
        cell.tongyiButton.userInteractionEnabled = YES;
        //添加好友
        cell.tongyiBlock = ^{
            self.userId = model.user_id;
            [self addFriend];
        };
    }else{
        cell.chakanLabel.text = @"同意";
        cell.chakanLabel.backgroundColor = UIColorFromRGB(0x3FAEE9);
    }
    cell.chakanLabel.hidden = NO;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendsListModel *model = self.dataArray[indexPath.row];
    AddFriendDetailViewController *viewController = [AddFriendDetailViewController new];
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.model = model;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - UISerchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    if (searchBar.text.length == 0) {
//        self.searchActive = NO;
        [self.tableView reloadData];
        return;
    }
    NSDictionary *dict = @{
                           @"phone":searchBar.text
                           };
    [DZNetworkingTool postWithUrl:kSearchFriend params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSArray *array = responseObject[@"data"];
            
            [self.dataArray removeAllObjects];
            
            for (NSDictionary *dict in array) {
                FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:dict];
                [self.dataArray addObject:model];
            }
            [self.tableView reloadData];
        }else{
            [self.dataArray removeAllObjects];
            [self.tableView reloadData];
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
}

#pragma mark - Function
//加好友
-(void)addFriend{
    NSDictionary *params = @{@"friend_id":@(self.userId)};
    [DZNetworkingTool postWithUrl:kApplyFriend params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [self refresh];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        
    } IsNeedHub:NO];
}
#pragma mark - Xibfunction
//通讯录
- (IBAction)addPhoneConnectBtnClicked:(id)sender {
    [self requestContactAuthorAfterSystemVersion];
}
//请求通讯录权限
#pragma mark 请求通讯录权限
- (void)requestContactAuthorAfterSystemVersion{
    
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    if (status == CNAuthorizationStatusNotDetermined) {
        CNContactStore *store = [[CNContactStore alloc] init];
        [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError*  _Nullable error) {
            if (error) {
                NSLog(@"授权失败");
            }else {
                NSLog(@"成功授权");
                [self openContact];
            }
        }];
    }
    else if(status == CNAuthorizationStatusRestricted)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusDenied)
    {
        NSLog(@"用户拒绝");
        [self showAlertViewAboutNotAuthorAccessContact];
    }
    else if (status == CNAuthorizationStatusAuthorized)//已经授权
    {
        //有通讯录权限-- 进行下一步操作
        [self openContact];
    }
    
}

//有通讯录权限-- 进行下一步操作
- (void)openContact{
    // 获取指定的字段,并不是要获取所有字段，需要指定具体的字段
    NSArray *keysToFetch = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
    CNContactFetchRequest *fetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:keysToFetch];
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    
    NSMutableArray *contactArray = [NSMutableArray arrayWithCapacity:0];
    __block NSString *phoneStr = @"";
    [contactStore enumerateContactsWithFetchRequest:fetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        //拼接姓名
        NSString *nameStr = [NSString stringWithFormat:@"%@%@",contact.familyName,contact.givenName];
        NSArray *phoneNumbers = contact.phoneNumbers;
        for (CNLabeledValue *labelValue in phoneNumbers) {
            //遍历一个人名下的多个电话号码
            CNPhoneNumber *phoneNumber = labelValue.value;
            NSString * string = phoneNumber.stringValue ;
            //去掉电话中的特殊字符
            string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
            string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
//            NSLog(@"姓名=%@, 电话号码是=%@", nameStr, string);
            [contactArray addObject:[ContactModel mj_objectWithKeyValues:@{@"name":nameStr,@"phone":string}]];
            if (phoneStr.length == 0) {
                phoneStr = string;
            }else{
                phoneStr = [NSString stringWithFormat:@"%@,%@",phoneStr,string];
            }
        }
        //    *stop = YES; // 停止循环，相当于break；
    }];
    ContactListViewController *viewController = [ContactListViewController new];
    viewController.dataArray = contactArray;
    viewController.hidesBottomBarWhenPushed = YES;
    viewController.phoneStr = phoneStr;
    [self.navigationController pushViewController:viewController animated:YES];
}

//提示没有通讯录权限
- (void)showAlertViewAboutNotAuthorAccessContact{
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:@"请授权通讯录权限"
                                          message:@"请在iPhone的\"设置-隐私-通讯录\"选项中,允许花解解访问你的通讯录"
                                          preferredStyle: UIAlertControllerStyleAlert];
    
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
}
@end
