//
//  MineViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MineViewController.h"
#import "SettingViewController.h"
#import "MineInfoViewController.h"
#import "MyOrderPageViewController.h"
#import "MyZuJiPageViewController.h"
#import "MyPublishPageViewController.h"
#import "StoreJoinViewController.h"
#import "QuYuDaiLiViewController.h"
#import "WebViewViewController.h"
#import "JiFenStoreViewController.h"
#import "MyQiaoBaoViewController.h"
#import "MyFocusPageViewController.h"
#import "MemberGradeViewController.h"
#import "SGQRCode.h"
#import "WCQRCodeVC.h"

@interface MineViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *erweimaImageView;
@property (nonatomic, strong) IBOutlet UIView *header1View;
@property (weak, nonatomic) IBOutlet UIButton *headerImgV;
@property (weak, nonatomic) IBOutlet UILabel *namePhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *huiYuanBtn;
@property (weak, nonatomic) IBOutlet UILabel *yueeLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *yaoqingmaLabel;
//@property(nonatomic,strong)UIImage *cellImage;
@property (nonatomic, strong) NSArray *functionArray;

@property (nonatomic, strong) UIImage *myImage;

@property (nonatomic, strong) NSString *phoneStr;//电话
@property (nonatomic, strong) NSString *yue;//余额

@property (nonatomic, assign) CGRect lastFrame;
@end

@implementation MineViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if ([DZTools islogin]) {
        [self getUserInfoData];
    } else {
        self.namePhoneLabel.text = @"未登录";
        [self.headerImgV setImage:[UIImage imageNamed:@"home_pic_content6"] forState:UIControlStateNormal];
        self.jifenLabel.text = @"0";
        self.yueeLabel.text = @"0";
        [self.huiYuanBtn setTitle:@"" forState:UIControlStateNormal];
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    _cellImage=[UIImage imageWithData:0];
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
    }

    [self initItem];

    [self initTableView];
}
#pragma mark – UI

- (void)initItem {

    self.navigationItem.title = @"我的";

    self.navigationItem.leftBarButtonItem = nil;

    UIImage *image = [UIImage imageNamed:@"saoyisao"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image1 = [UIImage imageNamed:@"wode_icon_shezhi"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //右边创建2个按钮
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];

    [btn1 setImage:image forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(shaoyisBook) forControlEvents:UIControlEventTouchUpInside];
    [btn2 setImage:image1 forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];

    self.navigationItem.rightBarButtonItems = @[item2, item1];
}
//初始化tableview
- (void)initTableView {
    self.functionArray = @[
        @[@{ @"modelName": @"我的钱包",
             @"modelId": @"101",
             @"modelImage": @"wode_icon_qianbao" }],
        @[@{ @"modelName": @"我的关注",
             @"modelId": @"101",
             @"modelImage": @"wode_icon_guanzhu" },
          @{ @"modelName": @"我的足迹",
             @"modelId": @"102",
             @"modelImage": @"wode_icon_zuji" },
          @{ @"modelName": @"我的发布",
             @"modelId": @"107",
             @"modelImage": @"wode_icon_fabu" },
          @{ @"modelName": @"积分商城",
             @"modelId": @"108",
             @"modelImage": @"wode_icon_shangcheng" }],
        @[@{ @"modelName": @"商家入驻",
             @"modelId": @"101",
             @"modelImage": @"wode_icon_ruzhu" },
          @{ @"modelName": @"区域代理",
             @"modelId": @"108",
             @"modelImage": @"wode_icon_daili" }]
    ];

    _header1View.frame = CGRectMake(0, 0, ViewWidth, 190);
    self.tableView.rowHeight = 50;
    self.tableView.tableHeaderView = _header1View;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        //判断是否登录
        if (![DZTools islogin]) {
            self.namePhoneLabel.text = @"未登录";
            [self.headerImgV setImage:[UIImage imageNamed:@"home_pic_content6"] forState:UIControlStateNormal];
            self.jifenLabel.text = @"0";
            self.yueeLabel.text = @"0";
            [self.huiYuanBtn setTitle:@"" forState:UIControlStateNormal];
            [self.tableView.mj_header endRefreshing];
        } else {
            //加载数据
            [self getUserInfoData];
        }
    }];
}

#pragma mark – Network

