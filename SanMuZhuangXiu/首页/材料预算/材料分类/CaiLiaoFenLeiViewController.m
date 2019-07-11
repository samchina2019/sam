//
//  CaiLiaoFenLeiViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "CaiLiaoFenLeiViewController.h"

#import "PurchaseCarAnimationTool.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "IQKeyboardManager.h"

#import "CailiaoZidingyiViewCell.h"
#import "ImgTitleCCell.h"
#import "CaiLiaoFenLeiCell.h"
#import "CailiaoViewCell.h"
#import "MyPingJiaImgCollectionViewCell.h"
#import "PPNumberButton.h"

#import "CailiaoClassModel.h"
#import "FilePathManager.h"
#import "CZHTagsView.h"
#import "ReLayoutButton.h"
#import "SelectSpecView.h"

#import "AddressModel.h"
#import "PinpaiModel.h"
#import "GongzhongClassModel.h"
#import "GuigeModel.h"
#import "ProjectListModel.h"
#import "SpecGuigeModel.h"

#import "GuanlianCailiaoViewController.h"
#import "CailiaoDetailViewController.h"
#import "CongxinBpViewController.h"
#import "AddressManagerViewController.h"
#import "StoreDetailViewController.h"

static NSString *imgCellId = @"imgCellId";

@interface CaiLiaoFenLeiViewController () <CZHTagsViewDelegate, CZHTagsViewDataSource, PPNumberButtonDelegate> {
    FilePathManager *filemanager;
}

@property (nonatomic, strong) SelectSpecView *selectSpecView;
@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
@property (strong, nonatomic) CZHTagsView *tagsView;
@property (nonatomic, strong) CaiLiaoFenLeiCell *selectCell;

//材料单tableview
@property (weak, nonatomic) IBOutlet UITableView *cailiaoDanTableView;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;
@property (weak, nonatomic) IBOutlet UIButton *xuanhaoBtn;
@property (strong, nonatomic) IBOutlet UIScrollView *zidingyicailiaoView;
@property (weak, nonatomic) IBOutlet UITextField *cailiaoNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cailiaoGuigeTF;
@property (weak, nonatomic) IBOutlet PPNumberButton *ppnumBtn;
//规格
@property (weak, nonatomic) IBOutlet UIView *guigeView;
@property (weak, nonatomic) IBOutlet UIButton *sureAddBtn;
@property (strong, nonatomic) IBOutlet UIView *guigeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeVIewHeight;
@property (strong, nonatomic) IBOutlet UIView *yixuanCailiaoView;
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressBtn;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;
@property (weak, nonatomic) IBOutlet UITableView *classTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
//添加材料
@property (weak, nonatomic) IBOutlet UIButton *addCailiaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
//角标
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UITextField *unitLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
///自定义材料
@property (strong, nonatomic) IBOutlet UIView *zidingyiCailiaoNewView;
///自定义材料tableView
@property (weak, nonatomic) IBOutlet UITableView *tabelNewView;
///自定义材料单位

@property (weak, nonatomic) IBOutlet UITextField *danweiNewLabel;
///自定义材料确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureNewBtn;

@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSMutableArray *addSepcArray;
@property (strong, nonatomic) NSArray *classDataArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *pinpaiArray;
@property (nonatomic, strong) NSMutableArray *guigeArray;
@property (nonatomic, strong) NSMutableArray *selectSpecData;
@property (nonatomic, strong) NSArray *selectTagArray;
@property (nonatomic, strong) NSMutableArray *cailiaodanArray;
@property (nonatomic, strong) NSMutableArray *cailiaoArray;

@property (nonatomic, strong) GongzhongClassModel *gongzhongModel;
@property (nonatomic, strong) CailiaoClassModel *cailiaoClassModel;
@property (nonatomic, strong) PinpaiModel *pinpaiModel;
@property (nonatomic, strong) GuigeModel *guigeModel;

///工种ID
@property (nonatomic, assign) NSInteger gongzhongID;
///分类ID
@property (nonatomic, assign) NSInteger classID;
///选中的工种分类
@property (assign, nonatomic) NSInteger classSelectIndex;
///材料ID
@property (nonatomic, assign) NSInteger cailiaoId;
///购物车数量
@property (nonatomic, assign) NSInteger number;
@property (nonatomic) NSInteger page;
///记录第几个cell
@property (nonatomic, strong) NSIndexPath *index;
///地址ID
@property (nonatomic, assign) int addressId;
///选中的分类cell
@property (assign, nonatomic) NSInteger selectIndex;

@property (nonatomic, strong) NSString *loginToken;

@end

@implementation CaiLiaoFenLeiViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"材料分类";

    [[DZTools getAppDelegate].locationManager startUpdatingLocation];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYYMMddHHmm"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    self.cailiaodanNameText.placeholder = currentTimeString;
    //    [self loadAddress];

    [self initData];
    [self initCollectionView];
    [self initTableView];
    [self getTotalClassDataArrayFromServer];
    if (_isFromEdit) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"确认添加" style:UIBarButtonItemStyleDone target:self action:@selector(sureFinish)];
        [self.selectSpecData removeAllObjects];
        [self.selectedCailiao removeAllObjects];

        //        /底部按钮不可点击
        self.bottomView.userInteractionEnabled = NO;

        [self.view layoutIfNeeded];
    }
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"xuanzeSpec" object:nil];
}

