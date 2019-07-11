//
//  MessageViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/19.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MessageViewController.h"
#import "MessageListCell.h"
#import "MessageHeaderView.h"
#import "MessageFooterView.h"
#import "SystemMessageViewController.h"
#import "ChatViewController.h"
#import "FriendsListViewController.h"
#import "TabBarController.h"
#import "CreateGroupViewController.h"
#import "GoodsHuoDongViewController.h"

@interface MessageViewController ()

@property (strong, nonatomic) MessageHeaderView *headerView;
@property (strong, nonatomic) MessageFooterView *footerView;
@property (strong, nonatomic) NSDictionary *dataDict;

@end

@implementation MessageViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [(TabBarController *) self.tabBarController setBadageNum];
    if (!self.isJuheList) {
        [self getHeaderData];
        [self getQunName];
    }
}
- (void)viewDidLoad {
    //重写显示相关的接口，必须先调用super，否则会屏蔽SDK默认的处理
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    if (self.isJuheList) {
        self.navigationItem.title = @"群聊";
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        [button setImage:[UIImage imageNamed:@"nav_icon_add"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(addQunLiaoBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self setDisplayConversationTypes:@[@(ConversationType_GROUP)]];

        UIImage *image1 = [UIImage imageNamed:@"back"];
        image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        self.navigationController.interactivePopGestureRecognizer.delegate = (id) self;
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image1 style:UIBarButtonItemStyleDone target:self action:@selector(backBarButtonItemClicked)];
    } else {
        [self setCenterTitleView];
        [self getHeaderData];
        [self settttTabelViewHeadFootView];

        //设置需要显示哪些类型的会话
        [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),
                                            @(ConversationType_GROUP),
                                            @(ConversationType_APPSERVICE),
                                            @(ConversationType_SYSTEM)]];
        //设置需要将哪些类型的会话在会话列表中聚合显示
        [self setCollectionConversationType:@[@(ConversationType_DISCUSSION),
                                              @(ConversationType_GROUP)]];
    }
    //无消息背景
    UIImage *image = [UIImage imageNamed:@"no_message_img"];
    //    self.emptyConversationView = [[UIView alloc]init];
    self.emptyConversationView.backgroundColor = [UIColor colorWithPatternImage:image];
    
    self.conversationListTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.conversationListTableView.separatorColor = UIColorFromRGB(0xdfdfdf);
}

#pragma mark – UI

