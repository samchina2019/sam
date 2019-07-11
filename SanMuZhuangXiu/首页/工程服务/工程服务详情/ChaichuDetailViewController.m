//
//  ChaichuDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ChaichuDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "WXPhotoBrower.h"
#import "MBProgressHUD.h"
#import "MyPingJiaImgCollectionViewCell.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>


static NSString *const imgCellId = @"imgCellId";
@interface ChaichuDetailViewController ()<KNPhotoBrowerDelegate, MBProgressHUDDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *diquLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresslabel;
@property (weak, nonatomic) IBOutlet UILabel *beizhulabel;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;
@property (weak, nonatomic) IBOutlet UILabel *fuwuLabel;
//@property (nonatomic, strong) NSMutableArray *itemsArray;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeight;


@property (nonatomic, strong) WXPhotoBrower *photoBrower;

@property(nonatomic,strong)NSString *phoneStr;
@property(nonatomic,strong)NSString *userId;

@property (strong, nonatomic) NSArray *array;

@end

@implementation ChaichuDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after
    
    self.navigationItem.title=@"详情";
    self.array=[NSArray array];
    //设置周边服务VIew的边框
     self.scrollviewHeight.constant = 400;
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 3;
     [self initCollectionView];

     [self getJianliDetailData];

    
}
- (void)getJianliDetailData {
    
    [DZNetworkingTool postWithUrl:kFuwuWorkInfo
                           params:@{@"id":@(self.fuwuId)}
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict=responseObject[@"data"];
                                  self.phoneStr=[NSString stringWithFormat:@"%@",dict[@"mobile"]];
                                  self.userId=[NSString stringWithFormat:@"%@",dict[@"user_id"]] ;
                                  self.titleLabel.text=[NSString stringWithFormat:@"%@",dict[@"title"]];
                                  self.fuwuLabel.text=[NSString stringWithFormat:@"%@",dict[@"name"]];
                                  self.diquLabel.text=[NSString stringWithFormat:@"%@",dict[@"city"]];
                                  self.priceLabel.text=[NSString stringWithFormat:@"%@",dict[@"price"]];
                                  self.beizhulabel.text=[NSString stringWithFormat:@"%@",dict[@"note"]];
                                  self.array=dict[@"images"];
                                  if (self.array.count>0) {
                                      [self.collectionView reloadData];
                                      self.scrollviewHeight.constant = ceil(((self.array.count - 1) / 3 + 1) * (ViewWidth - 86-36) / 3.0 + 5 * floorf((self.array.count - 1) / 3)) + 380;
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
- (void)initCollectionView {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat width = (ViewWidth - 86-36)/3;
    layout.itemSize = CGSizeMake(width, width);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"MyPingJiaImgCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:imgCellId];
    
}
#pragma mark <UICollectionViewDataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyPingJiaImgCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:self.array[indexPath.row]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath
{
    
}
#pragma mark - UICollectionViewDelegate
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)photoBrowerRightOperationDeleteImageSuccessWithAbsoluteIndex:(NSInteger)index{
    NSLog(@"delete-Absolute:%zd",index);
}

/* PhotoBrower 保存图片是否成功 */
- (void)photoBrowerWriteToSavedPhotosAlbumStatus:(BOOL)success{
    NSLog(@"saveImage:%zd",success);
}

#pragma mark - Function

//在线联系
-(void)chatFuwu{
    NSDictionary *dict=@{
                         @"user_id":self.userId
                         };
    [DZNetworkingTool postWithUrl:kFriendDetails params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue ] ==SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            //            NSString *userId=dict[@"user_id"];
            NSString *headImg=dict[@"avatar"];
            NSString *title=dict[@"nickname"];
            self.phoneStr=dict[@"mobile"];
            //会话列表
            ChatViewController *conversationVC = [[ChatViewController alloc] init];
            conversationVC.hidesBottomBarWhenPushed = YES;
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = [NSString stringWithFormat:@"%@",self.userId ];
            conversationVC.title =title;
            
            RCUserInfo *rcduserinfo_ = [RCUserInfo new];
            rcduserinfo_.name = title;
            rcduserinfo_.userId = self.userId;
            rcduserinfo_.portraitUri = headImg;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcduserinfo_ withUserId:self.userId];
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
    
}

//在线联系
- (IBAction)noLineBtnClick:(id)sender {
    //     使用福利券（修改）
    NSDictionary *dict=@{
                         @"data_type":@(5),
                         @"data_position":@(2),
                         @"data_id":@(self.fuwuId)
                         };
    [DZNetworkingTool postWithUrl:kUseWelfare params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            [self chatFuwu];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];

}

//打电话
- (IBAction)callBtnClick:(id)sender {
//     使用福利券（修改）
    NSDictionary *dict=@{
                         @"data_type":@(5),
                         @"data_position":@(2),
                         @"data_id":@(self.fuwuId)
                         };
    [DZNetworkingTool postWithUrl:kUseWelfare params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneStr];
            UIWebView * callWebview = [[UIWebView alloc] init];
            [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];[self.view addSubview:callWebview];
        }else{
             [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
         [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];

}
//关注
- (IBAction)guanzhuBtnClick:(id)sender {
    NSDictionary *dict=@{
                         @"type":@(5),
                         @"id":@(self.fuwuId)
                         };
    [DZNetworkingTool postWithUrl:kAddServerFollow params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue]==SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            if ([self.guanzhuBtn.titleLabel.text containsString:@"已关注"]) {
                [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
            }else{
                [self.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
            }
            [self.view layoutIfNeeded];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}

@end
