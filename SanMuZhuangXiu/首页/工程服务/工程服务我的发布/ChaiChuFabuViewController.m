//
//  ChaiChuFabuViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/6.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ChaiChuFabuViewController.h"

#import "CollectionViewCell.h"
#import "AddressPickerView.h"

#import "ReLayoutButton.h"
#import "YBPopupMenu.h"
#import "UIButton+Code.h"

//#import "JYBDIDCardVC.h"
#import "FrontViewController.h"
#import "TZImagePickerController.h"
#define Kwidth [UIScreen mainScreen].bounds.size.width
#define Kheight [UIScreen mainScreen].bounds.size.height

@interface ChaiChuFabuViewController () <TZImagePickerControllerDelegate, YBPopupMenuDelegate,AddressPickerViewDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionHeight;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *fuwuBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *titleText;
@property (weak, nonatomic) IBOutlet UITextField *addresstext;
@property (weak, nonatomic) IBOutlet UITextField *biaotiText;
@property (weak, nonatomic) IBOutlet UITextView *beizhuText;
@property (weak, nonatomic) IBOutlet UITextField *yanzhengmaTextField;
@property (weak, nonatomic) IBOutlet UIButton *hqyzBtn;
///选择地址按钮
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressBtn;
///地址pickerView
@property (nonatomic, strong) AddressPickerView *pickerView;

@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeight;

@property (nonatomic, assign) int fuwuListId;

@property (assign, nonatomic) BOOL isSelectOriginalPhoto;

@property (nonatomic, strong) NSMutableArray *assestArray;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property(nonatomic,strong)NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *fuwuArray;
@property (nonatomic, strong) NSMutableArray *addressArray;


@end

@implementation ChaiChuFabuViewController

- (void)viewDidLoad {
    [super viewDidLoad];

  
    if (self.isFromDetail) {
        [self loadDetailData];
    }
    self.fuwuArray = [NSMutableArray array];
    self.array=[NSMutableArray arrayWithCapacity:0];
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量.
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.cornerRadius = 3;

    [self.fuwuBtn setTitle:self.fuwuName forState:UIControlStateNormal];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.itemSize = CGSizeMake((Kwidth - 66) / 4, (Kwidth - 66) / 4);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.collectionView.collectionViewLayout = layout;
    //
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    self.scrollviewHeight.constant = (ViewWidth  - 66) / 3.0 + 555;
}

#pragma mark – Network

