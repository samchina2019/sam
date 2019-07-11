//
//  FriendsListViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/23.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FriendsListViewController.h"
#import "FriendsListCell.h"
#import "GroupChatListViewController.h"
#import "AddFriendsListViewController.h"
#import "FriendsListModel.h"
#import "ChatViewController.h"
#import "AddFriendViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "SGQRCode.h"
#import "WCQRCodeVC.h"
#import "SGQRCodeGenerateManager.h"

@interface FriendsListViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UILabel *xinNumLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)UIImage *myImage;
@property(nonatomic,assign)CGRect lastFrame;
@property(nonatomic,strong)UIButton *erweimaBtn;
@property (nonatomic, strong) UIImageView *erweimaImageView;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSArray *tableData;
@property (nonatomic, strong) NSMutableArray *resultData;
@property (nonatomic, strong) NSArray *tableIndexData;
@property (nonatomic, strong) NSMutableArray *resultIndexData;
///搜索第几个
@property (nonatomic, assign) NSInteger indextFriend;
///选中第几个好友
@property (nonatomic, assign) NSInteger selectIndex;

@property (nonatomic, assign) BOOL searchActive;

@end

@implementation FriendsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initItem];

  
    [self initTableView];
    
    User *user=[User getUser];
    NSDictionary *dict=@{
                         @"type":@(1),
                         @"uId":[User getUserID],
                         @"name":user.username
                         };
    //自定生成二维码
    UIImage *image=[SGQRCodeGenerateManager generateWithDefaultQRCodeData:[dict mj_JSONString] imageViewWidth:ViewWidth];
    
    self.myImage=image;

}
-(void)initTableView{
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.tableFooterView = [UIView new];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"FriendsListCell" bundle:nil] forCellReuseIdentifier:@"FriendsListCell"];
    [self.tableView.mj_header beginRefreshing];
}
-(void)initItem{
    self.navigationItem.title = @"好友";
    
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [button setImage:[UIImage imageNamed:@"icon_xiangji"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(shaoyisBook) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    self.erweimaBtn=button1;
    [button1 setImage:[UIImage imageNamed:@"erweima"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(erweimaClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1=[[UIBarButtonItem alloc]initWithCustomView:button1];
    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [button2 setImage:[UIImage imageNamed:@"nav_addp"] forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item2=[[UIBarButtonItem alloc]initWithCustomView:button2];
    self.navigationItem.rightBarButtonItems = @[item2,item1,item];
}
//二维码的点击
-(void)erweimaClick{
    UIImage *image = [UIImage imageNamed:@"WechatIMG25"];
    //添加遮盖
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0,image.size.width, image.size.height)];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WechatIMG25"]];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    //添加图片到遮盖上
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.myImage];
    imageView.frame = CGRectMake(0, 0, 5, 5);
    
    UIImageView *tempImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WechatIMG25"]];
    tempImage.size = CGSizeMake( cover.frame.size.width*0.8, cover.frame.size.width * (tempImage.image.size.height / tempImage.image.size.width)*0.6);
    tempImage.centerX = cover.centerX;
    tempImage.centerY = cover.centerY;
    [tempImage addSubview:imageView];
    
    [cover addSubview:tempImage];

    //放大
    [UIView animateWithDuration:0.3f
                     animations:^{
                         cover.backgroundColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:0.8];
                         CGRect frame = tempImage.frame;
                         frame.size.width = cover.frame.size.width*0.5;
                         frame.size.height = cover.frame.size.width * (tempImage.image.size.height / tempImage.image.size.width)*0.4;
                         frame.origin.x = cover.frame.size.width*0.15;
                         frame.origin.y = (cover.frame.size.height - frame.size.height) * 0.1;
                         imageView.frame = frame;
                     }];

}
- (void)tapCover:(UITapGestureRecognizer *)recognizer
{
    [UIView animateWithDuration:0.3f animations:^{
        recognizer.view.backgroundColor = [UIColor clearColor];
        self.erweimaBtn.frame = self.lastFrame;
        
    }completion:^(BOOL finished) {
        [recognizer.view removeFromSuperview];
        self.erweimaBtn = nil;
    }];
}
//扫一扫
-(void)shaoyisBook{
    
    __weak typeof(self) weakSelf = self;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted) {
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            weakSelf.hidesBottomBarWhenPushed = YES;
                            WCQRCodeVC *viewController = [WCQRCodeVC new];
                            [weakSelf.navigationController pushViewController:viewController animated:YES];
                            weakSelf.hidesBottomBarWhenPushed = NO;
                        });
                        NSLog(@"用户第一次同意了访问相机权限 - - %@", [NSThread currentThread]);
                    } else {
                        NSLog(@"用户第一次拒绝了访问相机权限 - - %@", [NSThread currentThread]);
                    }
                }];
                break;
            }
            case AVAuthorizationStatusAuthorized: {
                weakSelf.hidesBottomBarWhenPushed = YES;
                WCQRCodeVC *viewController = [WCQRCodeVC new];
                [weakSelf.navigationController pushViewController:viewController animated:YES];
                weakSelf.hidesBottomBarWhenPushed = NO;
                break;
            }
            case AVAuthorizationStatusDenied: {
                UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"请去-> [设置-> HOOLA 打开相机访问开关" preferredStyle:(UIAlertControllerStyleAlert)];
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                    
                }];
                
                [alertC addAction:alertA];
                [weakSelf presentViewController:alertC animated:YES completion:nil];
                break;
            }
            case AVAuthorizationStatusRestricted: {
                NSLog(@"因为系统原因, 无法访问相册");
                break;
            }
                
            default:
                break;
        }
        return;
    }
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"未检测到您的摄像头" preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertC addAction:alertA];
    [weakSelf presentViewController:alertC animated:YES completion:nil];
    
    
}
- (void)rightBarButtonItemClick {
    AddFriendViewController *viewController = [AddFriendViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
- (void)refresh {
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    [DZNetworkingTool postWithUrl:kFriendsList
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"][@"friend_list"];
                if ([responseObject[@"data"][@"new_friend"] intValue] == 0) {
                    self.xinNumLabel.hidden = YES;
                }else{
                    self.xinNumLabel.hidden = NO;
                    self.xinNumLabel.text = [NSString stringWithFormat:@"%@",responseObject[@"data"][@"new_friend"]];
                }
               
                for (NSDictionary *dict in array) {
                    FriendsListModel *model = [FriendsListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                NSArray *tempArray = [self sringSectioncompositor:self.dataArray withSelector:@selector(nickname) isDeleEmptyArray:YES];
                self.tableData = tempArray[0];
                self.tableIndexData = tempArray[1];
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.tableView.mj_header.isRefreshing) {
                [self.tableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//将传进来的对象按通讯录那样分组排序，每个section中也排序  dataarray是中存储的是一组对象，selector是属性名
- (NSArray *)sringSectioncompositor:(NSArray *)dataArray withSelector:(SEL)selector isDeleEmptyArray:(BOOL)isDele {
    //    UILocalizedIndexedCollation是苹果贴心为开发者提供的排序工具，会自动根据不同地区生成索引标题
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    NSMutableArray *indexArray = [NSMutableArray arrayWithArray:collation.sectionTitles];
    NSUInteger sectionNumber = indexArray.count;
    //建立每个section数组
    NSMutableArray *sectionArray = [NSMutableArray arrayWithCapacity:sectionNumber];
    for (int n = 0; n < sectionNumber; n++) {
        NSMutableArray *subArray = [NSMutableArray array];
        [sectionArray addObject:subArray];
    }
    for (FriendsListModel *model in dataArray) {
        //        根据SEL方法返回的字符串判断对象应该处于哪个分区
        NSInteger index = [collation sectionForObject:model collationStringSelector:selector];
        NSMutableArray *tempArray = sectionArray[index];
        [tempArray addObject:model];
    }
    for (NSMutableArray *tempArray in sectionArray) {
        //        根据SEL方法返回的string对数组元素排序
        NSArray *sorArray = [collation sortedArrayFromArray:tempArray collationStringSelector:selector];
        [tempArray removeAllObjects];
        [tempArray addObjectsFromArray:sorArray];
    }
    //    是否删除空数组
    if (isDele) {
        [sectionArray enumerateObjectsWithOptions:NSEnumerationReverse
                                       usingBlock:^(NSArray *obj, NSUInteger idx, BOOL *_Nonnull stop) {
                                           if (obj.count == 0) {
                                               [sectionArray removeObjectAtIndex:idx];
                                               [indexArray removeObjectAtIndex:idx];
                                           }
                                       }];
    }
    //返回第一个数组为table数据源  第二个数组为索引数组
    return @[sectionArray, indexArray];
}
#pragma mark--- UITableViewDataSource and UITableViewDelegate Methods---
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.searchActive ? self.resultData.count : self.tableData.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchActive ? [self.resultData[section] count] : [self.tableData[section] count];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    // 设置section背景颜色
    view.tintColor = UIColorWithRGB(63, 174, 233, 0.1);
    // 设置section字体颜色
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *) view;
    [header.textLabel setTextColor:UIColorFromRGB(0x333333)];
    header.textLabel.font = [UIFont systemFontOfSize:12];
}
//添加TableView头视图标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.searchActive ? self.resultIndexData[section] : _tableIndexData[section];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsListCell" forIndexPath:indexPath];
     FriendsListModel *model = self.searchActive ? self.resultData[indexPath.section][indexPath.row] : self.tableData[indexPath.section][indexPath.row];
    //删除按钮
    cell.deleteBtn.hidden = NO;
    cell.chakanLabel.hidden = NO;
    cell.chakanLabel.text = @"删除";
    cell.deleteBtn.userInteractionEnabled = YES;
    //删除事件的处理
    cell.deleteBlock = ^{
        NSLog(@"点击了呢");
        self.selectIndex = model.user_id;
        [self deleteBtnClick];
    };
   
    cell.nameLabel.text = model.nickname;
    cell.phoneLabel.text = model.mobile;
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendsListModel *model = self.searchActive ? self.resultData[indexPath.section][indexPath.row] : self.tableData[indexPath.section][indexPath.row];
    if (self.isFromCart) {
        if (self.block){
            self.block(model);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else{
        RCUserInfo *rcduserinfo_ = [RCUserInfo new];
        rcduserinfo_.name = model.nickname;
        rcduserinfo_.userId = [NSString stringWithFormat:@"%ld", (long)model.user_id];
        rcduserinfo_.portraitUri = model.avatar;
        [[RCIM sharedRCIM] refreshUserInfoCache:rcduserinfo_ withUserId:[NSString stringWithFormat:@"%ld", (long)model.user_id]];
        //会话列表
        ChatViewController *conversationVC = [[ChatViewController alloc] init];
        conversationVC.hidesBottomBarWhenPushed = YES;
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)model.user_id];
        conversationVC.title = model.nickname;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

#pragma mark – 删除好友
-(void)deleteBtnClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"您确定要删除您的好友吗？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                             
                                                         }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           [self deleteSure];
                                                       }];
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

}
//确定删除
-(void)deleteSure{
    NSDictionary * dict = @{
                            @"user_id":@(self.selectIndex)
                            };
    [DZNetworkingTool postWithUrl:kFriendDel params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [self refresh];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        //        [DZTools showNOHud: delay:2];
    } IsNeedHub:NO];
}
- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.searchActive ? self.resultIndexData : self.tableIndexData;
}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    //这里是为了指定索引index对应的是哪个section的，默认的话直接返回index就好。其他需要定制的就针对性处理
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [tableView setContentOffset:CGPointZero animated:NO]; //tabview移至顶部
        return NSNotFound;
    } else {
        return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index] - 1; // -1 添加了搜索标识
    }
}
#pragma mark - UISerchBarDelegate
#pragma mark - UISearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];// 放弃第一响应者
    if (searchBar.text.length == 0) {
        self.searchActive = NO;
        [self.tableView reloadData];
        return;
    }
    self.searchActive = NO;
    self.resultData = [NSMutableArray array];
    self.resultIndexData = [NSMutableArray array];
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
            NSArray *tempArray = [self sringSectioncompositor:self.dataArray withSelector:@selector(nickname) isDeleEmptyArray:YES];
            self.tableData = tempArray[0];
            self.tableIndexData = tempArray[1];
            
            [self.tableView reloadData];
        }else{
            self.tableData = nil;
            self.tableIndexData = nil;
            [self.tableView reloadData];
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
}
#pragma mark - Scroll View Delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}
-(void)addFrined{
    
     [self.resultIndexData addObject:self.tableIndexData[self.indextFriend]];
    [self.tableView reloadData];
}
#pragma mark - XibFunction
//新朋友
- (IBAction)xinFriendBtnClicked:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    AddFriendsListViewController *viewController = [AddFriendsListViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//群聊
- (IBAction)qunliaoBtnClicked:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    GroupChatListViewController *viewController = [GroupChatListViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
@end
