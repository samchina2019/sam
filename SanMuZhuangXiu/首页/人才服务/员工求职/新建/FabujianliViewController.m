//
//  FabujianliViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FabujianliViewController.h"
#import "CollectionViewCell.h"
#import "TZImagePickerController.h"
#import "ReLayoutButton.h"
#import "WSDatePickerView.h"
#import "AddressPickerView.h"

//#import "JYBDIDCardVC.h"
#import "FrontViewController.h"

@interface FabujianliViewController () <TZImagePickerControllerDelegate, AddressPickerViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
//姓名
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//工龄
@property (weak, nonatomic) IBOutlet UITextField *gonglingtextField;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jingyanBtn;
//籍贯
@property (weak, nonatomic) IBOutlet UITextField *jiguanTextField;
//薪资要求
@property (weak, nonatomic) IBOutlet UITextField *xinziTextField;
@property (weak, nonatomic) IBOutlet ReLayoutButton *xinziBtn;
//工作区域
@property (weak, nonatomic) IBOutlet UITextField *quyuTextField;
@property (weak, nonatomic) IBOutlet ReLayoutButton *quyuBtn;
//联系电话
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
//岗位要求
@property (weak, nonatomic) IBOutlet ReLayoutButton *gangweiBtn;
//学历
@property (weak, nonatomic) IBOutlet UITextField *xueliTextField;
@property (weak, nonatomic) IBOutlet ReLayoutButton *xueliBtn;
//上岗时间
@property (weak, nonatomic) IBOutlet ReLayoutButton *shanggangDateBtn;
//是
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
//提交
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
//籍贯
@property (weak, nonatomic) IBOutlet ReLayoutButton *jiguanBtn;
//上传图片

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
///性别
@property (weak, nonatomic) IBOutlet ReLayoutButton *sexButton;
//否
@property (weak, nonatomic) IBOutlet UIButton *noBtn;
///年龄
@property (weak, nonatomic) IBOutlet UITextField *ageTextField;

@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, strong) NSMutableArray *sexArray;
@property (nonatomic, strong) NSArray *xinziArray;
@property (nonatomic, strong) NSMutableArray *gangweiArray;
@property (nonatomic, strong) NSArray *xueliArray;
@property (nonatomic, strong) NSArray *jingyanArray;
@property (nonatomic, strong) NSArray *jiguanArray;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *assestArray;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSMutableArray *selectPhotosArray;
@property (nonatomic, strong) NSMutableArray *constructionTimeArray;

@property (nonatomic, strong) AddressPickerView *pickerView;
/////性别 0男  1女
//@property (nonatomic, assign) NSInteger sexIndex;

@property (assign, nonatomic) BOOL isSelectOriginalPhoto;
@end

@implementation FabujianliViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    [self getGangweiData];
    [self loadShanggangTimeData];

    if (self.isEdit) {
        [self loadDetailData];
        self.navigationItem.title = @"编辑";
    } else {
        self.navigationItem.title = @"我的简历";
    }
    [self initBasicView];
    [self initData];
}
#pragma mark – UI