-(void)loadDetailData{
    NSDictionary *dict=@{
                         @"id":@(self.lookId)
                         };
    [DZNetworkingTool postWithUrl:kFuwuWorkInfo
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
      if ([responseObject[@"code"] intValue] == SUCCESS) {
          NSDictionary *dict=responseObject[@"data"];
          self.phoneTextField.text=[NSString stringWithFormat:@"%@",dict[@"mobile"]];
          self.titleText.text=[NSString stringWithFormat:@"%@",dict[@"title"]];
          [self.fuwuBtn setTitle:[NSString stringWithFormat:@"%@",dict[@"name"]] forState:UIControlStateNormal];
          self.addressBtn.titleLabel.text=[NSString stringWithFormat:@"%@",dict[@"city"]];
          self.biaotiText.text=[NSString stringWithFormat:@"%@",dict[@"price"]];
          self.beizhuText.text=[NSString stringWithFormat:@"%@",dict[@"note"]];
          [self.array addObjectsFromArray:dict[@"images"]];
          [self.photosArray addObjectsFromArray:dict[@"images"]];
          if (self.photosArray.count>0) {
              [self.collectionView reloadData];
              self.collectionHeight.constant = (ViewWidth - 36 - 66) / 3.0 * self.photosArray.count + self.photosArray.count * 5;
              self.scrollviewHeight.constant = (ViewWidth - 36 - 66) / 3.0 * self.photosArray.count + 555 + self.photosArray.count * 5;
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

#pragma mark – TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    [self.photosArray removeAllObjects];
    [self.assestArray removeAllObjects];
    
    [self.photosArray addObjectsFromArray:photos];
    [self.assestArray addObjectsFromArray:assets];
    _isSelectOriginalPhoto = isSelectOriginalPhoto;
    
    NSInteger num = self.photosArray.count / 3 + 1;
    self.collectionHeight.constant = (ViewWidth  - 66) / 3.0 * num + num * 5;
    self.scrollviewHeight.constant = (ViewWidth  - 66) / 3.0 * num + 555 + num * 5;
    [_collectionView reloadData];
}

#pragma mark – UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == _photosArray.count) {
        [self checkLocalPhoto];
    } else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        __weak typeof(ChaiChuFabuViewController *) weakself = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
          
            [weakself.photosArray removeAllObjects];
            [weakself.assestArray removeAllObjects];
            
            [weakself.photosArray addObjectsFromArray:photos];
            [weakself.assestArray addObjectsFromArray:assets];
            
            weakself.isSelectOriginalPhoto = isSelectOriginalPhoto;
            [weakself.collectionView reloadData];
            NSInteger num = weakself.photosArray.count / 3 + 1;
            self.collectionHeight.constant = (ViewWidth  - 66) / 3.0 * num + num * 5;
            self.scrollviewHeight.constant = (ViewWidth  - 66) / 3.0 * num + 555 + num * 5;
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _photosArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

    if (indexPath.row == _photosArray.count) {
        cell.imagev.image = [UIImage imageNamed:@"add_member"];
        //        cell.imagev.backgroundColor = [UIColor redColor];
        cell.deleteButton.hidden = YES;

    } else {
        if (self.isFromDetail) {
             [cell.imagev sd_setImageWithURL: _photosArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
             cell.deleteButton.hidden = NO;
        }else{
        cell.imagev.image = _photosArray[indexPath.row];
        cell.deleteButton.hidden = NO;
        }
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

#pragma mark - Function

- (void)deletePhotos:(UIButton *)sender {
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    if (self.isFromDetail) {
        [self.array removeObjectAtIndex:sender.tag - 100];
    }
    __weak typeof(ChaiChuFabuViewController *) weakself = self;
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag - 100 inSection:0];
        [weakself.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
        completion:^(BOOL finished) {
            [weakself.collectionView reloadData];
        }];
}

- (void)uploadImages {
    NSMutableArray *temp=[NSMutableArray array];

    if (_photosArray.count == 0) {
        [self uploadInfoWithImg:@""];
        return;
    }
 
    for (int i = 0; i < self.array.count; i++) {
        
        [temp addObject:[_photosArray objectAtIndex:i]];
    }
    if (_assestArray.count>0) {
        NSMutableArray *imageArray = [NSMutableArray array];
        for (NSInteger i = self.array.count; i < self.photosArray.count; i++) {
            [imageArray addObject:self.photosArray[i]];
        }
       
        [DZNetworkingTool uploadWithUrl:kUploadImgURL
                                 params:nil
                               fileData:imageArray
                                   name:@"img[]"
                               fileName:@"file.png"
                               mimeType:@"image/PNG"
                               progress:nil
                                success:^(NSURLSessionDataTask *task, id responseObject) {
                                    if ([responseObject[@"code"] intValue] == SUCCESS) {
                                        NSLog(@"%@", responseObject[@"data"]);
                                        NSArray *array = responseObject[@"data"];
                                        
                                        [temp addObjectsFromArray:array];
                                        NSString * imgstr=[temp componentsJoinedByString:@","];
                                        [self uploadInfoWithImg:imgstr];
                                    } else {
                                        [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                        self.sureBtn.userInteractionEnabled = YES;
                                    }
                                }
                                 failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                     [DZTools showNOHud:RequestServerError delay:2.0];
                                     self.sureBtn.userInteractionEnabled = YES;
                                 }
                              IsNeedHub:NO];
    }else{
        NSString *imgStr=[temp componentsJoinedByString:@","];
        [self uploadInfoWithImg:imgStr];
    }

}
- (void)uploadInfoWithImg:(NSString *)img {
    NSDictionary *dict=@{};
    double latitude = [DZTools getAppDelegate].latitude;
    double longitude = [DZTools getAppDelegate].longitude;
    NSString *url=@"";
    if (self.isFromDetail) {
        url=kEditMyRelease;
        dict = @{
                 
                 @"title": self.titleText.text,
                 @"id":@(self.lookId),
//                 @"engineering_category_id": @(self.fuwuId),
                 @"city": self.addressBtn.titleLabel.text,
                 @"mobile": self.phoneTextField.text,
                 @"price": self.biaotiText.text,
                 @"note": self.beizhuText.text,
                 @"images": img,
                 @"lng":@(longitude),
                 @"lat":@(latitude)
                 
                 };
    }else{
        url=kEnginRecruitMan;
        dict = @{
                 
                 @"title": self.titleText.text,
//                 @"id":@(self.lookId),
                 @"engineering_category_id": @(self.fuwuId),
                 @"city": self.addressBtn.titleLabel.text,
                 @"mobile": self.phoneTextField.text,
                 @"price": self.biaotiText.text,
                 @"note": self.beizhuText.text,
                 @"images": img,
                 @"lng":@(longitude),
                 @"lat":@(latitude)
                 
                 };
    }

    [DZNetworkingTool postWithUrl:url
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                

                if ([responseObject[@"msg"] containsString:@"请先完成实名认证"]) {
                    

                    //弹出框
                    UIAlertController *alert = [UIAlertController
                                                alertControllerWithTitle:@"提示"
                                                message:@"您还没有实名认证，是否现在去实名认证？"
                                                preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction
                                      actionWithTitle:@"是"
                                      style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *_Nonnull action) {
                      //实名认证
                                          
#if TARGET_IPHONE_SIMULATOR
                                          NSLog(@"请用真机");
                                          
#elif TARGET_OS_IPHONE
                  
//                      JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
//                        AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image) {
//                          if (info.name == nil || info.num == nil) {
//                              [[DZTools topViewController].navigationController popViewControllerAnimated:YES];
//                              [DZTools showText:@"请拍摄头像面" delay:2];
//                          } else {
//                              FrontViewController *viewController = [[FrontViewController alloc] init];
//                              viewController.IDInfo = info;
//                              [DZTools topViewController].hidesBottomBarWhenPushed = YES;
//                              [[DZTools topViewController].navigationController pushViewController:viewController animated:YES];
//                          }
//                   
//                      };
//                      self.hidesBottomBarWhenPushed = YES;
 # endif
                          }]];
                    [alert addAction:[UIAlertAction
                                      actionWithTitle:@"否"
                                        style:UIAlertActionStyleDefault
                                      handler:^(UIAlertAction *_Nonnull action) {
                      [self.navigationController popViewControllerAnimated:YES];
                                      }]];
                    //弹出提示框
                    [self presentViewController:alert animated:true completion:nil];
                    
                    
                    
                }else if ([responseObject[@"msg"] containsString:@"实名认证中"]){
                    [DZTools showNOHud:@"实名认证中，不能发布招聘信息" delay:2];
                    
                }else{
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            self.sureBtn.userInteractionEnabled = YES;
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
            self.sureBtn.userInteractionEnabled = YES;
        }
        IsNeedHub:NO];
}
- (void)checkLocalPhoto {
    
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark - AddressPickerViewDelegate
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@", province,city,area] forState:UIControlStateNormal];
    [self.pickerView hide];
}
//取消选中
- (void)cancelBtnClick {
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
#pragma mark – XibFunction

- (IBAction)endEditing:(id)sender {
    
    [self.view endEditing:YES];
}
//地址的选择
- (IBAction)addressBtnClick:(id)sender {
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}
//验证码选择
- (IBAction)hQyzmBtnClick:(id)sender {
    [self.view endEditing:YES];
    if (self.phoneTextField.text.length == 0) {
        [DZTools showNOHud:@"手机号不能为空" delay:2];
        return;
    }
    //电话号码非法验证
    NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTextField.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    
    [sender setCountdown:60 WithStartString:@"" WithEndString:@"获取验证码"];
    NSDictionary *params = @{ @"mobile": self.phoneTextField.text,
                              @"event": @"engineering" };
    [DZNetworkingTool postWithUrl:kGetCodeURL
                           params:params
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}
- (IBAction)sureBtnClick:(id)sender {
    if (self.titleText.text.length == 0) {
        [DZTools showNOHud:@"标题不能为空！" delay:2];
        return;
    }
    
    if ([self.addressBtn.titleLabel.text isEqualToString:@"请选择地区"]) {
        [DZTools showNOHud:@"地方不能为空！" delay:2];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [DZTools showNOHud:@"电话不能为空！" delay:2];
        return;
    }
    //电话号码非法验证
    NSString *regex = @"^((13[0-9])|(14[0-9])|(17[0-9])|(15[^4,\\D])|(18[0-9])|(19[0-9])|(16[0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:self.phoneTextField.text];
    if (!isMatch) {
        
        [DZTools showNOHud:@"手机号格式不正确" delay:2.0];
        return;
    }
    if (self.biaotiText.text.length == 0) {
        [DZTools showNOHud:@"价格不能为空！" delay:2];
        return;
    }
    if (self.beizhuText.text.length == 0) {
        [DZTools showNOHud:@"备注不能为空！" delay:2];
        return;
    }
    self.sureBtn.userInteractionEnabled = NO;
    [self uploadImages];
}
#pragma mark – 懒加载
- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}

- (NSMutableArray *)assestArray {
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}
- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        
    }
    return _pickerView;
}




@end
