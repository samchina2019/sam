//
//  FindDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/4.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FindDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WXPhotoBrower.h"
#import "MBProgressHUD.h"
#import "MyPingJiaImgCollectionViewCell.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>

static NSString *const imgCellId = @"imgCellId";

@interface FindDetailViewController () <KNPhotoBrowerDelegate, MBProgressHUDDelegate, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
//地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//结账周期
@property (weak, nonatomic) IBOutlet UILabel *jiezhangLabel;
//是否提供住宿
@property (weak, nonatomic) IBOutlet UILabel *zhusuLabel;
//工时要求
@property (weak, nonatomic) IBOutlet UILabel *gongshiLabel;
//上岗时间
@property (weak, nonatomic) IBOutlet UILabel *shanggangDateLabel;
//期望薪资
@property (weak, nonatomic) IBOutlet UILabel *xinziLabel;
//工作经验
@property (weak, nonatomic) IBOutlet UILabel *jingyanLabel;
//电话号码
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
//籍贯
@property (weak, nonatomic) IBOutlet UILabel *jiguanLabel;
//擅长类型
@property (weak, nonatomic) IBOutlet UILabel *shanchangLabel;
//工种
@property (weak, nonatomic) IBOutlet UILabel *gongzhongLabel;
//年龄
@property (weak, nonatomic) IBOutlet UILabel *ageLabel;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;
///姓名
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
///头像
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) NSMutableArray *itemsArray;
@property (strong, nonatomic) NSArray *array;

@property (nonatomic, strong) NSDictionary *dataDict;

@property (nonatomic, strong) WXPhotoBrower *photoBrower;
///用户ID
@property (nonatomic, strong) NSString *userId;
///电话
@property (nonatomic, strong) NSString *phoneStr;
@end

@implementation FindDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"求职者详情";

    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);

    self.scrollViewHeight.constant = 570;

    [self initCollectionView];

    [self getJianliDetailData];
}
#pragma mark – UI
- (void)initCollectionView {

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ViewWidth - 52) / 3;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyPingJiaImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imgCellId];
}