- (void)getUserInfoData {
    
    [DZNetworkingTool postWithUrl:kMyIndex
                           params:nil
                          success:^(NSURLSessionDataTask *task, id responseObject) {
      
      if (self.tableView.mj_header.isRefreshing) {
          [self.tableView.mj_header endRefreshing];
      }
      if ([responseObject[@"code"] intValue] == SUCCESS) {
          if ([DZTools islogin]) {
              User *user = [User mj_objectWithKeyValues:responseObject[@"data"]];
              
              [User saveUser:user];
              
              NSDictionary *dict = @{
                                     @"type": @(1),
                                     @"uId": [User getUserID],
                                     @"name": user.username
                                     };
              //自定生成二维码
              UIImage *image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[dict mj_JSONString] imageViewWidth:ViewWidth];
              self.myImage = image;
              
              self.erweimaImageView.image = image;
              self.phoneStr = user.mobile;
              self.namePhoneLabel.text = [NSString stringWithFormat:@"%@", user.nickname];
              [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:[User getUserID] name:user.nickname portrait:user.avatar];
              //设置会员信息
              NSString *level = [NSString stringWithFormat:@"%ld", user.level];
              //                星级 1：普通 2：铜牌 3:银牌 4:金牌 5：钻石
              if ([level isEqualToString:@"1"]) {
                  [self.huiYuanBtn setTitle:@"普通会员" forState:UIControlStateNormal];
              } else if ([level isEqualToString:@"2"]) {
                  [self.huiYuanBtn setTitle:@"铜牌会员" forState:UIControlStateNormal];
              } else if ([level isEqualToString:@"3"]) {
                  [self.huiYuanBtn setTitle:@"银牌会员" forState:UIControlStateNormal];
              } else if ([level isEqualToString:@"4"]) {
                  [self.huiYuanBtn setTitle:@"金牌会员" forState:UIControlStateNormal];
              } else if ([level isEqualToString:@"5"]) {
                  [self.huiYuanBtn setTitle:@"钻石会员" forState:UIControlStateNormal];
              }else if ([level isEqualToString:@"6"]) {
                  [self.huiYuanBtn setTitle:@"超级会员" forState:UIControlStateNormal];
              }
              
              [self.headerImgV sd_setImageWithURL:[NSURL URLWithString:user.avatar] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_pic_content6"]];
              //
              
              self.jifenLabel.text = [NSString stringWithFormat:@"%ld", user.score];
              self.yueeLabel.text = [NSString stringWithFormat:@"¥%@", user.money];
              self.yue=user.money;
              
          } else {
              
              self.namePhoneLabel.text = @"未登录";
              [self.headerImgV setImage:[UIImage imageNamed:@"home_pic_content6"] forState:UIControlStateNormal];
              self.jifenLabel.text = @"0";
              self.yueeLabel.text = @"0";
              [self.huiYuanBtn setTitle:@"" forState:UIControlStateNormal];
          }
      } else {
          [DZTools showNOHud:responseObject[@"msg"] delay:2];
      }
  }
   failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
       //            [DZTools showNOHud:RequestServerError delay:2.0];
   }
IsNeedHub:NO];
    
    [self.tableView.mj_header endRefreshing];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.functionArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.functionArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"mine";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = UIColorFromRGB(0x101010);
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.imageView.image = [UIImage imageNamed:_functionArray[indexPath.section][indexPath.row][@"modelImage"]];
    cell.textLabel.text = _functionArray[indexPath.section][indexPath.row][@"modelName"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
            return;
        }
        self.hidesBottomBarWhenPushed = YES;
        MyQiaoBaoViewController *viewController = [MyQiaoBaoViewController new];
        viewController.money = [User getUser].money;
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } else if (indexPath.section == 1) {
        switch (indexPath.row) {
        case 0: {
            if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
                return;
            }
            self.hidesBottomBarWhenPushed = YES;
            MyFocusPageViewController *viewController = [MyFocusPageViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } break;
        case 1: {
            if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
                return;
            }
            self.hidesBottomBarWhenPushed = YES;
            MyZuJiPageViewController *viewController = [MyZuJiPageViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } break;
        case 2: {
            if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
                return;
            }
            self.hidesBottomBarWhenPushed = YES;
            MyPublishPageViewController *viewController = [MyPublishPageViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } break;
        case 3: {
            self.hidesBottomBarWhenPushed = YES;
            JiFenStoreViewController *viewController = [JiFenStoreViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } break;
        default:
            break;
        }
    } else if (indexPath.section == 2) {
        switch (indexPath.row) {
        case 0: {
            self.hidesBottomBarWhenPushed = YES;
            StoreJoinViewController *viewController = [StoreJoinViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } break;
        case 1: {

            self.hidesBottomBarWhenPushed = YES;
            QuYuDaiLiViewController *viewController = [QuYuDaiLiViewController new];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
        } break;
        default:
            break;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

#pragma mark - Function
- (void)rightBarButtonItemClicked {

    self.hidesBottomBarWhenPushed = YES;
    SettingViewController *viewController = [SettingViewController new];
    viewController.phoneStr = self.phoneStr;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//扫一扫
- (void)shaoyisBook {
    __weak typeof(self) weakSelf = self;
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (device) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        switch (status) {
            case AVAuthorizationStatusNotDetermined: {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                                         completionHandler:^(BOOL granted) {
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
                UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定"
                                                                 style:(UIAlertActionStyleDefault)
                                                               handler:^(UIAlertAction *_Nonnull action){
                                                                   
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
    UIAlertAction *alertA = [UIAlertAction actionWithTitle:@"确定"
                                                     style:(UIAlertActionStyleDefault)
                                                   handler:^(UIAlertAction *_Nonnull action){
                                                       
                                                   }];
    
    [alertC addAction:alertA];
    [weakSelf presentViewController:alertC animated:YES completion:nil];
}

#pragma mark - XibFunction
//复制到剪切板
- (IBAction)copyBtnClicked:(id)sender {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.yaoqingmaLabel.text;
    [DZTools showText:@"复制成功" delay:2];
}
//个人中心
- (IBAction)gerenxinxi:(id)sender {

    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MineInfoViewController *viewController = [MineInfoViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//我的订单
- (IBAction)myOrderBtnClicked:(UIButton *)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MyOrderPageViewController *viewController = [MyOrderPageViewController new];
    viewController.selectIndex = sender.tag - 1;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//二维码
- (IBAction)erweimaBtnClicked:(id)sender {
    
    //跳转到个人信息
    
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MineInfoViewController *viewController = [MineInfoViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
  
}

//余额
- (IBAction)yueBtnClicked:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MyQiaoBaoViewController *viewController = [MyQiaoBaoViewController new];
    viewController.money=self.yue;
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//积分
- (IBAction)jifenBtnClicked:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    JiFenStoreViewController *viewController = [JiFenStoreViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}
//会员
- (IBAction)huiyuanCenterBtnClicked:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }
    self.hidesBottomBarWhenPushed = YES;
    MemberGradeViewController *viewController = [MemberGradeViewController new];
    [self.navigationController pushViewController:viewController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}



@end