#pragma mark – UI
- (void)initCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ViewWidth - 60) / 5;
    layout.itemSize = CGSizeMake(width, 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerClass:[ImgTitleCCell class] forCellWithReuseIdentifier:imgCellId];
}
- (void)initTableView {

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    //    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
    //        NSLog(@"上拉加载更多");
    //        [self loadMore];
    //    }];
    [self.tableView registerNib:[UINib nibWithNibName:@"CaiLiaoFenLeiCell" bundle:nil] forCellReuseIdentifier:@"CaiLiaoFenLeiCell"];
    [self.cailiaoDanTableView registerNib:[UINib nibWithNibName:@"CailiaoViewCell" bundle:nil] forCellReuseIdentifier:@"CailiaoViewCell"];
    //    [self.tabelNewView registerNib:[UINib nibWithNibName:@"CailiaoZidingyiViewCell" bundle:nil] forCellReuseIdentifier:@"CailiaoZidingyiViewCell"];

    self.cailiaoDanTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //    self.tableFootView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    //    self.tableView.tableFooterView = self.tableFootView;
}

#pragma mark – Network
- (void)getTotalClassDataArrayFromServer {
    [DZNetworkingTool postWithUrl:kGetCategory
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                if ([[responseObject objectForKey:@"data"][@"stuff_list"] isEqual:[NSNull null]]) {
                    [DZTools showNOHud:@"数据为空" delay:2];
                    [self.classTableView reloadData];
                } else {
                    NSDictionary *dict = [responseObject objectForKey:@"data"];
                    NSArray *arr = [dict objectForKey:@"stuff_category"];
                    NSLog(@"-----------%@", dict);
                    [self.array removeAllObjects];
                    for (NSDictionary *dict in arr) {
                        GongzhongClassModel *model = [GongzhongClassModel mj_objectWithKeyValues:dict];
                        [self.array addObject:model];
                    }
                    [self.collectionView reloadData];

                    GongzhongClassModel *model = self.array[self.classSelectIndex];
                    self.gongzhongID = model.stuff_work_id;
                    self.classDataArray = model.category;
                    [self.classTableView reloadData];

                    [self.dataArray removeAllObjects];
                    [self.tableView reloadData];
                    if (self.array.count > 0) {
                        CailiaoClassModel *cailiaomodel = [CailiaoClassModel mj_objectWithKeyValues:model.category[0]];
                        self.classID = cailiaomodel.category_id;
                        [self getDataArrayFromServerIsRefresh:YES];
                    }
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {

    NSDictionary *dict = @{
        @"limit": @(8),
        @"category_id": @(self.classID),
        @"page": @(_page)
    };
    [DZNetworkingTool postWithUrl:kGetStuffList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                if ([[responseObject objectForKey:@"data"][@"stuff_list"] isEqual:[NSNull null]]) {

                    [self.dataArray removeAllObjects];
                    [self.tableView reloadData];
                } else {
                    NSArray *array = [responseObject objectForKey:@"data"][@"stuff_list"];

                    if (isRefresh) {
                        [self.dataArray removeAllObjects];
                    }

                    for (NSDictionary *dict1 in array) {

                        StuffListModel *model = [StuffListModel mj_objectWithKeyValues:dict1];

                        [self.dataArray addObject:model];
                    }
                    [self.tableView reloadData];
                }
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
        }
        IsNeedHub:NO];
}
#pragma mark - <UICollectionViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgTitleCCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId forIndexPath:indexPath];

    GongzhongClassModel *gongzhongModel = self.array[indexPath.row];

    cell.textLabel.text = gongzhongModel.name;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    if (self.classSelectIndex == indexPath.row) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.selectimage]] placeholderImage:[UIImage imageNamed:@"default_pre"]];
    }

    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    GongzhongClassModel *gongzhongModel = self.array[self.classSelectIndex];
    GongzhongClassModel *gongzhongModel2 = self.array[indexPath.row];

    ImgTitleCCell *selectCell = (ImgTitleCCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.classSelectIndex inSection:0]];
    [selectCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    ImgTitleCCell *cell = (ImgTitleCCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel2.selectimage]] placeholderImage:[UIImage imageNamed:@"default_pre"]];
    self.classSelectIndex = indexPath.row;
    self.gongzhongID = gongzhongModel2.stuff_work_id;

    //不同的工种有不同的材料分类
    self.classDataArray = gongzhongModel2.category;
    [self.classTableView reloadData];

    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    if (self.classDataArray.count > 0) {
        CailiaoClassModel *cailiaomodel = [CailiaoClassModel mj_objectWithKeyValues:self.classDataArray[0]];
        self.classID = cailiaomodel.category_id;
        [self getDataArrayFromServerIsRefresh:YES];
        self.tableFootView.hidden = NO;
    } else {
        self.tableFootView.hidden = YES;
    }
}

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (tableView == self.classTableView) {
        return (self.classDataArray.count + 1);
    } else if (tableView == self.cailiaoDanTableView) {
        if (self.selectedCailiao.count == 0) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.cailiaoDanTableView.backgroundView = backgroundImageView;
            self.cailiaoDanTableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.cailiaoDanTableView.backgroundView = nil;
        }
        return self.selectedCailiao.count;
    }
    //    else if (tableView == self.cailiaoDanTableView) {
    //
    //        return (self.cailiaoArray.count +1);
    //    }
    else {
        if (self.dataArray.count == 0) {
            UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
            self.tableView.backgroundView = backgroundImageView;
            self.tableView.backgroundView.contentMode = UIViewContentModeCenter;
        } else {
            self.tableView.backgroundView = nil;
        }
        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    if (tableView == self.classTableView) {
        return 50;
    } else if (tableView == self.cailiaoDanTableView) {
        return 80;
    } else {
        return 44;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.classTableView) {
        static NSString *cellIdentifier = @"classCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        }
        if (self.selectIndex == indexPath.row) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];

        } else {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        }
        if (indexPath.row == self.classDataArray.count) {

            cell.textLabel.text = @"自定义+";

        } else {
            CailiaoClassModel *cailiaomodel = [CailiaoClassModel mj_objectWithKeyValues:self.classDataArray[indexPath.row]];

            cell.textLabel.text = cailiaomodel.name;

            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }

        return cell;
    } else if (tableView == self.cailiaoDanTableView) {

        CailiaoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CailiaoViewCell" forIndexPath:indexPath];
        StuffListModel *cailiaomodel = self.selectedCailiao[indexPath.row];

        cell.nameLabel.text = cailiaomodel.stuff_name;
        cell.ppnumBtn.currentNumber = [cailiaomodel.selectsSpecDict[@"number"] intValue];
        
        cell.guigeLabel.text = [NSString stringWithFormat:@"规格:%@", cailiaomodel.selectsSpecDict[@"name"]];
        if (cailiaomodel.selectBrandDict.count == 0) {
            cell.pinpaiLabel.text = @"(无品牌)";
        } else {
            cell.pinpaiLabel.text = [NSString stringWithFormat:@"(%@)", cailiaomodel.selectBrandDict[@"name"]];
        }
        cell.numBlock = ^(CGFloat num) {

            NSDictionary *dict = @{
                @"stuff_spec_id": cailiaomodel.selectsSpecDict[@"stuff_spec_id"],
                @"number": @(num),
                @"name": cailiaomodel.selectsSpecDict[@"name"],
                @"array": cailiaomodel.selectsSpecDict[@"array"],

            };

            cailiaomodel.selectsSpecDict = dict;
            [self.selectedCailiao replaceObjectAtIndex:indexPath.row withObject:cailiaomodel];

            if (num == 0) {
                [self.selectedCailiao removeObjectAtIndex:indexPath.row];
                self.number = self.selectedCailiao.count;
            }

            [self.selectSpecView.tableView reloadData];
            [self.tableView reloadData];
            [self.cailiaoDanTableView reloadData];
        };
        return cell;

    } else {
        CaiLiaoFenLeiCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CaiLiaoFenLeiCell" forIndexPath:indexPath];

        StuffListModel *cailiaomodel = self.dataArray[indexPath.row];

        NSString *nameStr = cailiaomodel.stuff_name;
        if (nameStr.length == 0 || [nameStr isEqualToString:@"null"]) {
            nameStr = @"材料名";
        }
        cell.nameLabel.text = nameStr;
        cell.pinpaiTF.text = @"自定义";
        cell.addBtn.hidden = NO;
        cell.yixuanBtn.hidden = YES;

        for (int i = 0; i < self.selectedCailiao.count; i++) {
            StuffListModel *model = self.selectedCailiao[i];
            if (model.stuff_id == cailiaomodel.stuff_id) {
                if ([[model.selectBrandDict allKeys] count] != 0) {
                    cell.pinpaiTF.text = model.selectBrandDict[@"name"];
                }
                if ([[model.selectsSpecDict allKeys] count] != 0) {
                    cell.addBtn.hidden = YES;
                    cell.yixuanBtn.hidden = NO;
                    //                    cell.jiajianBtn.currentNumber = model.number;
                }
                break;
            }
        }

        __weak typeof(CaiLiaoFenLeiCell *) weakself = cell;
        cell.pinpaiBlock = ^{
            self.stufflistModel = cailiaomodel;
            [self.pinpaiArray removeAllObjects];

            self.cailiaoId = cailiaomodel.stuff_id;

            NSArray *tempArray = cailiaomodel.brand;
            for (NSDictionary *pinpaiDict in tempArray) {
                PinpaiModel *pinModel = [PinpaiModel mj_objectWithKeyValues:pinpaiDict];
                [self.pinpaiArray addObject:pinModel];
            }
            [self alertPinpaiViewWithcellView:weakself];
        };

        cell.yixuanBlock = ^{

            self.selectCell = weakself;
            self.index = indexPath;
            self.stufflistModel = cailiaomodel;
            [self.guigeArray removeAllObjects];
            if (cailiaomodel.spec.count == 0) {
                //
                [DZTools showNOHud:@"暂无规格" delay:2];
                return;
            } else {
                NSArray *guiTempArray = cailiaomodel.spec;

                for (NSDictionary *guigeDict in guiTempArray) {
                    GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];

                    [self.guigeArray addObject:guigeModel];
                }
            }
            [self.selectSpecData removeAllObjects];
            for (int i = 0; i < self.selectedCailiao.count; i++) {
                StuffListModel *model = self.selectedCailiao[i];
                if (model.stuff_id == cailiaomodel.stuff_id) {
                    [self.selectSpecData addObject:model.selectsSpecDict];
                }
            }
            self.selectSpecView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
             self.selectSpecView.name = cailiaomodel.stuff_name;
            self.selectSpecView.dataArray = self.guigeArray;
            self.selectSpecView.selectDataArray = self.selectSpecData;
            self.selectSpecView.tebleViewHeight.constant = self.guigeArray.count * 50;
            [self.selectSpecView.guigetableView reloadData];
            [self.selectSpecView.tableView reloadData];
            [[DZTools getAppWindow] addSubview:self.selectSpecView];

        };
        cell.numBlock = ^(CGFloat num) {
            self.stufflistModel = cailiaomodel;
            self.stufflistModel.number = num;
            int index = 0;
            for (int i = 0; i < self.selectedCailiao.count; i++) {
                StuffListModel *model = self.selectedCailiao[i];
                if (model.stuff_id == cailiaomodel.stuff_id) {
                    index = i;
                    break;
                }
            }
            [self.selectedCailiao replaceObjectAtIndex:index withObject:self.stufflistModel];

            [self.cailiaoDanTableView reloadData];
        };
        cell.tianjiaBlock = ^{
            self.selectCell = weakself;
            self.index = indexPath;

            self.stufflistModel = cailiaomodel;
            [self.guigeArray removeAllObjects];
            if (cailiaomodel.spec.count == 0) {
                [DZTools showNOHud:@"暂无规格" delay:2];
                return;
            } else {
                NSArray *guiTempArray = cailiaomodel.spec;

                for (NSDictionary *guigeDict in guiTempArray) {
                    GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];

                    [self.guigeArray addObject:guigeModel];
                }
            }

            self.selectSpecView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
            self.selectSpecView.name = cailiaomodel.stuff_name;
            self.selectSpecView.dataArray = self.guigeArray;
            [self.selectSpecView.selectDataArray removeAllObjects];
            self.selectSpecView.tebleViewHeight.constant = self.guigeArray.count * 50;
            [self.selectSpecView.guigetableView reloadData];
            [self.selectSpecView.tableView reloadData];
            [[DZTools getAppWindow] addSubview:self.selectSpecView];

        };

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        if (indexPath.row == self.classDataArray.count) {

            [self zidingyicailiaoFenlei];

        } else {
            if (self.selectIndex != indexPath.row) {
                UITableViewCell *selectCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex inSection:0]];
                selectCell.textLabel.textColor = UIColorFromRGB(0x666666);
                selectCell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
                UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
                cell.textLabel.textColor = UIColorFromRGB(0x333333);
                cell.textLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightBold];
                self.selectIndex = indexPath.row;

                CailiaoClassModel *cailiaomodel = [CailiaoClassModel mj_objectWithKeyValues:self.classDataArray[indexPath.row]];
                if (self.classDataArray.count == 1) {
                    [self.dataArray removeAllObjects];
                    [self.tableView reloadData];
                } else {

                    self.classID = cailiaomodel.category_id;
                    [self getDataArrayFromServerIsRefresh:YES];
                }
            }
        }
    } else if (tableView == self.cailiaoDanTableView) {
        //        CailiaodanDetailViewController
    } else {
        //        StuffListModel *cailiaomodel = self.dataArray[indexPath.row];
        //        self.hidesBottomBarWhenPushed = YES;
        //        CailiaoDetailViewController *viewController = [[CailiaoDetailViewController alloc] init];
        //        viewController.cailiaomodel = cailiaomodel;
        //        [self.navigationController pushViewController:viewController animated:YES];
        //        self.hidesBottomBarWhenPushed = YES;
    }
}
#pragma mark-- <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTF resignFirstResponder];
    if (textField.text.length == 0) {
        [DZTools showNOHud:@"搜索内容不能为空" delay:2];

    } else {
        NSDictionary *dict = @{
            @"limit": @(8),
            @"category_id": @(self.classID),
            @"page": @(1),
            @"search": self.searchTF.text
        };
        [DZNetworkingTool postWithUrl:kGetStuffList
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                if ([responseObject[@"code"] intValue] == SUCCESS) {

                    if ([[responseObject objectForKey:@"data"][@"stuff_list"] isEqual:[NSNull null]]) {

                        [self.dataArray removeAllObjects];
                        [self.tableView reloadData];
                    } else {
                        NSArray *array = [responseObject objectForKey:@"data"][@"stuff_list"];

                        NSLog(@"-----------%@", responseObject);

                        [self.dataArray removeAllObjects];

                        for (NSDictionary *dict1 in array) {

                            StuffListModel *model = [StuffListModel mj_objectWithKeyValues:dict1];

                            [self.dataArray addObject:model];
                        }
                        [self.tableView reloadData];
                    }
                } else {
                    [DZTools showNOHud:responseObject[@"msg"] delay:2];
                }
            }
            failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                [DZTools showNOHud:RequestServerError delay:2.0];
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
            }
            IsNeedHub:NO];
    }

    return YES;
}