#pragma mark – Network
//
- (void)getJianliDetailData {
    [DZNetworkingTool postWithUrl:kjianliDetail
        params:@{ @"id": @(self.jianliID) }
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.dataDict = responseObject[@"data"];

                self.userId = [NSString stringWithFormat:@"%@", self.dataDict[@"user_id"]];
                self.phoneStr = [NSString stringWithFormat:@"%@", self.dataDict[@"telephone"]];

                if ([self.dataDict[@"is_follow"] intValue] == 1) {
                    [self.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
                } else {
                    [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                }
                [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.dataDict[@"avatar"]] placeholderImage:[UIImage imageNamed:@"img_head"]];
                self.nameLabel.text = self.dataDict[@"username"];
                self.sexLabel.text = self.dataDict[@"gender"];
                self.ageLabel.text = [NSString stringWithFormat:@"%@岁", self.dataDict[@"age"]];
                self.jiguanLabel.text = self.dataDict[@"work_address"];
                self.phoneNumberLabel.text = self.dataDict[@"mobile1"];
                self.jingyanLabel.text = [NSString stringWithFormat:@"%@工作经验", self.dataDict[@"work_year"]];
                self.xinziLabel.text = [NSString stringWithFormat:@"%@/天", self.dataDict[@"salary"]];
                self.gongzhongLabel.text = self.dataDict[@"name"];
                self.shanchangLabel.text = self.dataDict[@"speciality"];
                self.shanggangDateLabel.text = self.dataDict[@"construction_time"];
                if ([self.dataDict[@"salary_money"] intValue] == 10) {
                    self.gongshiLabel.text = @"日工";
                } else if ([self.dataDict[@"salary_money"] intValue] == 20) {
                    self.gongshiLabel.text = @"包工";
                } else {
                    self.gongshiLabel.text = @"均可";
                }
                if ([self.dataDict[@"putup"] intValue] == 10) {
                    self.zhusuLabel.text = @"提供";
                } else {
                    self.zhusuLabel.text = @"不提供";
                }
                if ([self.dataDict[@"advance"] intValue] == 10) {
                    self.jiezhangLabel.text = [NSString stringWithFormat:@"%@   中途可预支", self.dataDict[@"settlement_time"]];
                } else {
                    self.jiezhangLabel.text = [NSString stringWithFormat:@"%@   中途不可预支", self.dataDict[@"settlement_time"]];
                }
                self.addressLabel.text = @"";
                self.array = self.dataDict[@"images"];
                if (self.array.count > 0) {
                    [self.collectionView reloadData];
                    self.scrollViewHeight.constant = ceil(((self.array.count - 1) / 3 + 1) * (ViewWidth - 52) / 3.0 + 5 * floorf((self.array.count - 1) / 3)) + 620;
                }
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    MyPingJiaImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
}
#pragma mark - UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    WXPhotoBrower *photoBrower = [[WXPhotoBrower alloc] init];
    photoBrower.dataSourceUrlArr = self.array;
    photoBrower.currentIndex = indexPath.row;

    [photoBrower setIsNeedRightTopBtn:NO];      // 是否需要 右上角 操作功能按钮
    [photoBrower setIsNeedPictureLongPress:NO]; // 是否 需要 长按图片 弹出框功能 .默认:需要
    [photoBrower setIsNeedPageControl:YES];     // 是否需要 底部 UIPageControl, Default is NO

    [photoBrower present];
    _photoBrower = photoBrower;

    // 设置代理方法 --->可不写
    [photoBrower setDelegate:self];
}

#pragma mark - Delegate

/* PhotoBrower 即将消失 */
- (void)photoBrowerWillDismiss {
    NSLog(@"Will Dismiss");
    //    _ApplicationStatusIsHidden = NO;
    [self setNeedsStatusBarAppearanceUpdate];
}

/* PhotoBrower 右上角按钮的点击 */
- (void)photoBrowerRightOperationActionWithIndex:(NSInteger)index {
    NSLog(@"operation:%zd", index);
}

/**
 *  删除当前图片
 *
 *  @param index 相对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithRelativeIndex:(NSInteger)index {
    NSLog(@"delete-Relative:%zd", index);
}

/**
 *  删除当前图片
 *
 *  @param index 绝对 下标
 */
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index {
    NSLog(@"delete-Absolute:%zd", index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success {
    NSLog(@"saveImage:%zd", success);
}

#pragma mark - Function
//在线联系
-(void)onlineSure{
    NSDictionary *dict = @{
                           @"user_id": self.userId
                           };
    [DZNetworkingTool postWithUrl:kFriendDetails
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
          if ([responseObject[@"code"] intValue] == SUCCESS) {
              NSDictionary *dict = responseObject[@"data"];
              //            NSString *userId=dict[@"user_id"];
              NSString *headImg = dict[@"avatar"];
              NSString *title = dict[@"nickname"];
              self.phoneStr = dict[@"mobile"];
              //会话列表
              ChatViewController *conversationVC = [[ChatViewController alloc] init];
              conversationVC.hidesBottomBarWhenPushed = YES;
              conversationVC.conversationType = ConversationType_PRIVATE;
              conversationVC.targetId = [NSString stringWithFormat:@"%@", self.userId];
              conversationVC.title = title;
              
              RCUserInfo *rcduserinfo_ = [RCUserInfo new];
              rcduserinfo_.name = title;
              rcduserinfo_.userId = self.userId;
              rcduserinfo_.portraitUri = headImg;
              [[RCIM sharedRCIM] refreshUserInfoCache:rcduserinfo_ withUserId:self.userId];
              
              [self.navigationController pushViewController:conversationVC animated:YES];
              
          } else {
              [DZTools showNOHud:responseObject[@"msg"] delay:2];
          }
      }
       failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
           [DZTools showNOHud:responseObject[@"msg"] delay:2];
       }
    IsNeedHub:NO];
}

#pragma mark – XibFunction

//关注事件
- (IBAction)guanzhuBtn:(id)sender {
    NSDictionary *dict = @{
        @"type": @(2),
        @"id": @(self.jianliID)
    };
    [DZNetworkingTool postWithUrl:kAddServerFollow
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            if ([self.guanzhuBtn.titleLabel.text containsString:@"已关注"]) {
                [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            }else{
                [self.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
            [self.view layoutIfNeeded];
            
        } else {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }

    }
    failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    }
    IsNeedHub:NO];
}
//在线联系事件
- (IBAction)onlineBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要消耗100积分\n进入在线联系页面" preferredStyle:UIAlertControllerStyleAlert];
    
    
    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] range:NSMakeRange(0, 2)];
    [alert setValue:title forKey:@"attributedTitle"];
    
    // 使用富文本来改变alert的message字体大小和颜色
    // NSMakeRange(0, 14) 代表:从0位置开始 14个字符
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"需要消耗100积分\n进入在线联系页面"];
    
    [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 18)];
    
    [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:250/255.0 green:84/255.0 blue:88/255.0 alpha:1.0] range:NSMakeRange(4, 3)];
    
    [alert setValue:message forKey:@"attributedMessage"];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self   onlineSure];
    }];
    
    
    //    // 设置按钮的title颜色
    [cancelAction setValue:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    //
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 设置按钮的title颜色
    [okAction setValue:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [okAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}

//打电话事件
- (IBAction)callBtnClick:(id)sender {
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneStr];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
#pragma mark – 懒加载
- (NSMutableArray *)itemsArray {
    if (!_itemsArray) {
        _itemsArray = [NSMutableArray array];
    }
    return _itemsArray;
}

@end