- (void)initBasicView {
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
    self.bgView.layer.cornerRadius = 3;

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.itemSize = CGSizeMake((self.collectionView.bounds.size.width - 24) / 3 - 1, (self.collectionView.bounds.size.width - 24) / 3 - 1 );
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);

    self.collectionView.collectionViewLayout = layout;
    //
    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"cell"];

    self.scrollViewHeight.constant = (ViewWidth - 141 - 24) / 3.0 + 490 + 90;
}
#pragma mark – Network
- (void)loadShanggangTimeData {

    [DZNetworkingTool postWithUrl:kArrayRecruit
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                [self.constructionTimeArray removeAllObjects];

                self.jiguanArray = dict[@"native_place"];
                [self.constructionTimeArray addObjectsFromArray:dict[@"construction_time"]];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//详情信息
- (void)loadDetailData {
    [DZNetworkingTool postWithUrl:kQiuziJobInfo
        params:@{ @"id": @(self.fabuId) }
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                self.nameTextField.text = [NSString stringWithFormat:@"%@", dict[@"username"]];
                //                                  self.gonglingtextField.text=[NSString stringWithFormat:@"%@",dict[@"work_year"]];
                [self.jingyanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"work_year"]] forState:UIControlStateNormal];

                //                                  self.jiguanTextField.text=[NSString stringWithFormat:@"%@",dict[@""]];
                //                                  self.xinziTextField.text=[NSString stringWithFormat:@"%@",dict[@"salary"]];
                [self.xinziBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"salary"]] forState:UIControlStateNormal];
                [self.sexButton setTitle:[NSString stringWithFormat:@"%@", dict[@"gender"]] forState:UIControlStateNormal];
                self.ageTextField.text = [NSString stringWithFormat:@"%@岁",dict[@"age"]];

                //                                  self.quyuTextField.text=[NSString stringWithFormat:@"%@",dict[@"work_address"]];
                [self.quyuBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"work_address"]] forState:UIControlStateNormal];
                self.phoneTextField.text = [NSString stringWithFormat:@"%@", dict[@"telephone"]];
                [self.gangweiBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"recruitment_post"]] forState:UIControlStateNormal];
                //                                  self.xueliTextField.text=[NSString stringWithFormat:@"%@",dict[@""]];
                [self.xueliBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"education"]] forState:UIControlStateNormal];
                [self.jiguanBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"native_place"]] forState:UIControlStateNormal];

                if ([dict[@"putup"] intValue] == 10) {
                    self.sureBtn.selected = YES;
                    self.noBtn.selected = NO;
                } else if ([dict[@"putup"] intValue] == 20) {
                    self.sureBtn.selected = NO;
                    self.noBtn.selected = YES;
                }
                [self.shanggangDateBtn setTitle:[NSString stringWithFormat:@"%@", dict[@"construction_time"]] forState:UIControlStateNormal];

                [self.array addObjectsFromArray:dict[@"images"]];
                [self.photosArray addObjectsFromArray:self.array];
                NSLog(@"-----%@", self.array);
                if (self.photosArray.count > 0) {

                    NSInteger num = self.photosArray.count / 3 + 1;
                    self.scrollViewHeight.constant = (ViewWidth - 141 - 24) / 3.0 * num + 490 + num * 5 + 90;
                }
                [self.collectionView reloadData];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)getGangweiData {
    [DZNetworkingTool postWithUrl:kGetGangweiData
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                self.gangweiArray = responseObject[@"data"];
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
    self.scrollViewHeight.constant = (ViewWidth - 141 - 24) / 3.0 * num + 490 + num * 5 + 90;
    [_collectionView reloadData];
}

#pragma mark – UICollectionViewDelegate

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
        if (self.isEdit) {
            [cell.imagev sd_setImageWithURL:_photosArray[indexPath.row] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
        } else {
            cell.imagev.image = _photosArray[indexPath.row];
        }
        cell.deleteButton.hidden = NO;
    }
    cell.deleteButton.tag = 100 + indexPath.row;
    [cell.deleteButton addTarget:self action:@selector(deletePhotos:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == _photosArray.count) {
        [self checkLocalPhoto];
    } else {
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithSelectedAssets:_assestArray selectedPhotos:_photosArray index:indexPath.row];
        imagePickerVc.isSelectOriginalPhoto = _isSelectOriginalPhoto;
        __weak typeof(FabujianliViewController *) weakself = self;
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
            [weakself.photosArray removeAllObjects];
            [weakself.assestArray removeAllObjects];
            
            [weakself.photosArray addObjectsFromArray:photos];
            [weakself.assestArray addObjectsFromArray:assets];
            weakself.isSelectOriginalPhoto = isSelectOriginalPhoto;
            NSInteger num = weakself.photosArray.count / 3 + 1;
            self.scrollViewHeight.constant = (ViewWidth - 141 - 24) / 3.0 * num + 490 + num * 5 +90;
            [weakself.collectionView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];
    }
}