#pragma mark-- CZHTagsViewDelegateCZHTagsViewDataSource
- (NSArray *)czh_tagsArrayInTagsView:(CZHTagsView *)tagsView {
    NSMutableArray *nameArray = [NSMutableArray array];
    //    for (GuigeModel *dict in self.guigeArray) {
    //        [nameArray addObject:dict.name];
    //    }

    return [nameArray copy];
}
//标签文字两边留白 默认5 如果是CZHTagsViewStyleFit，不走这个方法
- (CGFloat)czh_paddingWidthForItemInTagsView:(CZHTagsView *)tagsView {
    return 10;
}
//标签的高度 默认30
- (CGFloat)czh_heightForItemInTagsView:(CZHTagsView *)tagsView {
    return 20;
}
//每一行之前的距离 默认10
- (CGFloat)czh_marginHeightForRowInTagsView:(CZHTagsView *)tagsView {
    return 10;
}
//两个标签之前的距离 默认10
- (CGFloat)czh_marginWithForItemInTagsView:(CZHTagsView *)tagsView {
    return 15;
}

- (UIEdgeInsets)czh_insetForTagsView:(CZHTagsView *)tagsView {
    return UIEdgeInsetsMake(10, 20, 10, 0);
}
//字体大小 默认15
- (UIFont *)czh_fontForItemInTagsView:(CZHTagsView *)tagsView {
    return [UIFont systemFontOfSize:10];
}
//边框颜色
- (UIColor *)czh_borderColorForItemInTagsView:(CZHTagsView *)tagsView {
    return UIColorFromRGB(0x999999);
}
//选中边框颜色
- (UIColor *)czh_selectBorderColorForItemInTagsView:(CZHTagsView *)tagsView;
{
    return TabbarColor;
}
//字体颜色 默认 黑色
- (UIColor *)czh_textColorForItemInTagsView:(CZHTagsView *)tagsView {
    return UIColorFromRGB(0x666666);
}
//字体颜色 默认 黑色
- (UIColor *)czh_selectTextColorForItemInTagsView:(CZHTagsView *)tagsView {
    return TabbarColor;
}
- (void)czh_tagsView:(CZHTagsView *)tagsView didSelectItemWithSelectTagsArray:(NSArray *)selectTagsArray {
    self.selectTagArray = nil;
    self.selectTagArray = selectTagsArray;
}
- (void)czh_tagsViewWithHeigth:(CGFloat)selfHeight;
{

    self.guigeVIewHeight.constant = selfHeight + 10;
    [self.guigeBgView layoutIfNeeded];
}
#pragma mark - Function