- (void)setCenterTitleView {
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
    [button setImage:[UIImage imageNamed:@"nav_addp"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.title = @"消息";

    UIButton *centerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    centerBtn.frame = CGRectMake(0, 0, ViewWidth - 100, 30);
    [centerBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [centerBtn setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    centerBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [centerBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    centerBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    centerBtn.backgroundColor = UIColorWithRGB(230, 230, 230, 1.0);
    centerBtn.layer.cornerRadius = 5;
    centerBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    centerBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 20, 0, 10);
    [centerBtn addTarget:self action:@selector(searchBtnClcked) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.titleView = centerBtn;
}
- (void)settttTabelViewHeadFootView {

    self.conversationListTableView.tableHeaderView = nil;
    self.conversationListTableView.tableFooterView = nil;

    if (self.dataDict == nil) {
        self.headerView.frame = CGRectMake(0, 0, ViewWidth, 220);
        self.conversationListTableView.tableHeaderView = self.headerView;
        return;
    }

    if ([[self.dataDict allKeys] containsObject:@"abnormal"]) {
        self.headerView.frame = CGRectMake(0, 0, ViewWidth, 365); //365
    } else {
        self.headerView.frame = CGRectMake(0, 0, ViewWidth, 288); //435
    }
    if ([[self.dataDict allKeys] containsObject:@"share"]) {
        self.footerView.frame = CGRectMake(0, 0, ViewWidth, 83);
//        if ([self.dataDict[@"share"][@"unread"] intValue] == 0) {
//            self.footerView.numberLabel.hidden = YES;
//        } else {
//            self.footerView.numberLabel.hidden = NO;
//            self.footerView.numberLabel.text = self.dataDict[@"share"][@"unread"];
//        }
        
//        self.footerView.timeLabel.text = self.dataDict[@"share"][@"time"];
        self.footerView.sharetitleLabel.text = self.dataDict[@"share"][@"content"];
       
        self.conversationListTableView.tableFooterView = self.footerView;
    } else {
    }
    if ([[self.dataDict allKeys] containsObject:@"system"]) {
        //        self.headerView.xtnumLabel.hidden = NO;
        if ([self.dataDict[@"system"][@"unread"] intValue] == 0) {
            self.headerView.xtnumLabel.hidden = YES;
        } else {
            self.headerView.xtnumLabel.hidden = NO;
            self.headerView.xtnumLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"system"][@"unread"]];
        }
    } else {
        self.headerView.xtnumLabel.hidden = YES;
    }
    if ([[self.dataDict allKeys] containsObject:@"check_work"]) {
        //        self.headerView.kqnumLabel.hidden = NO;
        if ([self.dataDict[@"check_work"][@"unread"] intValue] == 0) {
            self.headerView.kqnumLabel.hidden = YES;
        } else {
            self.headerView.kqnumLabel.hidden = NO;
            self.headerView.kqnumLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"check_work"][@"unread"]];
        }
    } else {
        self.headerView.kqnumLabel.hidden = YES;
    }
    if ([[self.dataDict allKeys] containsObject:@"logistics"]) {

        if ([self.dataDict[@"logistics"][@"unread"] intValue] == 0) {
            self.headerView.wlnumLabel.hidden = YES;
        } else {
            self.headerView.wlnumLabel.hidden = NO;
            self.headerView.wlnumLabel.text = [NSString stringWithFormat:@"%@", self.dataDict[@"logistics"][@"unread"]];
        }
    } else {
        self.headerView.wlnumLabel.hidden = YES;
    }

    self.conversationListTableView.tableHeaderView = self.headerView;
}

#pragma mark – Network

-(void)getQunName{

}
- (void)getHeaderData {
    [DZNetworkingTool postWithUrl:kXiaoXiHome
                           params:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  self.dataDict = responseObject[@"data"];
                                  [self settttTabelViewHeadFootView];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               
                           }
                        IsNeedHub:NO];
}