#pragma mark - AddressPickerViewDelegate
- (void)sureBtnClickReturnProvince:(NSString *)province City:(NSString *)city Area:(NSString *)area {
    [self.quyuBtn setTitle:[NSString stringWithFormat:@"%@%@%@", province, city, area] forState:UIControlStateNormal];
    [self.pickerView hide];
}
#pragma mark - Function
- (void)checkLocalPhoto {

    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:3 delegate:self];
    [imagePicker setSortAscendingByModificationDate:NO];
    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    imagePicker.selectedAssets = _assestArray;
    imagePicker.allowPickingVideo = NO;
    [self presentViewController:imagePicker animated:YES completion:nil];
}
- (void)deletePhotos:(UIButton *)sender {
    if (self.isEdit) {
        [self.array removeObjectAtIndex:sender.tag - 100];
    }
    [_photosArray removeObjectAtIndex:sender.tag - 100];
    [_assestArray removeObjectAtIndex:sender.tag - 100];
    __weak typeof(FabujianliViewController *) weakself = self;
    [_collectionView performBatchUpdates:^{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag - 100 inSection:0];
        [weakself.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
        completion:^(BOOL finished) {
            [weakself.collectionView reloadData];
        }];
}

- (void)alertGangweiClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.gangweiArray.count) {
        [self.gangweiBtn setTitle:self.gangweiArray[rowInteger] forState:UIControlStateNormal];
        self.gangweiBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//上传图片
- (void)uploadImages {
    NSMutableArray *temp = [NSMutableArray array];
    if (_photosArray.count == 0) {
        [self uploadInfoWithImg:@""];
        return;
    }
    for (int i = 0; i < self.array.count; i++) {

        [temp addObject:[_photosArray objectAtIndex:i]];
    }

    if (_assestArray.count > 0) {
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
                    NSString *imgstr = [temp componentsJoinedByString:@","];
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
    } else {
        NSString *imgStr = [temp componentsJoinedByString:@","];
        [self uploadInfoWithImg:imgStr];
    }
}
//上传信息
- (void)uploadInfoWithImg:(NSString *)img {
    if (self.nameTextField.text.length == 0) {
        [DZTools showNOHud:@"姓名不能为空" delay:2];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [DZTools showNOHud:@"姓名不能为空" delay:2];
        return;
    }
    if (self.ageTextField.text.length == 0) {
        [DZTools showNOHud:@"年龄不能为空" delay:2];
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
    NSDictionary *dict = @{ @"realName": self.nameTextField.text,
                            @"work_year": self.jingyanBtn.titleLabel.text,
                            @"native_place": self.jiguanBtn.titleLabel.text,
                            @"salary": self.xinziBtn.titleLabel.text,
                            @"work_address": self.quyuBtn.titleLabel.text,
                            @"recruitment_post": self.gangweiBtn.titleLabel.text,
                            @"education": self.xueliBtn.titleLabel.text,
                            @"putup": self.sureBtn.selected ? @"10" : @"20",
                            @"construction_time": self.shanggangDateBtn.titleLabel.text,
                            @"telephone": self.phoneTextField.text,
                            @"longitude": @([DZTools getAppDelegate].longitude),
                            @"latitude": @([DZTools getAppDelegate].latitude),
                            @"images": img,
                            @"age":self.ageTextField.text,
                            @"gender":self.sexButton.titleLabel.text
                            
                            };
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:dict];
    if (self.isEdit) {
        [params setValue:@(self.fabuId) forKey:@"id"];
    }
    [DZNetworkingTool postWithUrl:self.isEdit ? kQZFaBuEdit : kQZFaBu
        params:params
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
//                                                     JYBDIDCardVC *AVCaptureVC = [[JYBDIDCardVC alloc] init];
//
//                                                     AVCaptureVC.finish = ^(JYBDCardIDInfo *info, UIImage *image) {
//                                                         if (info.name == nil || info.num == nil) {
//                                                             [[DZTools topViewController].navigationController popViewControllerAnimated:YES];
//                                                             [DZTools showText:@"请拍摄头像面" delay:2];
//                                                         } else {
//                                                             FrontViewController *viewController = [[FrontViewController alloc] init];
//                                                             viewController.IDInfo = info;
//                                                             [DZTools topViewController].hidesBottomBarWhenPushed = YES;
//                                                             [[DZTools topViewController].navigationController pushViewController:viewController animated:YES];
//                                                         }
//                                                     };
//                                                     self.hidesBottomBarWhenPushed = YES;
//                                                     [self.navigationController pushViewController:AVCaptureVC animated:YES];
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

                } else if ([responseObject[@"msg"] containsString:@"实名认证中"]) {
                    [DZTools showNOHud:@"实名认证中，不能发布招聘信息" delay:2];

                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            self.commitBtn.userInteractionEnabled = YES;
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
            self.commitBtn.userInteractionEnabled = YES;
        }
        IsNeedHub:NO];
}
//经验选中
- (void)alertjingyanClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.jingyanArray.count) {
        [self.jingyanBtn setTitle:self.jingyanArray[rowInteger] forState:UIControlStateNormal];
        self.jingyanBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//薪资选中
- (void)alertxinziClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xinziArray.count) {
        [self.xinziBtn setTitle:self.xinziArray[rowInteger] forState:UIControlStateNormal];
        self.xinziBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//学历选中
- (void)alertxueliClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.xueliArray.count) {
        [self.xueliBtn setTitle:self.xueliArray[rowInteger] forState:UIControlStateNormal];
        self.xueliBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//上岗时间选中
- (void)alertShanggangClick:(NSInteger)rowInteger {
    if (rowInteger < self.constructionTimeArray.count) {
        [self.shanggangDateBtn setTitle:self.constructionTimeArray[rowInteger] forState:UIControlStateNormal];
        self.shanggangDateBtn.imageView.hidden = YES;
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//籍贯选中
- (void)alertJiguangClick:(NSInteger)rowInteger;
{
    if (rowInteger < self.jiguanArray.count) {
        //        typeId=@"";
        [self.jiguanBtn setTitle:self.jiguanArray[rowInteger] forState:UIControlStateNormal];
        self.jiguanBtn.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
//取消选中
- (void)cancelBtnClick {
    NSLog(@"点击了取消按钮");
    [self.pickerView hide];
}
//初始化数据
- (void)initData {
    self.array = [NSMutableArray array];
    self.sexArray = [NSMutableArray arrayWithObjects:@"男", @"女", nil];
    self.gangweiArray = [NSMutableArray arrayWithObjects:@"java工程师", @"架构师", @"木工", nil];
    self.xinziArray = @[@"3K以下", @"3K-5k", @"5K-10K", @"10K-30K", @"30K-50K", @"50K以上"];
    self.jingyanArray = @[@"应届生", @"1年以内", @"1-3年", @"3-5年", @"5-10年", @"10年以上"];
    self.xueliArray = @[@"初中以下", @"中专/中技", @"高中", @"大专", @"本科", @"硕士", @"博士"];
    self.constructionTimeArray = [NSMutableArray array];
//    self.sexArray = [NSMutableArray arrayWithObjects:@"女",@"男", nil];
    self.jiguanArray = [NSMutableArray array];
}
//性别的选择
-(void)alertSexClick:(NSInteger)index{
    if (index < self.sexArray.count) {
        //        typeId=@"";
        [self.sexButton setTitle:self.sexArray[index] forState:UIControlStateNormal];
//        self.sexIndex = index;
        self.sexButton.imageView.hidden = YES;
        //        typeId = [NSString stringWithFormat:@"%zd",rowInteger];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark – XibFunction

- (IBAction)endEditing:(id)sender {
    [self.bgView endEditing:YES];
}
- (IBAction)gangweiBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择求职岗位" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.gangweiArray.count; i++) {
        //        Xun_JoinListModel *typeModel = typeMArr[i];
        [alert addAction:[UIAlertAction actionWithTitle:self.gangweiArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertGangweiClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertGangweiClick:self.gangweiArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//上岗时间
- (IBAction)shanggangClick:(id)sender {

    //    NSDateFormatter *minDateFormater = [[NSDateFormatter alloc] init];
    //    [minDateFormater setDateFormat:@"yyyy-MM-dd "];
    //    NSDate *scrollToDate = [minDateFormater dateFromString:self.shanggangDateBtn.titleLabel.text];
    //
    //    WSDatePickerView *datepicker = [[WSDatePickerView alloc] initWithDateStyle:DateStyleShowYearMonthDay
    //                                                                  scrollToDate:scrollToDate
    //                                                                 CompleteBlock:^(NSDate *selectDate) {
    //
    //                                                                     NSString *date = [selectDate stringWithFormat:@"yyyy-MM-dd "];
    //                                                                     NSLog(@"选择的日期：%@", date);
    //                                                                     [self.shanggangDateBtn setTitle:date forState:UIControlStateNormal];
    //                                                                     self.shanggangDateBtn.imageView.hidden = YES;
    //                                                                     //        self.startTime = date;
    //                                                                 }];
    //    datepicker.dateLabelColor = TabbarColor;           //年-月-日-时-分 颜色
    //    datepicker.datePickerColor = [UIColor blackColor]; //滚轮日期颜色
    //    datepicker.doneButtonColor = TabbarColor;          //确定按钮的颜色
    //    datepicker.yearLabelColor = [UIColor clearColor];  //大号年份字体颜色
    //    [datepicker show];

    /**
 *
 修改最新
 */
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择上岗时间" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.constructionTimeArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.constructionTimeArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertShanggangClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertShanggangClick:self.constructionTimeArray.count];
                                            }]];

    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//提供食宿
- (IBAction)tigongsusheBtnClick:(id)sender {
    if (self.sureBtn.selected == YES) {
        self.sureBtn.selected = !self.sureBtn.selected;
        self.noBtn.selected = YES;
    } else {

        self.noBtn.selected = !self.noBtn.selected;
        self.sureBtn.selected = YES;
    }
}

//确认发布
- (IBAction)sureBtnClick:(id)sender {
    if (self.nameTextField.text.length == 0) {
        [DZTools showNOHud:@"请输入姓名" delay:2];
        return;
    }
    if ([self.jingyanBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择工龄" delay:2];
        return;
    }
    if ([self.jiguanBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择籍贯" delay:2];
        return;
    }
    if ([self.xinziBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择薪资要求" delay:2];
        return;
    }
    if ([self.sexButton.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择性别" delay:2];
        return;
    }
    if ([self.quyuBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择工作区域" delay:2];
        return;
    }
    if (self.phoneTextField.text.length == 0) {
        [DZTools showNOHud:@"请输入联系电话" delay:2];
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

    if ([self.gangweiBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择岗位" delay:2];
        return;
    }
    if ([self.xueliBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择学历" delay:2];
        return;
    }
    if ([self.shanggangDateBtn.titleLabel.text isEqualToString:@"请选择该选项"]) {
        [DZTools showNOHud:@"请选择上岗时间" delay:2];
        return;
    }
    self.commitBtn.userInteractionEnabled = NO;
    [self uploadImages];
}
//学历
- (IBAction)xueliBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择学历要求" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.xueliArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.xueliArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertxueliClick:i];
                                                }]];
    }
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//工作经验
- (IBAction)jingyanBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择工作经验" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.jingyanArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.jingyanArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertjingyanClick:i];
                                                }]];
    }
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//薪资
- (IBAction)xinziBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择薪资要求" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.xinziArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.xinziArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertxinziClick:i];
                                                }]];
    }
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
//籍贯的选择
- (IBAction)jigaunBtnCLick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择籍贯" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.jiguanArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.jiguanArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertJiguangClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertJiguangClick:self.jiguanArray.count];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

//区域
- (IBAction)quyuBtnClick:(id)sender {
    [[DZTools getAppWindow] addSubview:self.pickerView];
    [self.pickerView show];
}
//性别的选择
- (IBAction)sexButtonClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.sexArray.count; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:self.sexArray[i]
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertSexClick:i];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertSexClick:self.sexArray.count];
                                            }]];
    
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}


#pragma mark – 懒加载
- (AddressPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[AddressPickerView alloc] init];
        _pickerView.delegate = self;
        [_pickerView setTitleHeight:50 pickerViewHeight:165];
        // 关闭默认支持打开上次的结果
        //        _pickerView.isAutoOpenLast = NO;
    }
    return _pickerView;
}
- (NSMutableArray *)photosArray {
    if (!_photosArray) {
        self.photosArray = [NSMutableArray array];
    }
    return _photosArray;
}
- (NSMutableArray *)selectPhotosArray {
    if (!_selectPhotosArray) {
        self.selectPhotosArray = [NSMutableArray array];
    }
    return _selectPhotosArray;
}
- (NSMutableArray *)assestArray {
    if (!_assestArray) {
        self.assestArray = [NSMutableArray array];
    }
    return _assestArray;
}
@end