- (void)initData {

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.pinpaiArray = [NSMutableArray array];
    self.guigeArray = [NSMutableArray array];
    self.cailiaodanArray = [NSMutableArray array];
    self.selectedCailiao = [NSMutableArray array];
    self.selectSpecData = [NSMutableArray array];
    self.cailiaoArray = [NSMutableArray array];
    self.addSepcArray = [NSMutableArray array];

    self.classSelectIndex = 0;
    self.number = 0;
}
- (void)alertPinpaiViewWithcellView:(CaiLiaoFenLeiCell *)cell {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请选择品牌类型" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.pinpaiArray.count; i++) {
        PinpaiModel *typeModel = self.pinpaiArray[i];

        [alert addAction:[UIAlertAction actionWithTitle:typeModel.name
                                                  style:UIAlertActionStyleDefault
                                                handler:^(UIAlertAction *_Nonnull action) {
                                                    [self alertXinziClick:i intoCell:cell];
                                                }]];
    }
    [alert addAction:[UIAlertAction actionWithTitle:@"自定义品牌"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self zidingyipinpai];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self alertXinziClick:self.pinpaiArray.count intoCell:cell];
                                            }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertXinziClick:(NSInteger)rowInteger intoCell:(CaiLiaoFenLeiCell *)cell;
{
    cell.pinpaiTF.text = @"";
    if (rowInteger < self.pinpaiArray.count) {

        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];

        cell.pinpaiTF.text = typeModel.name;
        self.stufflistModel.selectBrandDict = @{
            @"stuff_brand_id": @(typeModel.stuff_brand_id),
            @"stuff_id": @(typeModel.stuff_id),
            @"name": typeModel.name
        };
    }
    int index = -1;
    for (int i = 0; i < self.selectedCailiao.count; i++) {
        StuffListModel *model = self.selectedCailiao[i];
        if (model.stuff_id == self.stufflistModel.stuff_id) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [self.selectedCailiao replaceObjectAtIndex:index withObject:self.stufflistModel];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

// 自定义材料分类
- (void)zidingyicailiaoFenlei {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"自定义分类" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.frame = CGRectMake(15, 64, 240, 30);
        textField.placeholder = @"请自定义分类";

    }];

    //    /定义第2个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.frame = CGRectMake(15, 104, 240, 30);
        textField.placeholder = @"请描述材料分类";
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
                                                          //获取第2个输入框；
                                                          UITextField *desField = alertController.textFields.lastObject;
                                                          [self sendCailiaoFenleiMessage:textField.text addDes:desField.text];
                                                      }]];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)sendCailiaoFenleiMessage:(NSString *)name addDes:(NSString *)des {
    NSString *stuffId = [NSString stringWithFormat:@"%ld", (long) self.gongzhongID];
    NSDictionary *dict = @{
        @"stuff_work_id": stuffId,
        @"name": name,
        @"des": des
    };
    [DZNetworkingTool postWithUrl:kApplyCategory
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];

                [self getTotalClassDataArrayFromServer];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//自定义品牌
- (void)zidingyipinpai {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"自定义品牌" preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
        textField.placeholder = @"请自定义品牌";
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
                                                          [self sendMessage:textField.text];
                                                      }]];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)sendMessage:(NSString *)messsage {
    if (messsage.length == 0) {
        [DZTools showNOHud:@"品牌名称不能为空" delay:2];
        return;
    }
    NSString *stuff = [NSString stringWithFormat:@"%ld", (long) self.cailiaoId];
    NSDictionary *dict = @{ @"stuff_id": stuff,
                            @"brand_name": messsage };

    [DZNetworkingTool postWithUrl:kGetapplyBrand
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self refresh];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];

    if ([dic[@"title"] isEqualToString:@"spce"]) {

        self.number = 0;
        [self.selectedCailiao removeAllObjects];
        [self.selectSpecData removeAllObjects];
        [self.cailiaoDanTableView reloadData];
        [self.tableView reloadData];
    }
}
- (void)sureFinish {
    NSMutableArray *array = [NSMutableArray array];
    ProjectListModel *model = [ProjectListModel new];
    for (StuffListModel *temp in self.selectedCailiao) {
        model.number = [temp.selectsSpecDict[@"number"] intValue];
        model.selectBrandDict = temp.selectBrandDict;
        model.selectsSpecDict = temp.selectsSpecDict;
        model.stuff_name = temp.stuff_name;
        model.stuff_id = temp.stuff_id;
        model.spec = temp.spec;
        model.brand = temp.brand;
        [array addObject:model];
    }
    self.change([array copy]);
    [self.navigationController popViewControllerAnimated:YES];

    self.numberLabel.text = 0;
    self.totalLabel.text = 0;
    [self.view layoutIfNeeded];
    [self.cailiaoDanTableView reloadData];
}

