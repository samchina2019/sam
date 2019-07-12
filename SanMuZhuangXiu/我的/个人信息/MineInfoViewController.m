//
//  MineInfoViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/27.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "MineInfoViewController.h"
#import "MineInfoIconCell.h"

#import "JYBDIDCardVC.h"
#import "FrontViewController.h"
#import "ReverseViewController.h"
#import "AddressManagerViewController.h"
#import "GongZhangRenZhengViewController.h"
#import "QiYeRenZhengViewController.h"
#import "FaPianInfoViewController.h"
#import "TZImagePickerController.h"
#import "MemberGradeViewController.h"
#import "SGQRCode.h"
#import "ChangePhoneViewController.h"

@interface MineInfoViewController () <UITableViewDelegate, UITableViewDataSource, TZImagePickerControllerDelegate>
@property (nonatomic, assign) BOOL isUploadpImg;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSArray *photoUrlArray;
@property (nonatomic, strong) NSString *nameStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, strong) UIImage *myImage;
@property (nonatomic, strong) UIImageView *erweimaImageView;
///设置rframe
@property (nonatomic, assign) CGRect lastFrame;
///是否已实名认证:0=未认证,1=申请中,2=已通过
@property (nonatomic, assign) int is_auth_true;
///是否已企业认证:0=未认证,1=申请中,2=已通过
@property (nonatomic, assign) int is_auth_business;
///是否已工长认证:0=未申请,1=申请中,2=已通过
@property (nonatomic, assign) int is_auth_foreman;
@end

@implementation MineInfoViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //是否实名认证
     [self loadShinming];
    //企业认证是否通过
     [self loadShinmingBusiness];
    //工长认证
    [self gongzhangrenzheng];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"个人信息";

    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    [self loadBasicData];
    self.photosArray = [NSMutableArray array];
    self.photoUrlArray = [NSArray array];

}

