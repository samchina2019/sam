//
//  YanshouHuoViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "YanshouHuoViewController.h"
#import "YanshouhuoCell.h"
#import "PPNumberButton.h"
#import "UnusualViewController.h"
#import "ChatViewController.h"

#import "MBProgressHUD.h"
#import "BaojiadanGoodsModel.h"
#import "ImagBtnCCell.h"
#import "TZImagePickerController.h"
#import "MyOrderPageViewController.h"
#import "WSDatePickerView.h"
@interface YanshouHuoViewController () <TZImagePickerControllerDelegate>
@property (strong, nonatomic) IBOutlet UIView *yichangJiluView;
@property (weak, nonatomic) IBOutlet UICollectionView *imageBgView;
@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIView *basicView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet PPNumberButton *shidaoNumberButton;
@property (weak, nonatomic) IBOutlet PPNumberButton *facuoNumberButton;
@property (weak, nonatomic) IBOutlet PPNumberButton *posunNumberButton;

//宜家居家装设计装修官方旗舰店
@property (weak, nonatomic) IBOutlet UILabel *shangjiaNameLabel;
//订单编号：20180230230656000236
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
//下单时间：2018-11-12 12:12
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//收件人：张三
@property (weak, nonatomic) IBOutlet UILabel *shoujianrenNameLabel;
//13526567147
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (nonatomic, strong) NSString *phoneNum;
//河南省郑州市管城回族区南曹乡美景鸿城七里河小区
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *beizhuTF;

@property (nonatomic, strong) NSMutableArray *assestArray;
@property (nonatomic, strong) NSMutableArray *photosArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *facuoArray;
@property (nonatomic, strong) NSMutableArray *posunArray;
@property (strong, nonatomic) NSArray *posunUrlArray;
@property (strong, nonatomic) NSArray *facuoUrlArray;
///商品的sku
@property (nonatomic, strong) NSString *goods_sku;
///商家名称
@property (nonatomic, strong) NSString *sellerName;
///商家id
@property (nonatomic, strong) NSString *sellerId;
///商家头像
@property (nonatomic, strong) NSString *sellerImages;
///订单编号
@property (nonatomic, strong) NSString *orderNomber;

@property (nonatomic) NSInteger page;
///选中的第几个cell
@property (nonatomic) NSIndexPath *selectIndex;
///是否破损 yes 是
@property (nonatomic, assign) BOOL isPosun;
///是否破损 yes 是
@property (nonatomic, assign) BOOL isYichang;
///是否下载
@property (nonatomic) BOOL isUploadpImg;
//是否上传
@property (nonatomic) BOOL isUploadfImg;
///是否选中原始图片
@property (assign, nonatomic) BOOL isSelectOriginalPhoto;
//总数量
@property (nonatomic) NSInteger totalNumber;
@end

@implementation YanshouHuoViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadData];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    if (@available(iOS 11.0, *)) {
        self.detailTableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }

    self.isYichang = NO;
    self.shidaoNumberButton.currentNumber = 1;
    self.facuoNumberButton.currentNumber = 1;
    self.posunNumberButton.currentNumber = 1;

    self.posunUrlArray = [NSArray array];
    self.facuoUrlArray = [NSArray array];
    self.facuoArray = [NSMutableArray array];
    self.posunArray = [NSMutableArray array];
    [self initBasicView];
    [self initDetailTableView];

    [self initIMageBgView];
}
#pragma mark – UI
//初始化tableview
- (void)initDetailTableView {
    self.headView.frame = CGRectMake(0, 0, ViewWidth, 235);
    self.detailTableView.tableHeaderView = self.headView;
    self.footView.frame = CGRectMake(0, 0, ViewWidth, 65);
    self.detailTableView.tableFooterView = self.footView;

    [self.detailTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.detailTableView registerNib:[UINib nibWithNibName:@"YanshouhuoCell" bundle:nil] forCellReuseIdentifier:@"YanshouhuoCell"];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    //    [self getDataArray];

    [self.detailTableView.mj_header beginRefreshing];
}
//初始化basic view
- (void)initBasicView {
    //阴影的颜色
    self.basicView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.basicView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.basicView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.basicView.layer.shadowOffset = CGSizeMake(0, 0);
    self.basicView.layer.cornerRadius = 5;
}
//初始化背景view
- (void)initIMageBgView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];

    layout.itemSize = CGSizeMake((self.imageBgView.bounds.size.width - 20) / 3, (self.imageBgView.bounds.size.width - 20) / 3);
    layout.minimumLineSpacing = 5;
    layout.minimumInteritemSpacing = 8;
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    // 设置UICollectionView为横向滚动
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.imageBgView.collectionViewLayout = layout;
    //
    [self.imageBgView registerNib:[UINib nibWithNibName:@"ImagBtnCCell" bundle:nil] forCellWithReuseIdentifier:@"ImagBtnCCell"];
}