#pragma mark - XibFunction
//自定义材料
- (IBAction)zidingyicailiao:(id)sender {
    self.ppnumBtn.currentNumber = 1;
    self.zidingyicailiaoView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
    [[DZTools getAppWindow] addSubview:self.scrollView];
    [self.scrollView addSubview:self.zidingyicailiaoView];
}
//取消
- (IBAction)cancleBtnClicked:(id)sender {
    if (self.cailiaoNameTF.isFirstResponder || self.cailiaoGuigeTF.isFirstResponder) {
        [self.cailiaoNameTF endEditing:YES];
        [self.cailiaoGuigeTF endEditing:YES];
    } else {
        [self.zidingyicailiaoView removeFromSuperview];
        [self.scrollView removeFromSuperview];
    }
}
//确定自定义材料
- (IBAction)commitBtnClicked:(id)sender {
    [self.zidingyicailiaoView removeFromSuperview];
    [self.scrollView removeFromSuperview];

    if (self.cailiaoNameTF.text.length == 0) {
        [DZTools showNOHud:@"材料名称不能为空" delay:2];
        return;
    }

    if (self.cailiaoGuigeTF.text.length == 0) {
        [DZTools showNOHud:@"材料规格不能为空" delay:2];
        return;
    }

    if (self.unitLabel.text.length == 0) {
        [DZTools showNOHud:@"材料单位不能为空" delay:2];
        return;
    }

    NSString *stuff = [NSString stringWithFormat:@"%ld", (long) self.classID];
    NSDictionary *dict = @{
        @"stuff_category_id": stuff,
        @"name": self.cailiaoNameTF.text,
        @"spec_name": self.cailiaoGuigeTF.text,
        @"unit": self.unitLabel.text

    };
    NSLog(@"---------%@", dict);
    [DZNetworkingTool postWithUrl:kApplyStuff
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                [self getDataArrayFromServerIsRefresh:YES];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
//确定添加规格
- (IBAction)sureAddBtnClick:(id)sender {
    if (self.selectTagArray.count == 0) {
        [DZTools showNOHud:@"请务必选择一个规格" delay:2];
        return;
    }

    CGRect rect = [self.tableView rectForRowAtIndexPath:self.index];
    /// 获取当前cell 相对于self.view 当前的坐标
    rect.origin.y = rect.origin.y + self.tableView.frame.origin.y;
    CGRect imageViewRect = self.selectCell.addBtn.frame;
    imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y;
    imageViewRect.origin.x = CGRectGetMaxX(self.selectCell.addBtn.frame);

    [[PurchaseCarAnimationTool shareTool] startAnimationandView:self.selectCell.addBtn.imageView
                                                           rect:imageViewRect
                                                    finisnPoint:CGPointMake(ViewWidth / 4, ViewHeight - 100)
                                                    finishBlock:^(BOOL finish) {

                                                        [PurchaseCarAnimationTool shakeAnimation:self.cartBtn];
                                                    }];

    [self.guigeBgView removeFromSuperview];
    [self.tagsView removeFromSuperview];
    self.tagsView = nil;
    NSString *nameStr = @"";
    NSInteger stuff_spec_id = 0;
    NSInteger stuff_id = 0;
    for (GuigeModel *dict in self.guigeArray) {
        if ([dict.spec_name isEqualToString:self.selectTagArray[0]]) {

            nameStr = dict.spec_name;
            stuff_spec_id = dict.spec_id;
            stuff_id = dict.stuff_id;
        }
    }

    self.stufflistModel.selectsSpecDict = @{
        @"stuff_spec_id": @(stuff_spec_id),
        @"stuff_id": @(stuff_id),
        @"name": nameStr
    };
    self.stufflistModel.number = 1;
    [self.selectedCailiao addObject:self.stufflistModel];
    [self.cailiaoDanTableView reloadData];

    self.number = self.selectedCailiao.count;
    [self.tableView reloadData];
}
//点击其他地方消失
- (IBAction)selectClick:(id)sender {
    [self.guigeBgView removeFromSuperview];
}
//已选材料
- (IBAction)addCailiaoBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.yixuanCailiaoView.frame = self.view.bounds;
        [self.view insertSubview:self.yixuanCailiaoView belowSubview:self.bottomView];
    } else {
        [self.yixuanCailiaoView removeFromSuperview];
    }
}
//选好了按钮的点击
- (IBAction)shengCailiaoBtnClick:(id)sender {
    if (self.selectedCailiao.count <= 0) {
        [DZTools showNOHud:@"您还没有选择材料" delay:2];
        [self.yixuanCailiaoView removeFromSuperview];
    } else {

        self.hidesBottomBarWhenPushed = YES;
        GuanlianCailiaoViewController *viewController = [[GuanlianCailiaoViewController alloc] init];
        viewController.totalSelectedStuffList = self.selectedCailiao;
        if (viewController.isFromTiaoguo) {

        } else {
            viewController.returnBlock = ^(NSMutableArray *_Nonnull array) {
                NSArray *tempArray = [NSArray array];
                tempArray = [array copy];
                [self.selectedCailiao addObjectsFromArray:tempArray];
            };
        }

        self.cailiaodanScollView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.cailiaodanScollView];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;

        [self.yixuanCailiaoView removeFromSuperview];
    }
}
//确定
- (IBAction)sureBtnClick:(id)sender {
    [self.scrollView removeFromSuperview];
    [self.cailiaodanScollView removeFromSuperview];

    //    double latitude = [DZTools getAppDelegate].latitude;
    //    double longitude = [DZTools getAppDelegate].longitude;
    NSMutableArray *tempArray = [NSMutableArray array];

    for (StuffListModel *model in self.selectedCailiao) {

        [tempArray addObject:@{
            @"number": model.selectsSpecDict[@"number"],
            @"stuff_id": @(model.stuff_id),
            @"stuff_name": model.stuff_name,
            @"stuff_brand_id": [model.selectBrandDict objectForKey:@"stuff_brand_id"] == nil ? @"0" : [model.selectBrandDict objectForKey:@"stuff_brand_id"],
            @"stuff_brand_name": [model.selectBrandDict objectForKey:@"name"] == nil ? @"无品牌" : [model.selectBrandDict objectForKey:@"name"],
            @"stuff_spec_id": model.selectsSpecDict[@"stuff_spec_id"] == nil ? @"" : model.selectsSpecDict[@"stuff_spec_id"],
        }];
    }

    if (self.cailiaodanNameText.text.length == 0) {
        self.cailiaodanNameText.text = self.cailiaodanNameText.placeholder;
    }

    NSLog(@"-------%@", tempArray);
    NSDictionary *dict = @{
        @"name": self.cailiaodanNameText.text,
        @"stuff": [tempArray mj_JSONString],
    };
    NSLog(@"%@", dict);

    [DZNetworkingTool postWithUrl:kAddStuffCart
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];

                [self.selectedCailiao removeAllObjects];
                self.numberLabel.text = 0;
                self.totalLabel.text = 0;
                [self.view layoutIfNeeded];
                [self.cailiaoDanTableView reloadData];

                [self.cailiaodanScollView removeFromSuperview];

                self.tabBarController.selectedIndex = 3;
                [self.navigationController popToRootViewControllerAnimated:NO];
            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            NSLog(@"********%@", responseObject);

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
    self.selectTagArray = nil;
    [self.guigeArray removeAllObjects];
    [self.scrollView removeFromSuperview];
    [self.cailiaodanScollView removeFromSuperview];
}
//点击取消
- (IBAction)quxiaoCailiaodanClick:(id)sender {
    [self.yixuanCailiaoView removeFromSuperview];
}
//取消关联
- (IBAction)quxiaoguanlianClick:(id)sender {
    self.selectTagArray = nil;
    [self.guigeArray removeAllObjects];
    [self.cailiaodanScollView removeFromSuperview];
    [self.scrollView removeFromSuperview];
}
//清空按钮的点击
- (IBAction)deleteBtnClick:(id)sender {

    self.number = 0;

    [self.selectSpecData removeAllObjects];
    [self.selectedCailiao removeAllObjects];

    [self.cailiaoDanTableView reloadData];
    [self.tableView reloadData];

    [self.selectSpecView removeFromSuperview];
    [self.yixuanCailiaoView removeFromSuperview];
}
//自定义取消
- (IBAction)newCancelBtnClick:(id)sender {
    [self.zidingyiCailiaoNewView removeFromSuperview];
}
//地址点击
- (IBAction)addressBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    AddressManagerViewController *vc = [[AddressManagerViewController alloc] init];
    vc.block = ^(AddressModel *_Nonnull model) {

        self.addressId = model.address_id;
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail];
        [self.addressBtn setTitle:[NSString stringWithFormat:@"%@%@%@%@", model.Area[@"province"], model.Area[@"city"], model.Area[@"region"], model.detail] forState:UIControlStateNormal];
        [self.addressBtn setImage:[UIImage imageNamed:@"xiasanjiao"] forState:UIControlStateNormal];

    };
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark – 懒加载