#pragma mark - Function
- (void)backBarButtonItemClicked {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)searchBtnClcked {
}
- (void)rightBarButtonItemClick {
    self.hidesBottomBarWhenPushed = YES;
    FriendsListViewController *viewController = [[FriendsListViewController alloc] init];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
- (void)addQunLiaoBtnClicked {
    CreateGroupViewController *viewController = [CreateGroupViewController new];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark – UITableViewDelegate
//左滑删除
- (void)rcConversationListTableView:(UITableView *)tableView
                 commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
                  forRowAtIndexPath:(NSIndexPath *)indexPath {
    //可以从数据库删除数据
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:model.targetId];
    [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
    [self.conversationListTableView reloadData];
}
//高度
- (CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}
//自定义cell
- (RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView
                                  cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
  
        MessageListCell *cell = [[MessageListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
        NSString *userName = nil;
        NSString *portraitUri = nil;
        RCUserInfo *user = [[RCIM sharedRCIM] getUserInfoCache:model.targetId];

        if (user.name) {
            userName = user.name;
            portraitUri = user.portraitUri;
            model.conversationTitle = userName;
        } else {
            [[DZTools getAppDelegate]
                getUserInfoWithUserId:model.targetId
                           completion:^(RCUserInfo *user) {
                               if (user == nil) {
                                   return;
                               }
                               RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                               rcduserinfo_.name = user.name;
                               rcduserinfo_.userId = user.userId;
                               rcduserinfo_.portraitUri = user.portraitUri;
                               [self.conversationListTableView reloadRowsAtIndexPaths:@[indexPath]
                                                                     withRowAnimation:UITableViewRowAnimationAutomatic];
                           }];
        }
    
       cell.titleLabel.text = userName;
        //"RC:ImgMsg"="[图片]";"RC:LBSMsg"="[位置]";"RC:VcMsg"="[语音]";"RC:ImgTextMsg"="[图文]";"RC:PSMultiImgTxtMsg"="[图文]";"RC:PSImgTxtMsg"="[图文]";"RC:SightMsg"="[小视频]";RC:TxtMsg
        if ([model.objectName isEqualToString:@"RC:VcMsg"]) {
            cell.contentLabel.text = @"[语音]";
        } else if ([model.objectName isEqualToString:@"RC:LBSMsg"]) {
            cell.contentLabel.text = @"[位置]";
        } else if ([model.objectName isEqualToString:@"RC:ImgMsg"]) {
            cell.contentLabel.text = @"[图片]";
        } else if ([model.objectName isEqualToString:@"RC:SightMsg"]) {
            cell.contentLabel.text = @"[小视频]";
        } else if ([model.objectName isEqualToString:@"RC:TxtMsg"]) {
            RCTextMessage *textMessage = (RCTextMessage *) model.lastestMessage;
            cell.contentLabel.text = textMessage.content;
        } else {
            cell.contentLabel.text = @"[其他]";
        }
        [cell.imgView sd_setImageWithURL:[NSURL URLWithString:portraitUri]
                        placeholderImage:[UIImage imageNamed:@"contact"]];
        cell.numLabel.text = [NSString stringWithFormat:@"%ld", (long) model.unreadMessageCount];
        if (model.unreadMessageCount > 0) {
            cell.numLabel.hidden = NO;
        } else {
            cell.numLabel.hidden = YES;
        }

        cell.model = model;
        return cell;
   
}
#pragma mark - cell选中事件
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath {

    [self.conversationListTableView deselectRowAtIndexPath:indexPath animated:YES];

    //聚合会话类型，此处自定设置。
    if (conversationModelType == RC_CONVERSATION_MODEL_TYPE_COLLECTION) {
        self.hidesBottomBarWhenPushed = YES;

        MessageViewController *viewController = [[MessageViewController alloc] init];
        NSArray *array = [NSArray arrayWithObject:[NSNumber numberWithInt:model.conversationType]];
        [viewController setDisplayConversationTypes:array];
        [viewController setCollectionConversationType:nil];
        viewController.isEnteredToCollectionViewController = YES;
        viewController.isJuheList = YES;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;

    } else {
        //会话列表
        ChatViewController *conversationVC = [[ChatViewController alloc] init];
        conversationVC.hidesBottomBarWhenPushed = YES;
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
         conversationVC.title = model.conversationTitle;
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}
//插入自定义会话model
- (NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource {

    for (int i = 0; i < dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        if (model.conversationType == ConversationType_PRIVATE) { //单聊
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }

    return dataSource;
}

#pragma mark – 懒加载
- (MessageHeaderView *)headerView {
    if (!_headerView) {
        _headerView = [[MessageHeaderView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 233)]; //220
        __weak typeof(self) weakSelf = self;
        _headerView.block = ^(NSInteger type) {
            NSLog(@"点击");
            if (type < 6) {
                SystemMessageViewController *viewController = [[SystemMessageViewController alloc] init];
                viewController.type = type;
                viewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            } else if (type == 7) { //活动
                GoodsHuoDongViewController *viewController = [[GoodsHuoDongViewController alloc] init];
                viewController.hidesBottomBarWhenPushed = YES;
                [weakSelf.navigationController pushViewController:viewController animated:YES];
            } else if (type == 8) { //客服
                
            } else { //考勤
            }
        };
    }
    return _headerView;
}
- (MessageFooterView *)footerView {
    if (!_footerView) {
        __weak typeof(self) weakSelf = self;
        _footerView = [[MessageFooterView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 83)]; //220
        _footerView.block = ^{
            NSLog(@"点击");
            weakSelf.tabBarController.selectedIndex = 3;
        };
    }
    return _footerView;
}

@end
