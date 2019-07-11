//
//  PeopleManagerViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "PeopleManagerViewController.h"
#import "SetTableViewCell.h"
#import "ZuyuanXinxiViewController.h"
#import "HeadView.h"
#import "GroupPeopleModel.h"
#import "SetPeopleViewController.h"
#import "FriendsListModel.h"
#import "SGQRCodeGenerateManager.h"
#import <UShareUI/UShareUI.h>

@interface PeopleManagerViewController () <UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *sharebtn;
@property (weak, nonatomic) IBOutlet UIButton *addbtn;
@property (weak, nonatomic) IBOutlet UIButton *erweimaBtn;

@property (nonatomic, assign) CGRect lastFrame;
@property (nonatomic) NSInteger page;
@property (nonatomic, strong) UIImage *myImage;

@property (nonatomic, strong) NSMutableArray *adminArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *resultArray;

@end

@implementation PeopleManagerViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self setTableView];
    if ([self.personnel_management isEqualToString:@"3"]) {
        self.addbtn.userInteractionEnabled = YES;
        self.erweimaBtn.userInteractionEnabled = YES;
        self.sharebtn.userInteractionEnabled = YES;
    } else if ([self.personnel_management isEqualToString:@"2"]) {
        self.addbtn.userInteractionEnabled = NO;
        self.erweimaBtn.userInteractionEnabled = NO;
        self.sharebtn.userInteractionEnabled = NO;
    }
    NSDictionary *dict = @{
                           @"type": @(2),
                           @"uId": @(self.group_id),
                           @"name": self.groupName,
                           };
    
    //自定生成二维码
    UIImage *tempImage = [UIImage imageNamed:@"WechatIMG25"];
    //自定生成二维码
    UIImage *image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[dict mj_JSONString] imageViewWidth:tempImage.size.width];
    
    self.myImage = image;
    
    self.erweimaImageView.image = image;
}
- (void)setTableView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 180)];
    [view addSubview:self.bgView];
    //设置圆角
    view.layer.cornerRadius = 3;
    //阴影的颜色
    view.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    view.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    view.layer.shadowRadius = 3.f;
    //阴影偏移量
    view.layer.shadowOffset = CGSizeMake(0, 0);
    
    [self.tableView setTableHeaderView:view];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.tableView.tableFooterView = footerView;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SetTableViewCell" bundle:nil] forCellReuseIdentifier:@"SetTableViewCell"];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark – Network

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {
    NSDictionary *params = @{
                             @"group_id": @(self.group_id)
                             
                             };
    [DZNetworkingTool postWithUrl:kGroupUserList
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if (self.tableView.mj_footer.isRefreshing) {
                                  [self.tableView.mj_footer endRefreshing];
                              }
                              if (self.tableView.mj_header.isRefreshing) {
                                  [self.tableView.mj_header endRefreshing];
                              }
                              [self.adminArray removeAllObjects];
                              [self.dataArray removeAllObjects];
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  
                                  
                                  
                                  NSArray *adminArr = dict[@"group_admin"];
                                  for (NSDictionary *temp in adminArr) {
                                      GroupPeopleModel *model = [GroupPeopleModel mj_objectWithKeyValues:temp];
                                      [self.adminArray addObject:model];
                                  }
                                  
                                  NSArray *array = dict[@"user"];
                                  for (NSDictionary *temp in array) {
                                      GroupPeopleModel *model = [GroupPeopleModel mj_objectWithKeyValues:temp];
                                      [self.dataArray addObject:model];
                                  }
                                  
                                  
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                              [self.tableView reloadData];
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               if (self.tableView.mj_footer.isRefreshing) {
                                   [self.tableView.mj_footer endRefreshing];
                               }
                               if (self.tableView.mj_header.isRefreshing) {
                                   [self.tableView.mj_header endRefreshing];
                               }
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] init];
        if (self.adminArray.count == 0) {
            view.frame = CGRectMake(0, 0, ViewWidth, 0);
        } else {
            view.frame = CGRectMake(0, 0, ViewWidth, 50);
            view.layer.cornerRadius = 3;
            view.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];
            
            UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 50)];
            titleLable.backgroundColor = [UIColor clearColor];
            titleLable.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0];
            titleLable.textAlignment = NSTextAlignmentCenter;
            [view addSubview:titleLable];
            
            titleLable.text = @"管理员";
        }
        
        return view;
    } else {
        HeadView *view = [[HeadView alloc] init];
        if (self.dataArray.count == 0) {
            view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 0);
            view.hidden = YES;
        } else {
            view.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 50);
            view.layer.cornerRadius = 3;
            view.hidden = NO;
            //        __weak typeof(self) weakSelf = self;
            //        view.moreBlock=^{
            //
            ////             weakSelf.hidesBottomBarWhenPushed=YES;
            ////            ZuyuanXinxiViewController *controller=[[ZuyuanXinxiViewController alloc]init];
            ////
            ////            [weakSelf.navigationController pushViewController:controller animated:YES];
            ////           weakSelf.hidesBottomBarWhenPushed=YES;
            //
            //
            //        };
            //        view.searchTextField.delegate=self;
            //        __weak typeof(HeadView *) weakSelfs = view;
            //
            //        view.searchBlock = ^{
            //            [weakSelf textFileSearch:weakSelfs.searchTextField];
            //        };
        }
        return view;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.adminArray.count;
    } else {
        //        if (self.dataArray.count == 0) {
        //            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        //            self.tableView.backgroundView = backgroundImageView;
        //            self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
        //        } else {
        //            self.tableView.backgroundView = nil;
        //        }
        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        if (self.adminArray.count == 0) {
            return 0.01;
        }
        return 50;
    } else {
        if (self.dataArray.count == 0) {
            return 0.01;
        }
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
        if ([self.personnel_management isEqualToString:@"3"]) {
            cell.editBtn.hidden = NO;
            cell.deleteBtn.hidden = NO;
        }else if ([self.personnel_management isEqualToString:@"2"]) {
            cell.editBtn.hidden = YES;
            cell.deleteBtn.hidden = YES;
        }
        
        GroupPeopleModel *model = self.adminArray[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        /// 设置人员信息
        cell.setPeopleBlock = ^(SetTableViewCell *cell) {
            
            weakSelf.hidesBottomBarWhenPushed = YES;
            ZuyuanXinxiViewController *controller = [[ZuyuanXinxiViewController alloc] init];
            controller.group_id = self.group_id;
            controller.list_id = model.list_id;
            controller.phoneStr = model.mobile;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            weakSelf.hidesBottomBarWhenPushed = YES;
            
        };
        //删除
        cell.deleteBlock = ^{
            
            [self deletePeopleWithModel:model];
            
        };
        if (model.group_nickname.length == 0) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.nickname];
        } else {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.nickname, model.group_nickname];
        }
        
        cell.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", model.mobile];
        if ([model.avatar containsString:@"http://"]) {
             [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.avatar]]];
        }else{
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kDomainUrl,model.avatar]]];
        }
       
        //        设置状态 2 异常 其他正常
        if ([model.status isEqualToString:@"2"]) {
            cell.stateBtn.layer.borderColor = UIColorFromRGB(0xFA5458).CGColor;
            [cell.stateBtn.titleLabel setTextColor:UIColorFromRGB(0xFA5458)];
            [cell.stateBtn setTitle:@"异常" forState:UIControlStateNormal];
            cell.layer.cornerRadius = 3;
            cell.stateBtn.layer.borderWidth = 1;
            //
        } else {
            cell.stateBtn.layer.borderColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor;
            [cell.stateBtn.titleLabel setTextColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0]];
            cell.stateBtn.layer.borderWidth = 1;
            cell.layer.cornerRadius = 3;
        }
        
        return cell;
    } else {
        SetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SetTableViewCell" forIndexPath:indexPath];
        if ([self.personnel_management isEqualToString:@"3"]) {
            cell.editBtn.hidden = NO;
            cell.deleteBtn.hidden = NO;
        }else if ([self.personnel_management isEqualToString:@"2"]) {
            cell.editBtn.hidden = YES;
            cell.deleteBtn.hidden = YES;
        }
        
        GroupPeopleModel *model = self.dataArray[indexPath.row];
        
        __weak typeof(self) weakSelf = self;
        /// 设置人员信息
        cell.setPeopleBlock = ^(SetTableViewCell *cell) {
            
            weakSelf.hidesBottomBarWhenPushed = YES;
            ZuyuanXinxiViewController *controller = [[ZuyuanXinxiViewController alloc] init];
            controller.personnel_management = self.personnel_management;
            controller.group_id = self.group_id;
            controller.list_id = model.list_id;
            controller.phoneStr = model.mobile;
            [weakSelf.navigationController pushViewController:controller animated:YES];
            weakSelf.hidesBottomBarWhenPushed = YES;
            
        };
        //删除
        cell.deleteBlock = ^{
            
            [self deletePeopleWithModel:model];
            
        };
        if (model.group_nickname.length == 0) {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@", model.nickname];
        } else {
            cell.nameLabel.text = [NSString stringWithFormat:@"%@(%@)", model.nickname, model.group_nickname];
        }
        cell.phoneNumberLabel.text = [NSString stringWithFormat:@"%@", model.mobile];
        if ([model.avatar containsString:@"http://"]) {
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", model.avatar]]];
        }else{
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kDomainUrl,model.avatar]]];
        }
        if ([model.status isEqualToString:@"2"]) {
            cell.stateBtn.layer.borderColor = UIColorFromRGB(0xFA5458).CGColor;
            [cell.stateBtn.titleLabel setTextColor:UIColorFromRGB(0xFA5458)];
            [cell.stateBtn setTitle:@"异常" forState:UIControlStateNormal];
            cell.layer.cornerRadius = 3;
            cell.stateBtn.layer.borderWidth = 1;
            
        } else {
            cell.stateBtn.layer.borderColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor;
            [cell.stateBtn.titleLabel setTextColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0]];
            cell.layer.cornerRadius = 3;
            cell.stateBtn.layer.borderWidth = 1;
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Function