#pragma mark – Network
-(void)gongzhangrenzheng{
    [DZNetworkingTool postWithUrl:kMyForemanAuth params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            if ([dict[@"is_auth_foreman"] intValue] == 0) {
                self.is_auth_foreman = 0;
            }else if ([dict[@"is_auth_foreman"] intValue] == 1){
               self.is_auth_foreman = 1;
            }else if ([dict[@"is_auth_foreman"] intValue] == 2){
              self.is_auth_foreman = 2;
            }
            [self.tableView reloadData];
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
-(void)loadShinmingBusiness{

    [DZNetworkingTool postWithUrl:kQiyeCheckIdauth params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            if ([responseObject[@"data"] intValue] == 0) {
                self.is_auth_business = 0;
            }else  if ([responseObject[@"data"] intValue] == 1) {
                self.is_auth_business = 1;
            }else   if ([responseObject[@"data"] intValue] == 2) {
                self.is_auth_business = 2;
            }
             [self.tableView reloadData];
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
-(void)loadShinming{
    //kShimingCheckIdauth
    [DZNetworkingTool postWithUrl:kShimingCheckIdauth params:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            if ([responseObject[@"data"][@"is_auth_true"] intValue] == 0) {
                self.is_auth_true = 0;
            }else  if ([responseObject[@"data"][@"is_auth_true"] intValue] == 1){
                self.is_auth_true = 1;
            }else  if ([responseObject[@"data"][@"is_auth_true"] intValue] == 2){
                self.is_auth_true = 2;
            }
             [self.tableView reloadData];
        }else{
              [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
          [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
//加载我的信息
- (void)loadBasicData {
    [DZNetworkingTool postWithUrl:kMyIndex
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                User *user = [User mj_objectWithKeyValues:responseObject[@"data"]];

                self.nameStr = user.nickname;
                self.iconStr = user.avatar;
                [self.tableView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        static NSString *cellIdentifier1 = @"info1";
        MineInfoIconCell *cell1 = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
        if (cell1 == nil) {
            cell1 = [[MineInfoIconCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier1];
        }
        cell1.textLabel.textColor = UIColorFromRGB(0x101010);
        cell1.textLabel.font = [UIFont systemFontOfSize:15];
        cell1.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //头像
        [cell1.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.iconStr]];

        __weak typeof(MineInfoIconCell *) weakself = cell1;
        cell1.btnBlock = ^{
            //设置头像
            TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
            imagePickerVc.allowPickingVideo = NO;
            [self.photosArray removeAllObjects];
            [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

                [self.photosArray addObjectsFromArray:photos];
                [self loadImage];

            }];
            [self presentViewController:imagePickerVc animated:YES completion:nil];
            [weakself.iconImageView sd_setImageWithURL:[NSURL URLWithString:self.iconStr]];
            [self.tableView reloadData];
        };
        cell1.textLabel.text = @"头像";
        return cell1;
    }

    static NSString *cellIdentifier = @"info2";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.textColor = UIColorFromRGB(0x101010);
    cell.detailTextLabel.textColor = UIColorFromRGB(0x999999);
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    switch (indexPath.row) {
    case 1:
        {
        cell.textLabel.text = @"手机号";
        cell.detailTextLabel.text = [User getUser].mobile;
        }
        break;
    case 2:
        {
        cell.textLabel.text = @"昵称";
        cell.detailTextLabel.text = self.nameStr;
        }
        break;
    case 3:
        {
        cell.textLabel.text = @"我的二维码";
        }
        break;
    case 4:
        cell.textLabel.text = @"会员管理";
        break;
    case 5:
        cell.textLabel.text = @"地址管理";
        break;
    case 6:
        {
        cell.textLabel.text = @"实名认证";
            NSString *name = @"";
            if (self.is_auth_true ==0 ) {
                name = @"未认证";
                cell.detailTextLabel.textColor = [UIColor redColor];
            }else if (self.is_auth_true == 1){
                 cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                 name = @"申请中";
            }else if (self.is_auth_true == 2){
                name = @"已通过";
                cell.detailTextLabel.textColor = UIColorFromRGB(0x333333);
            }
        cell.detailTextLabel.text = name;
        }
        break;
    case 7:
        {
        cell.textLabel.text = @"企业认证";
            NSString *name = @"";
            if (self.is_auth_business ==0 ) {
                cell.detailTextLabel.textColor = [UIColor redColor];
                name = @"未认证";
            }else if (self.is_auth_business == 1){
                 cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                name = @"申请中";
            }else if (self.is_auth_business == 2){
                name = @"已通过";
                 cell.detailTextLabel.textColor = UIColorFromRGB(0x333333);
            }
            cell.detailTextLabel.text = name;
        }
        break;
    case 8:
        {
        cell.textLabel.text = @"工长认证";
            NSString *name = @"";
            if (self.is_auth_foreman ==0 ) {
                cell.detailTextLabel.textColor = [UIColor redColor];
                name = @"未认证";
            }else if (self.is_auth_foreman == 1){
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
                name = @"申请中";
            }else if (self.is_auth_foreman == 2){
                cell.detailTextLabel.textColor = UIColorFromRGB(0x333333);
                name = @"已通过";
            }
            cell.detailTextLabel.text = name;
        }
        break;
    case 9:
        cell.textLabel.text = @"发票信息管理";
        break;
   
}
    return cell;
}

#pragma mark UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
    case 1: {
        ChangePhoneViewController *viewController = [ChangePhoneViewController new];
        self.hidesBottomBarWhenPushed = YES;
        viewController.block = ^{
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:viewController animated:YES];
    }
            break;
    case 2: {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"修改昵称" preferredStyle:UIAlertControllerStyleAlert];
        //定义第一个输入框；
        [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.placeholder = @"请输入昵称";
        }];
        //增加取消按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action){

                                                          }]];
        //增加确定按钮；
        [alertController addAction:[UIAlertAction actionWithTitle:@"确定"
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction *_Nonnull action) {
          //获取第1个输入框；
          UITextField *textField = alertController.textFields.firstObject;
          NSString *str = textField.text;
          str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
          ;
          if (str.length > 0) {
              NSDictionary *dict = @{ @"nickname": textField.text };
              [DZNetworkingTool postWithUrl:kEditUser
                  params:dict
                  success:^(NSURLSessionDataTask *task, id responseObject) {
                      if ([responseObject[@"code"] intValue] == SUCCESS) {
                          [DZTools showOKHud:responseObject[@"msg"] delay:2];
                          self.nameStr = textField.text;
                          [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                      } else {
                          [DZTools showNOHud:responseObject[@"msg"] delay:2];
                      }
                  }
                  failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                      [DZTools showNOHud:responseObject[@"msg"] delay:2];
                  }
                  IsNeedHub:NO];
          } else {
              [DZTools showNOHud:@"昵称不能为空" delay:2];
          }
      }]];
        [self presentViewController:alertController animated:true completion:nil];
    }
            break;
    case 3: {
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
            break;
    case 4: {
        MemberGradeViewController *viewController = [MemberGradeViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
            break;
    case 5: {
        AddressManagerViewController *viewController = [AddressManagerViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
            break;
    case 6: {
        JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];

        AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image) {
            if (info.name == nil || info.num == nil) {
                [[DZTools topViewController].navigationController popViewControllerAnimated:YES];
                [DZTools showText:@"请拍摄头像面" delay:2];
            } else {
                FrontViewController *viewController = [[FrontViewController alloc] init];
                viewController.IDInfo = info;
                [DZTools topViewController].hidesBottomBarWhenPushed = YES;
                [[DZTools topViewController].navigationController pushViewController:viewController animated:YES];
            }
        };
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:AVCaptureVC animated:YES];
    }
            break;
    case 7: {
        QiYeRenZhengViewController *viewController = [QiYeRenZhengViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
            break;
    case 8: {
        GongZhangRenZhengViewController *viewController = [GongZhangRenZhengViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
            break;
    case 9: {
        FaPianInfoViewController *viewController = [FaPianInfoViewController new];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewController animated:YES];
    }
            break;
   
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
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
- (void)loadImage {
    self.isUploadpImg = NO;
    if (self.photosArray.count == 0) {
        self.photoUrlArray = @[];
        self.isUploadpImg = YES;
    } else {

        [DZNetworkingTool uploadWithUrl:kUploadImgURL
            params:nil
            fileData:self.photosArray
            name:@"img[]"
            fileName:@"file.png"
            mimeType:@"image/PNG"
            progress:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSLog(@"%@", responseObject[@"data"]);
                    self.isUploadpImg = YES;
                    self.photoUrlArray = responseObject[@"data"];
                    self.iconStr = self.photoUrlArray[0];
                    [self.tableView reloadData];
                    [self updateImage];
                }

            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            }
            IsNeedHub:NO];
    }
}
- (void)updateImage {
    //    kEditUser
    NSDictionary *dict = @{ @"avatar": self.photoUrlArray[0] };
    [DZNetworkingTool postWithUrl:kEditUser
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

#pragma mark – 懒加载
- (UIImage *)myImage {
    if (!_myImage) {
        NSDictionary *dict = @{
                               @"type": @(1),
                               @"uId": [User getUserID],
                               @"name": [User getUser].username
                               };
          UIImage *tempImage = [UIImage imageNamed:@"WechatIMG25"];
        //自定生成二维码
        UIImage *image = [SGQRCodeGenerateManager generateWithDefaultQRCodeData:[dict mj_JSONString] imageViewWidth:tempImage.size.width];
        
        
        self.myImage = image;
        
    }
    return _myImage;
}
@end