#pragma mark – Network

- (void)loadData {

    NSDictionary *dict = @{

        @"id": @(self.orderId)
    };
    NSLog(@"%@", dict);
    [DZNetworkingTool getWithUrl:kOrderDetail
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.dataArray removeAllObjects];
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"][@"order"];
                for (NSDictionary *gongzhongDict in dict[@"bendian_data"]) {
                    for (NSDictionary *fenleiDict in gongzhongDict[@"data"]) {
                        for (NSDictionary *goodsDict in fenleiDict[@"data"]) {
                            BaojiadanGoodsModel *goods = [BaojiadanGoodsModel mj_objectWithKeyValues:goodsDict];
                            [self.dataArray addObject:goods];
                        }
                    }
                }
                [self.detailTableView reloadData];
                self.bianhaoLabel.text = [NSString stringWithFormat:@"订单编号：%@", dict[@"order_no"]];

                NSDictionary *seller = dict[@"seller"];
                self.sellerName = seller[@"seller_name"];
                self.sellerId = dict[@"seller_id"];
                self.orderNomber = dict[@"order_id"];
                self.sellerImages = seller[@"images"];
                self.totalNumber = [dict[@"number"] intValue];
                self.phoneNum = [NSString stringWithFormat:@"%@", seller[@"seller_phone"]];
                self.shangjiaNameLabel.text = [NSString stringWithFormat:@"%@", seller[@"seller_name"]];
                // 时间戳 -> NSDate *
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"createtime"] intValue]];
                //设置时间格式
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

                [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
                //将时间转换为字符串
                NSString *timeStr = [formatter stringFromDate:date];

                self.timeLabel.text = [NSString stringWithFormat:@"下单时间:%@", timeStr];

                NSDictionary *addDict = dict[@"address"];
                self.shoujianrenNameLabel.text = [NSString stringWithFormat:@"收件人:%@", addDict[@"name"]];
                self.phoneLabel.text = addDict[@"phone"];

                self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",
                                                                    addDict[@"province_id"], addDict[@"city_id"], addDict[@"region_id"], addDict[@"detail"]];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

#pragma mark--collectionView deleteGate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photosArray.count;
}