- (void)initData {
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.resultArray = [NSMutableArray array];
    self.adminArray = [NSMutableArray array];
}

- (void)tapCover:(UITapGestureRecognizer *)recognizer {
    [UIView animateWithDuration:0.3f
                     animations:^{
                         recognizer.view.backgroundColor = [UIColor clearColor];
                         self.erweimaImageView.frame = self.lastFrame;
                         
                     }
                     completion:^(BOOL finished) {
                         [recognizer.view removeFromSuperview];
                         self.erweimaImageView = nil;
                     }];
}
//删除群成员
-(void)deletePeopleWithModel:(GroupPeopleModel *)model{
    
    NSString *message =[NSString stringWithFormat:@"是否删除%@吗？",model.nickname];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action){
                                                             
                                                         }];
    UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是"
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *_Nonnull action) {
                                                           NSDictionary *params = @{
                                                                                    @"group_id":@(self.group_id),
                                                                                    @"del_ids":@(model.user_id)
                                                                                    };
                                                           [DZNetworkingTool postWithUrl:kExitGroup
                                                                                  params:params
                                                                                 success:^(NSURLSessionDataTask *task, id responseObject) {
                                                                                     
                                                                                     if ([responseObject[@"code"] intValue] == SUCCESS) {
                                                                                         [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                                                                         [self.dataArray removeObject:model];
                                                                                         [self refresh];
                                                                                         
                                                                                     } else {
                                                                                         [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                                                                     }
                                                                                 }
                                                                                  failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                                                                      
                                                                                      [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                                                                  }
                                                                               IsNeedHub:NO];
                                                       }];
    
    [alertController addAction:sureAction];
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark -- XibFunction
//结束编辑
- (IBAction)endEdited:(id)sender {
    [self.tableView endEditing:YES];
}
//邀请好友点击事件
- (IBAction)andFriendBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    SetPeopleViewController *vc = [[SetPeopleViewController alloc] init];
    vc.group_id = self.group_id;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//二维码邀请点击事件
- (IBAction)erweimaBtnClick:(id)sender {
    UIImage *image = [UIImage imageNamed:@"WechatIMG25"];
    //添加遮盖
    UIView *cover = [[UIView alloc] initWithFrame:CGRectMake(0, 0,image.size.width, image.size.height)];
    cover.frame = [UIScreen mainScreen].bounds;
    cover.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WechatIMG25"]];
    [cover addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCover:)]];
    [[UIApplication sharedApplication].keyWindow addSubview:cover];
    
    //添加图片到遮盖上
    UIImageView *imageView = [[UIImageView alloc] initWithImage:self.myImage];
    imageView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"WechatIMG25"]];
    imageView.frame = CGRectMake(0, 0, 5, 5);
    
    UIImageView *tempImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"WechatIMG25"]];
    tempImage.size = CGSizeMake( cover.frame.size.width*0.8, cover.frame.size.width * (tempImage.image.size.height / tempImage.image.size.width)*0.6);
    tempImage.centerX = cover.centerX;
    tempImage.centerY = cover.centerY;
    [tempImage addSubview:imageView];
    
    [cover addSubview:tempImage];
    self.erweimaImageView = imageView;
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

//分享按钮点击事件
- (IBAction)shareBtnclick:(id)sender {
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession), @(UMSocialPlatformType_WechatTimeLine), @(UMSocialPlatformType_QQ), @(UMSocialPlatformType_Qzone)]];
    //显示分享面板
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        
        //创建分享消息对象
        UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"装修未来" descr:@"装修你的爱家" thumImage:[UIImage imageNamed:@"AppIcon"]];
        //设置网页地址
        shareObject.webpageUrl =  [NSString stringWithFormat:@"%@?id=%d&token=%@",kShareProject,self.group_id,[User getToken]];
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        //调用分享接口
        [[UMSocialManager defaultManager] shareToPlatform:platformType
                                            messageObject:messageObject
                                    currentViewController:self
                                               completion:^(id data, NSError *error) {
                                                   if (error) {
                                                       NSLog(@"************Share fail with error %@*********", error);
                                                   } else {
                                                       NSLog(@"response data is %@", data);
                                                   }
                                               }];
    }];
}


@end