- (void)setNumber:(NSInteger)number {
    _number = number;

    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long) _number];
    self.totalLabel.text = [NSString stringWithFormat:@"共计：%ld种材料", (long) _number];
    if (number == 0) {
        self.numberLabel.hidden = YES;
        self.totalLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
        self.totalLabel.hidden = NO;
    }
}

- (SelectSpecView *)selectSpecView {
    if (!_selectSpecView) {
        _selectSpecView = [[SelectSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(CaiLiaoFenLeiViewController *) weakself = self;

        _selectSpecView.sureBlock = ^(NSArray *_Nonnull array) {
            [weakself.addSepcArray removeAllObjects];
            if (weakself.selectSpecData.count != 0) {
                for (NSDictionary *dict in array) {
                    if ([dict[@"stuff_spec_id"] length] != 0) {
                        NSDictionary *list = @{
                            @"stuff_spec_id": dict[@"stuff_spec_id"],
                            @"number": dict[@"number"],
                            @"name": dict[@"name"],
                            @"array": dict[@"array"]
                        };
                        weakself.stufflistModel.selectsSpecDict = list;
                        StuffListModel *xinModel = [[StuffListModel alloc] init];
                        xinModel.stuff_name = weakself.stufflistModel.stuff_name;
                        xinModel.image = weakself.stufflistModel.image;
                        xinModel.auto_type = weakself.stufflistModel.auto_type;
                        xinModel.auto_count = weakself.stufflistModel.auto_count;
                        xinModel.stuff_id = weakself.stufflistModel.stuff_id;
                        xinModel.auto_integer = weakself.stufflistModel.auto_integer;
                        xinModel.scale = weakself.stufflistModel.scale;
                        xinModel.brand = weakself.stufflistModel.brand;
                        xinModel.isCunzai = NO;
                        xinModel.spec = weakself.stufflistModel.spec;
                        xinModel.selectBrandDict = weakself.stufflistModel.selectBrandDict;
                        xinModel.selectsSpecDict = weakself.stufflistModel.selectsSpecDict;

                        [weakself.addSepcArray addObject:weakself.stufflistModel];

                    } else {
                        NSString *selectStr = @"";
                        if ([dict[@"array"] count] > 0) {
                            NSArray *array1 = dict[@"array"];
                            NSMutableArray *idArray = [NSMutableArray array];
                            for (SpecGuigeModel *model in array1) {
                                [idArray addObject:@(model.stuff_spec_id)];
                            }
                            selectStr = [idArray componentsJoinedByString:@","];
                        }
                        NSDictionary *list = @{
                            @"stuff_spec_id": selectStr,
                            @"number": dict[@"number"],
                            @"name": dict[@"name"],
                            @"array": dict[@"array"]
                        };
                        weakself.stufflistModel.selectsSpecDict = list;
                        StuffListModel *xinModel = [[StuffListModel alloc] init];
                        xinModel.stuff_name = weakself.stufflistModel.stuff_name;
                        xinModel.image = weakself.stufflistModel.image;
                        xinModel.auto_type = weakself.stufflistModel.auto_type;
                        xinModel.auto_count = weakself.stufflistModel.auto_count;
                        xinModel.stuff_id = weakself.stufflistModel.stuff_id;
                        xinModel.auto_integer = weakself.stufflistModel.auto_integer;
                        xinModel.scale = weakself.stufflistModel.scale;
                        xinModel.brand = weakself.stufflistModel.brand;
                        xinModel.spec = weakself.stufflistModel.spec;
                        xinModel.isCunzai = YES;
                        xinModel.selectBrandDict = weakself.stufflistModel.selectBrandDict;
                        xinModel.selectsSpecDict = weakself.stufflistModel.selectsSpecDict;

                        [weakself.addSepcArray addObject:xinModel];
                    }
                }
            } else {
                for (NSDictionary *dict in array) {

                    NSArray *array1 = dict[@"array"];
                    NSString *selectStr = @"";
                    NSMutableArray *idArray = [NSMutableArray array];
                    for (SpecGuigeModel *model in array1) {
                        [idArray addObject:@(model.stuff_spec_id)];
                    }
                    selectStr = [idArray componentsJoinedByString:@","];
                    NSDictionary *temp = @{
                        @"stuff_spec_id": selectStr,
                        @"number": dict[@"number"],
                        @"name": dict[@"name"],
                        @"array": dict[@"array"]
                    };
                    weakself.stufflistModel.selectsSpecDict = temp;
                    StuffListModel *xinModel = [[StuffListModel alloc] init];
                    xinModel.stuff_name = weakself.stufflistModel.stuff_name;
                    xinModel.image = weakself.stufflistModel.image;
                    xinModel.auto_type = weakself.stufflistModel.auto_type;
                    xinModel.auto_count = weakself.stufflistModel.auto_count;
                    xinModel.stuff_id = weakself.stufflistModel.stuff_id;
                    xinModel.auto_integer = weakself.stufflistModel.auto_integer;
                    xinModel.scale = weakself.stufflistModel.scale;
                    xinModel.brand = weakself.stufflistModel.brand;
                    xinModel.spec = weakself.stufflistModel.spec;
                    xinModel.isCunzai = YES;
                    xinModel.selectBrandDict = weakself.stufflistModel.selectBrandDict;
                    xinModel.selectsSpecDict = weakself.stufflistModel.selectsSpecDict;
                    [weakself.addSepcArray addObject:xinModel];

                    [weakself.selectSpecData addObject:dict];
                }
            }
         
            for (StuffListModel *xinModel in weakself.addSepcArray) {
                if (xinModel.isCunzai) {
                     [weakself.selectedCailiao addObject:xinModel];
                } else {
                    for (int i = 0; i < weakself.selectedCailiao.count; i++) {
                        StuffListModel *temp = weakself.selectedCailiao[i];
                        if ([temp.selectsSpecDict[@"stuff_spec_id"] isEqualToString:xinModel.selectsSpecDict[@"stuff_spec_id"]]) {
                            int number = [xinModel.selectsSpecDict[@"number"] intValue];
                            number += 1;
                            NSDictionary *dict = @{
                                @"stuff_spec_id": temp.selectsSpecDict[@"stuff_spec_id"],
                                @"number": @(number),
                                @"name": temp.selectsSpecDict[@"name"],
                                @"array": temp.selectsSpecDict[@"array"],
                            };
                            temp.selectsSpecDict = dict;
                            [weakself.selectedCailiao replaceObjectAtIndex:i withObject:temp];
                        }
                    }
                }
            }

            weakself.number = weakself.selectedCailiao.count;
            [weakself.cailiaoDanTableView reloadData];
            [weakself.tableView reloadData];

            [weakself.selectSpecView.tableView reloadData];

            CGRect rect = [weakself.tableView rectForRowAtIndexPath:weakself.index];
            /// 获取当前cell 相对于self.view 当前的坐标
            rect.origin.y = rect.origin.y + weakself.tableView.frame.origin.y;
            CGRect imageViewRect = weakself.selectCell.addBtn.frame;
            imageViewRect.origin.y = rect.origin.y + imageViewRect.origin.y;
            imageViewRect.origin.x = CGRectGetMaxX(weakself.selectCell.addBtn.frame);

            [[PurchaseCarAnimationTool shareTool] startAnimationandView:weakself.selectCell.addBtn.imageView
                                                                   rect:imageViewRect
                                                            finisnPoint:CGPointMake(ViewWidth / 4, ViewHeight - 100)
                                                            finishBlock:^(BOOL finish) {
                                                                
                                                                [PurchaseCarAnimationTool shakeAnimation:weakself.cartBtn];
                                                            }];
        };
        _selectSpecView.deleteBlock = ^{
            weakself.selectSpecView = nil;
        };
    }
    
    return _selectSpecView;
}
//此时的懒加载已经废弃
- (CZHTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[CZHTagsView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth - 60, 0) style:CZHTagsViewStyleDefault selectMode:CZHTagsViewSelectModeSingle];
        _tagsView.backgroundColor = [UIColor whiteColor];
        _tagsView.dataSource = self;
        _tagsView.delegate = self;
    }
    return _tagsView;
}
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _scrollView.contentSize = CGSizeMake(ViewWidth, ViewHeight);
    }
    return _scrollView;
}
@end