//
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImagBtnCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImagBtnCCell" forIndexPath:indexPath];

    [cell.imgBtn setImage:self.photosArray[indexPath.row] forState:UIControlStateNormal];
    cell.deleteBtn.hidden = NO;
    cell.block = ^(int tag) {
        if (tag == 1) {
            [self.photosArray removeObjectAtIndex:indexPath.row];

            [self.imageBgView reloadData];
        }
    };

    return cell;
}
#pragma mark--tableview deleteGate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.detailTableView.backgroundView = backgroundImageView;
        self.detailTableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.detailTableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 140;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YanshouhuoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YanshouhuoCell" forIndexPath:indexPath];
    BaojiadanGoodsModel *model = self.dataArray[indexPath.row];

    cell.allPriceLabel.text = [NSString stringWithFormat:@"%d", model.con_price];
    cell.onePriceLabel.text = [NSString stringWithFormat:@"%@", model.goods_price];
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in model.stuff_spec) {
        [array addObject:dict[@"name"]];
    }
    cell.guigeLabel.text = [NSString stringWithFormat:@"规格：%@", [array componentsJoinedByString:@""]];

    cell.cailiangNameLabel.text = [NSString stringWithFormat:@"%@ %@ 数量:%d", model.goods_name, model.stuff_brand_name, model.number];
    __weak typeof(YanshouHuoViewController *) weakself = self;
    cell.unusualBlock = ^{
        self.selectIndex = indexPath;
        self.isYichang = YES;

        self.goods_sku = [NSString stringWithFormat:@"%d_%@", model.stuff_brand_id, model.stuff_spec_id];
        weakself.yichangJiluView.frame = self.view.bounds;
        [self.view addSubview:weakself.yichangJiluView];
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Function

//检查图片
- (void)checkLocalPhotoWithTag:(NSInteger)tag {

    if (tag == 888) {

        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
        imagePickerVc.allowPickingVideo = NO;
        [self.photosArray removeAllObjects];
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

            [self.photosArray addObjectsFromArray:photos];
            [self.posunArray removeAllObjects];
            [self.posunArray addObjectsFromArray:photos];
            [self.imageBgView reloadData];
        }];
        [self presentViewController:imagePickerVc animated:YES completion:nil];

    } else if (tag == 999) {
        TZImagePickerController *imagePickerVc1 = [[TZImagePickerController alloc] initWithMaxImagesCount:10 delegate:self];
        imagePickerVc1.allowPickingVideo = NO;
        //        [self.photosArray removeAllObjects];
        [imagePickerVc1 setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            //             [self.photosArray removeAllObjects];
            [self.photosArray addObjectsFromArray:photos];
            [self.facuoArray removeAllObjects];
            [self.facuoArray addObjectsFromArray:photos];
            [self.imageBgView reloadData];
        }];
        [self presentViewController:imagePickerVc1 animated:YES completion:nil];
    }
}
//上传图片
- (void)uploadImageArrayWith:(dispatch_group_t)dispatchGroup {

    self.isUploadfImg = NO;
    if (self.posunArray.count == 0) {
        self.posunUrlArray = @[];
        self.isUploadpImg = YES;
    } else {
        dispatch_group_enter(dispatchGroup);
        [DZNetworkingTool uploadWithUrl:kUploadImgURL
            params:nil
            fileData:self.posunArray
            name:@"img[]"
            fileName:@"file.png"
            mimeType:@"image/PNG"
            progress:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSLog(@"%@", responseObject[@"data"]);
                    self.isUploadpImg = YES;
                    self.posunUrlArray = responseObject[@"data"];
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
                dispatch_group_leave(dispatchGroup);
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                dispatch_group_leave(dispatchGroup);
                NSLog(@"%@", responseObject[@"data"]);
            }
            IsNeedHub:NO];
    }
    if (self.facuoArray.count == 0) {
        self.facuoUrlArray = @[];
        self.isUploadfImg = YES;
    } else {

        dispatch_group_enter(dispatchGroup);
        [DZNetworkingTool uploadWithUrl:kUploadImgURL
            params:nil
            fileData:self.facuoArray
            name:@"img[]"
            fileName:@"file.png"
            mimeType:@"image/PNG"
            progress:nil
            success:^(NSURLSessionDataTask *task, id responseObject) {
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    NSLog(@"%@", responseObject[@"data"]);
                    self.isUploadfImg = YES;
                    self.facuoUrlArray = responseObject[@"data"];
                }
                dispatch_group_leave(dispatchGroup);
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                dispatch_group_leave(dispatchGroup);
            }
            IsNeedHub:NO];
    }
}
#pragma mark--XibFunction
//确认按钮的点击
- (IBAction)sureBtnClick:(id)sender {
#warning 信息不全等后台
    if (self.facuoNumberButton.currentNumber + self.shidaoNumberButton.currentNumber + self.posunNumberButton.currentNumber > self.totalNumber ) {
        [DZTools showNOHud:@"你选择的数量过多" delay:2];
        return;
    }
    if (self.posunArray.count == 0 && self.facuoArray.count == 0) {
        [DZTools showNOHud:@"至少选择一张图片" delay:2];
        return;
    }

    [DZTools showTextHud:@"文件正在上传，请稍等..." delay:2];
    dispatch_group_t dispatchGroup = dispatch_group_create();
    [self uploadImageArrayWith:dispatchGroup];
    dispatch_group_notify(dispatchGroup, dispatch_get_main_queue(), ^() {
        if (self.isUploadfImg && self.isUploadpImg) {

            YanshouhuoCell *cell = [self.detailTableView cellForRowAtIndexPath:self.selectIndex];
            cell.unusualBtn.backgroundColor = [UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0];
            [cell.unusualBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            cell.nomalBtn.backgroundColor = [UIColor whiteColor];
            [cell.nomalBtn setTitleColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0] forState:UIControlStateNormal];
            [self.yichangJiluView removeFromSuperview];
        } else {
            [DZTools showNOHud:@"上传图片失败，请重新上传..." delay:2];
        }
    });
}
//提交订单
- (IBAction)commitBtnClick:(id)sender {
    NSDictionary *params = @{};
    if (!self.isYichang) { ///不是异常单
        params = @{
            @"order_id": @(self.orderId),
            @"abnormal": @(1),
        };
    } else {
        if (self.beizhuTF.text.length == 0) {
            [DZTools showNOHud:@"备注信息不能为空" delay:2];
            return;
        }
        NSMutableArray *tempArray = [NSMutableArray array];
        BaojiadanGoodsModel *model = self.dataArray[self.selectIndex.row];
        int goods_id = model.goods_id;

        NSString *string = @"";
        NSString *facuoStr = @"";
        if (self.posunUrlArray.count != 0) {
            string = [self.posunUrlArray componentsJoinedByString:@","];
        }
        if (self.facuoUrlArray.count != 0) {
            facuoStr = [self.facuoUrlArray componentsJoinedByString:@","];
        }

        [tempArray addObject:@{
            @"goods_id": @(goods_id),
            @"true_to": @(self.shidaoNumberButton.currentNumber),
            @"damaged": @(self.posunNumberButton.currentNumber),
            @"mistake": @(self.facuoNumberButton.currentNumber),
            @"damaged_img": string,
            @"goods_sku": self.goods_sku,
            @"remark": self.beizhuTF.text,
            @"mistake_img": facuoStr
        }];
        params = @{
            @"order_id": @(self.orderId),
            @"abnormal": @(2),
            @"abnormal_data": [tempArray mj_JSONString]
        };
    }
    NSLog(@"%@", params);
    [DZNetworkingTool postWithUrl:kReceivGoods
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                self.tabBarController.selectedIndex = 4;
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];

        }
        IsNeedHub:NO];
}
//结束yichangview
- (IBAction)endWindowView:(id)sender {
    [self.yichangJiluView removeFromSuperview];
}
//打电话
- (IBAction)callBtnClick:(id)sender {

    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneNum];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:
                     [NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
//拍照
- (IBAction)paiPhotoClick:(UIButton *)sender {
    [self checkLocalPhotoWithTag:sender.tag];
}
//破损拍照
- (IBAction)posunImageClick:(UIButton *)sender {
    [self checkLocalPhotoWithTag:sender.tag];
}
// 取消
- (IBAction)cancelBtnClick:(id)sender {

    [self.yichangJiluView removeFromSuperview];
    [self.dataArray removeAllObjects];
}
//返回
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//聊天
- (IBAction)chattingBtnClick:(id)sender {
    NSDictionary *dict = @{
        @"user_id": self.sellerId
    };
    [DZNetworkingTool postWithUrl:kFriendDetails
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];

                NSString *headImg = dict[@"avatar"];
                NSString *title = dict[@"nickname"];

                //会话列表
                ChatViewController *conversationVC = [[ChatViewController alloc] init];
                conversationVC.hidesBottomBarWhenPushed = YES;
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = [NSString stringWithFormat:@"%@", self.sellerId];
                conversationVC.title = title;

                RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                rcduserinfo_.name = title;
                rcduserinfo_.userId = [NSString stringWithFormat:@"%@", self.sellerId];
                rcduserinfo_.portraitUri = headImg;

                [self.navigationController pushViewController:conversationVC animated:YES];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
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
@end
