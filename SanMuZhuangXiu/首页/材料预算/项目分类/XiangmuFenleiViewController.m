//
//  XiangmuFenleiViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/4.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "XiangmuFenleiViewController.h"
#import "GuanlianCailiaoViewController.h"
#import "XiangmuFenleiCell.h"
#import "ReLayoutButton.h"
#import "StoreDetailViewController.h"
#import "ImgTitleCCell.h"
#import "MyPingJiaImgCollectionViewCell.h"
#import "PPNumberButton.h"
#import "CailiaoViewCell.h"
#import "stuffProjectModel.h"
#import "ProjectModel.h"
#import "ProjectListModel.h"
#import "PinpaiModel.h"
#import "GuigeModel.h"
#import "FilePathManager.h"
#import "CZHTagsView.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "PurchaseCarAnimationTool.h"
#import "AddressManagerViewController.h"
#import "AddressModel.h"
#import "SelectSpecView.h"
#import "SpecGuigeModel.h"

static NSString *const imgCellId = @"imgCellId";

@interface XiangmuFenleiViewController () <CZHTagsViewDelegate, CZHTagsViewDataSource, PPNumberButtonDelegate> {
    FilePathManager *filemanager;
}

@property (strong, nonatomic) IBOutlet UIView *selectedcailiaoBtnView;
@property (weak, nonatomic) IBOutlet UITableView *selectedCailiaoTableView;
@property (strong, nonatomic) IBOutlet UIView *zidingyicailiaoView;
@property (weak, nonatomic) IBOutlet UITextField *cailiaoNameTF;
@property (weak, nonatomic) IBOutlet UITextField *cailiaoGuigeTF;
@property (weak, nonatomic) IBOutlet PPNumberButton *ppnumBtn;
//规格
@property (strong, nonatomic) IBOutlet UIView *guigeView;
@property (weak, nonatomic) IBOutlet UIView *guigeBgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeVIewHeight;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layoutConstraint;
@property (weak, nonatomic) IBOutlet UITableView *classTableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITextField *searchTF;
@property (strong, nonatomic) IBOutlet UIView *tableFootView;
@property (nonatomic, strong) ProjectListModel *projectListModel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextField *cailiaodanNameText;
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressBtn;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (weak, nonatomic) IBOutlet UIButton *cartBtn;

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) NSInteger btnNumber;
@property (nonatomic, assign) NSInteger cailiaoId;
@property (nonatomic, assign) NSInteger stuffId;
@property (nonatomic, assign) NSInteger projectId;
@property (nonatomic, assign) int addressId;
@property (nonatomic, strong) NSIndexPath *index;
@property (nonatomic) NSInteger page;

@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
@property (nonatomic, strong) SelectSpecView *selectSpecView;
@property (strong, nonatomic) CZHTagsView *tagsView;
@property (nonatomic, strong) XiangmuFenleiCell *selectCell;

@property (nonatomic, strong) NSMutableArray *selectSpecData;
@property (strong, nonatomic) NSMutableArray *array;
@property (strong, nonatomic) NSArray *classDataArray;
@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *addSepcArray;
@property (assign, nonatomic) NSInteger classSelectIndex;
@property (assign, nonatomic) NSInteger selectIndex;
@property (nonatomic, strong) NSMutableArray *pinpaiArray;
@property (nonatomic, strong) NSMutableArray *guigeArray;
@property (nonatomic, strong) NSArray *selectTagArray;
@property (strong, nonatomic) NSMutableArray *selectedDataArray;
@property (nonatomic, strong) NSMutableArray *selectedCailiao;

@end

@implementation XiangmuFenleiViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar
        setBackgroundImage:[UIImage new]
             forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self getTotalClassDataArrayFromServerRefresh:YES];
}
- (void)viewWillDisappear:(BOOL)animated {

    [self.navigationController.navigationBar
        setBackgroundImage:nil
             forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"项目分类";

    [[DZTools getAppDelegate].locationManager startUpdatingLocation];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYYMMddHHmm"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    self.cailiaodanNameText.placeholder = currentTimeString;

    [self initData];

    [self initCollectionView];
    [self initTableView];
    //   [self loadAddress];
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"xuanzeSpec" object:nil];
}
#pragma mark – UI

- (void)initCollectionView {
    UICollectionViewFlowLayout *layout =
        [[UICollectionViewFlowLayout alloc] init];
    CGFloat width = (ViewWidth - 60) / 5;
    layout.itemSize = CGSizeMake(width, 50);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(0, 10, 0, 10);

    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerClass:[ImgTitleCCell class]
            forCellWithReuseIdentifier:imgCellId];
}

- (void)initTableView {
    //    self.classTableView.jh_showNoDataEmptyView = YES;

    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.classTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self getTotalClassDataArrayFromServerRefresh:YES];
    }];
    self.tableView.mj_footer =
        [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            NSLog(@"上拉加载更多");
            [self loadMore];
        }];
    [self.tableView registerNib:[UINib nibWithNibName:@"XiangmuFenleiCell"
                                               bundle:nil]
         forCellReuseIdentifier:@"XiangmuFenleiCell"];
    [self.tableView.mj_header beginRefreshing];

    //    self.tableFootView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 44);
    //    self.tableView.tableFooterView = self.tableFootView;

    [self.selectedCailiaoTableView
                   registerNib:[UINib nibWithNibName:@"CailiaoViewCell"
                                              bundle:nil]
        forCellReuseIdentifier:@"CailiaoViewCell"];
}

#pragma mark – Network

- (void)refresh {

    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getTotalClassDataArrayFromServerRefresh:(BOOL)isRefresh {

    [DZNetworkingTool getWithUrl:kGetProject
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.classTableView.mj_header endRefreshing];
            [self.classTableView.mj_footer endRefreshing];
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = [responseObject objectForKey:@"data"];
                NSArray *arr = [dict objectForKey:@"stuff_project"];
                NSLog(@"-----------%@", dict);
                [self.array removeAllObjects];
                for (NSDictionary *dict in arr) {
                    stuffProjectModel *model =
                        [stuffProjectModel mj_objectWithKeyValues:dict];

                    [self.array addObject:model];
                }
                [self.collectionView reloadData];
                self.classDataArray = nil;
                if (self.array.count > 0) {

                    stuffProjectModel *model = self.array[0];
                    if (model.project.count>0) {
                        self.classDataArray = model.project;
                        
                        ProjectModel *cailiaomodel =
                        [ProjectModel mj_objectWithKeyValues:model.project[0]];
                        self.projectId = cailiaomodel.project_id;
                        [self getDataArrayFromServerIsRefresh:YES];
                    }
                  
                }
                [self.classTableView reloadData];
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [self.classTableView.mj_header endRefreshing];
            [self.classTableView.mj_footer endRefreshing];
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}

- (void)loadMore {
    //    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}

- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {

    NSDictionary *dict = @{

        @"limit": @(8),
        @"project_id": @(self.projectId),
        @"page": @(_page)
    };
    [DZNetworkingTool postWithUrl:kGetProjectList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                /// 判断数据时候为null
                if ([[responseObject objectForKey:@"data"][@"stuff_list"]
                        isEqual:[NSNull null]]) {
                    [self.dataArray removeAllObjects];
                    [self.tableView reloadData];
                } else {
                    NSArray *array =
                        [responseObject objectForKey:@"data"][@"stuff_list"];

                    //判断是否刷新
                    if (isRefresh) {
                        [self.dataArray removeAllObjects];
                    }
                    for (NSDictionary *dict1 in array) {

                        ProjectListModel *model =
                            [ProjectListModel mj_objectWithKeyValues:dict1];

                        [self.dataArray addObject:model];
                    }
                    [self.tableView reloadData];
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:1];
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark - <UITextFieldDelegate>
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.searchTF resignFirstResponder];
    if (textField.text.length == 0) {
        [DZTools showNOHud:@"搜索内容不能为空" delay:2];

    } else {
        NSDictionary *dict = @{
            @"limit": @(8),
            @"project_id": @(self.projectId),
            @"page": @(1),
            @"search": self.searchTF.text
        };
        [DZNetworkingTool postWithUrl:kGetProjectList
            params:dict
            success:^(NSURLSessionDataTask *task, id responseObject) {
                [self.tableView.mj_header endRefreshing];
                [self.tableView.mj_footer endRefreshing];
                //判断数据是否为null
                if ([responseObject[@"code"] intValue] == SUCCESS) {
                    if ([[responseObject objectForKey:@"data"][@"stuff_list"]
                            isEqual:[NSNull null]]) {
                        [self.dataArray removeAllObjects];
                        [self.tableView reloadData];
                    } else {
                        NSArray *array =
                            [responseObject objectForKey:@"data"][@"stuff_list"];

                        NSLog(@"-----------%@", responseObject);

                        [self.dataArray removeAllObjects];

                        for (NSDictionary *dict1 in array) {

                            ProjectListModel *model =
                                [ProjectListModel mj_objectWithKeyValues:dict1];

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
#pragma mark - <UICollectionViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInCollectionView:
    (UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImgTitleCCell *cell =
        [collectionView dequeueReusableCellWithReuseIdentifier:imgCellId
                                                  forIndexPath:indexPath];
    stuffProjectModel *dict = self.array[indexPath.row];
    cell.textLabel.text = dict.name;
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, dict.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    if (self.classSelectIndex == indexPath.row) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, dict.selectimage]] placeholderImage:[UIImage imageNamed:@"default_pre"]];
    }
    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView
    didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //    [self.classDataArray removeAllObjects];
    stuffProjectModel *dict1 = self.array[self.classSelectIndex];
    stuffProjectModel *dict2 = self.array[indexPath.row];

    ImgTitleCCell *selectCell = (ImgTitleCCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.classSelectIndex inSection:0]];
    [selectCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, dict1.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    ImgTitleCCell *cell = (ImgTitleCCell *) [collectionView cellForItemAtIndexPath:indexPath];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, dict2.selectimage]] placeholderImage:[UIImage imageNamed:@"default_pre"]];
    self.classSelectIndex = indexPath.row;
    self.classDataArray = nil;

    self.classDataArray = dict2.project;
    [self.classTableView reloadData];

    [self.dataArray removeAllObjects];
    [self.tableView reloadData];
    ///判断classDataArray大于0,刷新tableview数据
    if (self.classDataArray.count > 0) {

        ProjectModel *cailiaomodel =
            [ProjectModel mj_objectWithKeyValues:self.classDataArray[0]];
        self.projectId = cailiaomodel.project_id;
        [self getDataArrayFromServerIsRefresh:YES];
        self.tableFootView.hidden = NO;

    } else {

        self.tableFootView.hidden = YES;
    }
}

#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView
    numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.classTableView) {
        return self.classDataArray.count;
    } else if (tableView == self.selectedCailiaoTableView) {

        return self.selectedCailiao.count;
    } else {

        return self.dataArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView
    heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        return 50;
    } else if (tableView == self.selectedCailiaoTableView) {
        return 80;
    } else {
        return 55;
    }
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView
    heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {
        static NSString *cellIdentifier = @"classCell";
        UITableViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:cellIdentifier];
        }

        if (self.selectIndex == indexPath.row) {
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font =
                [UIFont systemFontOfSize:14
                                  weight:UIFontWeightBold];
            [tableView selectRowAtIndexPath:indexPath
                                   animated:NO
                             scrollPosition:UITableViewScrollPositionNone];

        } else {
            cell.textLabel.textColor = UIColorFromRGB(0x666666);
            cell.textLabel.font =
                [UIFont systemFontOfSize:14
                                  weight:UIFontWeightRegular];
        }

        ProjectModel *model = [ProjectModel
            mj_objectWithKeyValues:self.classDataArray[indexPath.row]];

        cell.textLabel.text = model.name;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;

        return cell;
    } else if (tableView == self.selectedCailiaoTableView) {

        CailiaoViewCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"CailiaoViewCell"
                                            forIndexPath:indexPath];
        ProjectListModel *model = self.selectedCailiao[indexPath.row];
        cell.nameLabel.text = model.stuff_name;
        cell.ppnumBtn.currentNumber = [model.selectsSpecDict[@"number"] intValue];
        cell.guigeLabel.text = model.selectsSpecDict[@"name"];
        if (model.selectBrandDict.count == 0) {
            cell.pinpaiLabel.text = @"";
        } else {
            cell.pinpaiLabel.text = [NSString stringWithFormat:@"(%@)", model.selectBrandDict[@"name"]];
        }

        cell.numBlock = ^(CGFloat num) {

            NSDictionary *dict = @{
                @"stuff_spec_id": model.selectsSpecDict[@"stuff_spec_id"],
                @"number": @(num),
                @"name": model.selectsSpecDict[@"name"]
            };

            model.selectsSpecDict = dict;

            [self.selectedCailiao replaceObjectAtIndex:indexPath.row withObject:model];
            [self.selectSpecData replaceObjectAtIndex:indexPath.row withObject:dict];

            if (num == 0) {
                [self.selectedCailiao removeObjectAtIndex:indexPath.row];
                [self.selectSpecData removeObjectAtIndex:indexPath.row];
                self.number = self.selectedCailiao.count;
            }
            [self.selectSpecView.tableView reloadData];
            [self.tableView reloadData];
            [self.selectedCailiaoTableView reloadData];
        };
        return cell;

    } else {
        XiangmuFenleiCell *cell =
            [tableView dequeueReusableCellWithIdentifier:@"XiangmuFenleiCell"
                                            forIndexPath:indexPath];

        ProjectListModel *cailiaomodel = self.dataArray[indexPath.row];

        NSString *nameStr = cailiaomodel.stuff_name;
        if (nameStr.length == 0 || [nameStr isEqualToString:@"null"]) {
            nameStr = @"材料名";
        }
        cell.nameLabel.text = nameStr;
        cell.addBtn.hidden = NO;
        cell.yixuanBtn.hidden = YES;

        for (int i = 0; i < self.selectedCailiao.count; i++) {
            ProjectListModel *model = self.selectedCailiao[i];
            if (model.stuff_id == cailiaomodel.stuff_id) {
                if ([[model.selectBrandDict allKeys] count] != 0) {
                    cell.pinpaiText.text = model.selectBrandDict[@"name"];
                }
                if ([[model.selectsSpecDict allKeys] count] != 0) {
                    cell.addBtn.hidden = YES;
                    cell.yixuanBtn.hidden = NO;
                }
                break;
            }
        }

        __weak typeof(XiangmuFenleiCell *) weakself = cell;

        cell.pinpaiBlock = ^{

            [self.pinpaiArray removeAllObjects];
            self.projectListModel = cailiaomodel;
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
            self.projectListModel = cailiaomodel;
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
            [self.selectSpecData removeAllObjects];
            for (int i = 0; i < self.selectedCailiao.count; i++) {
                ProjectListModel *model = self.selectedCailiao[i];
                if (model.stuff_id == cailiaomodel.stuff_id) {

                    [self.selectSpecData addObject:model.selectsSpecDict];
                }
            }

            self.selectSpecView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
            self.selectSpecView.dataArray = self.guigeArray;
            self.selectSpecView.selectDataArray = self.selectSpecData;
            self.selectSpecView.tebleViewHeight.constant = self.guigeArray.count * 50;
            [self.selectSpecView.guigetableView reloadData];
            [self.selectSpecView.tableView reloadData];
            [[DZTools getAppWindow] addSubview:self.selectSpecView];

        };
        cell.numBlock = ^(CGFloat num) {
            self.projectListModel = cailiaomodel;
            self.projectListModel.number = num;
            int index = 0;
            for (int i = 0; i < self.selectedCailiao.count; i++) {
                ProjectListModel *model = self.selectedCailiao[i];
                if (model.stuff_id == cailiaomodel.stuff_id) {
                    index = i;
                    break;
                }
            }
            [self.selectedCailiao replaceObjectAtIndex:index
                                            withObject:self.projectListModel];
            if (num == 0) {
                [self.selectedCailiao removeObjectAtIndex:index];
                self.number = self.selectedCailiao.count;
            }
            [self.selectedCailiaoTableView reloadData];
            [self.tableView reloadData];
        };

        cell.tianjiaBlock = ^{
            /////////////修改前
            //            self.selectCell=weakself;
            //            self.index=indexPath;
            //
            //            self.selectTagArray = nil;
            //            self.projectListModel = cailiaomodel;
            //            [self.guigeArray removeAllObjects];
            //            NSArray *guiTempArray = cailiaomodel.spec;
            //
            //            for (NSDictionary *guigeDict in guiTempArray) {
            //                GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];
            //
            //                [self.guigeArray addObject:guigeModel];
            //            }
            //
            //            [self.guigeBgView addSubview:self.tagsView];
            //            [self.tagsView reloadData];
            //            self.guigeView.frame = [DZTools getAppWindow].bounds;
            //            [[DZTools getAppWindow] addSubview:self.guigeView];

            /////////////修改前

            self.selectCell = weakself;
            self.index = indexPath;

            self.projectListModel = cailiaomodel;
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
            self.selectSpecView.dataArray = self.guigeArray;
            //            self.selectSpecView.selectDataArray = self.selectSpecData;
            [self.selectSpecView.selectDataArray removeAllObjects];
            self.selectSpecView.tebleViewHeight.constant = self.guigeArray.count * 50;
            [self.selectSpecView.guigetableView reloadData];
            [self.selectSpecView.tableView reloadData];
            [[DZTools getAppWindow] addSubview:self.selectSpecView];

        };

        return cell;
    }
}

- (void)tableView:(UITableView *)tableView
    didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.classTableView) {

        if (self.selectIndex != indexPath.row) {
            UITableViewCell *selectCell = [tableView
                cellForRowAtIndexPath:[NSIndexPath indexPathForRow:self.selectIndex
                                                         inSection:0]];
            selectCell.textLabel.textColor = UIColorFromRGB(0x666666);
            selectCell.textLabel.font =
                [UIFont systemFontOfSize:14
                                  weight:UIFontWeightRegular];
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.textLabel.textColor = UIColorFromRGB(0x333333);
            cell.textLabel.font =
                [UIFont systemFontOfSize:14
                                  weight:UIFontWeightBold];

            self.selectIndex = indexPath.row;

            ProjectModel *model = [ProjectModel
                mj_objectWithKeyValues:self.classDataArray[indexPath.row]];
            self.stuffId = model.stuff_work_id;
            if (self.classDataArray.count == 1) {
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            } else {

                self.projectId = model.project_id;
                [self getDataArrayFromServerIsRefresh:YES];
            }
        }

    } else {
    }
}
#pragma mark-- CZHTagsViewDelegateCZHTagsViewDataSource
- (NSArray *)czh_tagsArrayInTagsView:(CZHTagsView *)tagsView {
    NSMutableArray *nameArray = [NSMutableArray array];
    for (GuigeModel *dict in self.guigeArray) {
        [nameArray addObject:dict.spec_name];
    }

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
- (void)czh_tagsView:(CZHTagsView *)tagsView
    didSelectItemWithSelectTagsArray:(NSArray *)selectTagsArray {

    self.selectTagArray = selectTagsArray;
}
- (void)czh_tagsViewWithHeigth:(CGFloat)selfHeight;
{
    self.guigeVIewHeight.constant = selfHeight + 10;
}

#pragma mark - Function
//自定义品牌
- (void)zidingyipinpai {
    UIAlertController *alertController =
        [UIAlertController alertControllerWithTitle:nil
                                            message:@"自定义品牌"
                                     preferredStyle:UIAlertControllerStyleAlert];
    //定义第一个输入框；
    [alertController
        addTextFieldWithConfigurationHandler:^(UITextField *_Nonnull textField) {
            textField.placeholder = @"请自定义品牌";
        }];
    //增加取消按钮；
    [alertController
        addAction:[UIAlertAction
                      actionWithTitle:@"取消"
                                style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *_Nonnull action){

                              }]];
    //增加确定按钮；
    [alertController
        addAction:[UIAlertAction
                      actionWithTitle:@"确定"
                                style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction *_Nonnull action) {
                                  //获取第1个输入框；
                                  UITextField *textField = alertController.textFields.firstObject;
                                  [self sendMessage:textField.text];
                              }]];
    [self presentViewController:alertController animated:true completion:nil];
}
- (void)sendMessage:(NSString *)messsage {

    NSString *stuff = [NSString stringWithFormat:@"%ld", self.cailiaoId];
    NSDictionary *dict = @{
        @"stuff_id": stuff,
        @"brand_name": messsage

    };

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
- (void)alertPinpaiViewWithcellView:(XiangmuFenleiCell *)cell {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"请选择品牌类型"
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.pinpaiArray.count; i++) {
        PinpaiModel *typeModel = self.pinpaiArray[i];
        NSString *nameStr = @"";
        NSString *name = typeModel.name;

        if ([name isKindOfClass:[NSNull class]] || name == nil) {
            nameStr = @"品牌";
        } else {
            nameStr = name;
        }

        [alert addAction:[UIAlertAction
                             actionWithTitle:nameStr
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *_Nonnull action) {
                                         [self alertXinziClick:i intoCell:cell];
                                     }]];
    }
    [alert addAction:[UIAlertAction
                         actionWithTitle:@"自定义品牌"
                                   style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self zidingyipinpai];
                                 }]];
    [alert addAction:[UIAlertAction
                         actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self alertXinziClick:self.pinpaiArray.count
                                                  intoCell:cell];
                                 }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}

- (void)alertXinziClick:(NSInteger)rowInteger
               intoCell:(XiangmuFenleiCell *)cell;
{
    cell.pinpaiText.text = @"";
    if (rowInteger < self.pinpaiArray.count) {

        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];

        cell.pinpaiText.text = typeModel.name;
        self.projectListModel.selectBrandDict = @{
            @"stuff_brand_id": @(typeModel.stuff_brand_id),
            @"stuff_id": @(typeModel.stuff_brand_id),
            @"name": typeModel.name
        };
    }
    int index = -1;
    for (int i = 0; i < self.selectedCailiao.count; i++) {
        ProjectListModel *model = self.selectedCailiao[i];
        if (model.stuff_id == self.projectListModel.stuff_id) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [self.selectedCailiao replaceObjectAtIndex:index
                                        withObject:self.projectListModel];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];

    if ([dic[@"title"] isEqualToString:@"spce"]) {

        self.number = 0;
        [self.selectedCailiao removeAllObjects];
        [self.selectedCailiaoTableView reloadData];
        [self.tableView reloadData];
    }
}

- (void)initData {
    self.btnNumber = 1;
    self.classDataArray = [NSArray array];
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    self.array = [NSMutableArray arrayWithCapacity:0];
    self.selectedDataArray = [NSMutableArray arrayWithCapacity:0];
    self.classSelectIndex = 0;
    self.selectTagArray = [NSArray array];
    self.guigeArray = [NSMutableArray array];
    self.selectedCailiao = [NSMutableArray array];
    self.pinpaiArray = [NSMutableArray array];
    self.addSepcArray = [NSMutableArray array];

    self.selectSpecData = [NSMutableArray array];
}

#pragma mark - XibFunction
//自定义材料
- (IBAction)zidingyicailiao:(id)sender {
    self.ppnumBtn.stepValue = 1;
    self.ppnumBtn.currentNumber = 1;

    self.zidingyicailiaoView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
    [[DZTools getAppWindow] addSubview:self.scrollView];
    [self.scrollView addSubview:self.zidingyicailiaoView];
}
//取消点击
- (IBAction)selectedCancelClicked:(id)sender {

    [self.selectedcailiaoBtnView removeFromSuperview];
}
- (IBAction)orderCancelClicked:(id)sender {
    [self.CailiaodanView removeFromSuperview];
    [self.scrollView removeFromSuperview];
}

//取消
- (IBAction)cancleBtnClicked:(id)sender {

    if (self.cailiaoNameTF.isFirstResponder || self.cailiaoGuigeTF.isFirstResponder) {
        [self.cailiaoNameTF endEditing:YES];
        [self.cailiaoGuigeTF endEditing:YES];
    } else {
        [self.scrollView removeFromSuperview];
    }
}
//确定自定义材料
- (IBAction)commitBtnClicked:(id)sender {
    [self.zidingyicailiaoView removeFromSuperview];
    [self.scrollView removeFromSuperview];

    NSString *stuff = [NSString stringWithFormat:@"%ld", self.stuffId];
    NSDictionary *dict = @{
        @"stuff_category_id": stuff,
        @"name": self.cailiaoNameTF.text,
        @"spec_name": self.cailiaoGuigeTF.text
    };
    [DZNetworkingTool postWithUrl:kApplyStuff
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
//已选材料点击
- (IBAction)selectedClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.selectedcailiaoBtnView.frame = self.view.bounds;
        [self.view insertSubview:self.selectedcailiaoBtnView belowSubview:self.bottomView];
    } else {
        [self.selectedcailiaoBtnView
                removeFromSuperview];
    }
    //    self.ppnumBtn.stepValue = 1;

    //    [[DZTools getAppWindow] addSubview:self.selectedcailiaoBtnView];
}

- (IBAction)shengchengOrderClick:(id)sender {
    if (self.selectedCailiao.count <= 0) {
        [DZTools showNOHud:@"您还没有选择材料" delay:2];
        [self.selectedcailiaoBtnView removeFromSuperview];
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

        self.CailiaodanView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.CailiaodanView];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;

        [self.selectedcailiaoBtnView removeFromSuperview];
    }
}

- (IBAction)sureClicked:(id)sender {
    [self.CailiaodanView removeFromSuperview];
    [self.scrollView removeFromSuperview];

    //    double latitude = [DZTools getAppDelegate].latitude;
    //    double longitude = [DZTools getAppDelegate].longitude;
    NSMutableArray *tempArray = [NSMutableArray array];

    if (self.cailiaodanNameText.text.length == 0) {
        self.cailiaodanNameText.text = self.cailiaodanNameText.placeholder;
    }

    for (ProjectListModel *model in self.selectedCailiao) {
        if (model.selectBrandDict.count == 0) {
            [DZTools showNOHud:@"请选择品牌" delay:2];
            return;
        }

        [tempArray addObject:@{
            @"number": model.selectsSpecDict[@"number"],
            @"stuff_id": @(model.stuff_id),
            @"stuff_name": model.stuff_name,
            @"stuff_brand_id":
                [model.selectBrandDict objectForKey:@"stuff_brand_id"] == nil ? @"0" : [model.selectBrandDict objectForKey:@"stuff_brand_id"],
            @"stuff_brand_name": [model.selectBrandDict objectForKey:@"name"] == nil ? @"无品牌" : [model.selectBrandDict objectForKey:@"name"],
            @"stuff_spec_id": model.selectsSpecDict[@"stuff_spec_id"] == nil ? @"" : model.selectsSpecDict[@"stuff_spec_id"],
            //            @"stuff_spec_name": model.selectsSpecDict[@"name"] == nil ? @"" : model.selectsSpecDict[@"name"]
        }];
    }

    NSLog(@"-------%@", tempArray);
    NSDictionary *dict = @{
        @"name": self.cailiaodanNameText.text,
        //        @"address": @(self.addressId),
        //        @"lng": [NSString stringWithFormat:@"%lf", longitude],
        //        @"lat": [NSString stringWithFormat:@"%lf", latitude],
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
                [self.selectedCailiaoTableView reloadData];

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
}

//确定添加规格
- (IBAction)sureAddGuigeClick:(id)sender {

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

    [self.guigeView removeFromSuperview];
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

    self.projectListModel.selectsSpecDict = @{
        @"stuff_spec_id": @(stuff_spec_id),
        @"stuff_id": @(stuff_id),
        @"name": nameStr
    };
    self.projectListModel.number = 1;
    [self.selectedCailiao addObject:self.projectListModel];
    [self.selectedCailiaoTableView reloadData];
    self.number = self.selectedCailiao.count;
    [self.tableView reloadData];
}
- (IBAction)cancelAddClick:(id)sender {
    [self.guigeView removeFromSuperview];
}
- (IBAction)qingchuBtnCLick:(id)sender {

    self.number = 0;

    [self.selectedCailiao removeAllObjects];
    [self.selectSpecData removeAllObjects];

    [self.selectedCailiaoTableView reloadData];
    [self.tableView reloadData];

    [self.selectSpecView removeFromSuperview];
    [self.selectedcailiaoBtnView removeFromSuperview];
}
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
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _scrollView.contentSize = CGSizeMake(ViewWidth, ViewHeight);
    }
    return _scrollView;
}

- (SelectSpecView *)selectSpecView {
    if (!_selectSpecView) {
        _selectSpecView = [[SelectSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(XiangmuFenleiViewController *) weakself = self;

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

                        weakself.projectListModel.selectsSpecDict = list;
                        ProjectListModel *xinModel = [[ProjectListModel alloc] init];
                        xinModel.stuff_name = weakself.projectListModel.stuff_name;
                        xinModel.image = weakself.projectListModel.image;
                        xinModel.auto_type = weakself.projectListModel.auto_type;
                        xinModel.auto_count = weakself.projectListModel.auto_count;
                        xinModel.stuff_id = weakself.projectListModel.stuff_id;
                        xinModel.auto_integer = weakself.projectListModel.auto_integer;
                        xinModel.scale = weakself.projectListModel.scale;
                        xinModel.brand = weakself.projectListModel.brand;
                        xinModel.spec = weakself.projectListModel.spec;
                        xinModel.isCunzai = NO;
                        xinModel.selectBrandDict = weakself.projectListModel.selectBrandDict;
                        xinModel.selectsSpecDict = weakself.projectListModel.selectsSpecDict;

                        [weakself.addSepcArray addObject:xinModel];

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
                        weakself.projectListModel.selectsSpecDict = list;
                        ProjectListModel *xinModel = [[ProjectListModel alloc] init];
                        xinModel.stuff_name = weakself.projectListModel.stuff_name;
                        xinModel.image = weakself.projectListModel.image;
                        xinModel.auto_type = weakself.projectListModel.auto_type;
                        xinModel.auto_count = weakself.projectListModel.auto_count;
                        xinModel.stuff_id = weakself.projectListModel.stuff_id;
                        xinModel.auto_integer = weakself.projectListModel.auto_integer;
                        xinModel.scale = weakself.projectListModel.scale;
                        xinModel.brand = weakself.projectListModel.brand;
                        xinModel.spec = weakself.projectListModel.spec;
                        xinModel.isCunzai = YES;
                        xinModel.selectBrandDict = weakself.projectListModel.selectBrandDict;
                        xinModel.selectsSpecDict = weakself.projectListModel.selectsSpecDict;
                        [weakself.addSepcArray addObject:xinModel];
                    }
                }

            } else {

                for (NSDictionary *dict in array) {
                    NSArray *array1 = dict[@"array"];
                    NSString *selectStr = @"";
                    NSMutableArray *idArray = [NSMutableArray array];
                    for (SpecGuigeModel *model in array1) {
                        //                        selectStr = [selectStr stringByAppendingFormat:@"%ld,", (long) model.stuff_spec_id];
                        [idArray addObject:@(model.stuff_spec_id)];
                    }
                    selectStr = [idArray componentsJoinedByString:@","];

                    weakself.projectListModel.selectsSpecDict = @{
                        @"stuff_spec_id": selectStr,
                        @"number": dict[@"number"],
                        @"name": dict[@"name"]
                    };
                    ProjectListModel *xinModel = [[ProjectListModel alloc] init];
                    xinModel.stuff_name = weakself.projectListModel.stuff_name;
                    xinModel.image = weakself.projectListModel.image;
                    xinModel.auto_type = weakself.projectListModel.auto_type;
                    xinModel.auto_count = weakself.projectListModel.auto_count;
                    xinModel.stuff_id = weakself.projectListModel.stuff_id;
                    xinModel.auto_integer = weakself.projectListModel.auto_integer;
                    xinModel.scale = weakself.projectListModel.scale;
                    xinModel.brand = weakself.projectListModel.brand;
                    xinModel.spec = weakself.projectListModel.spec;
                    xinModel.isCunzai = YES;
                    xinModel.selectBrandDict = weakself.projectListModel.selectBrandDict;
                    xinModel.selectsSpecDict = weakself.projectListModel.selectsSpecDict;
                    [weakself.addSepcArray addObject:xinModel];
                }

                [weakself.selectSpecData addObjectsFromArray:array];
            }
            for (ProjectListModel *xinModel in weakself.addSepcArray) {
                if (xinModel.isCunzai) {
                    [weakself.selectedCailiao addObject:xinModel];
                } else {
                    for (int i = 0; i < weakself.selectedCailiao.count; i++) {
                        ProjectListModel *temp = weakself.selectedCailiao[i];
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
            [weakself.selectedCailiaoTableView reloadData];
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
- (CZHTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView =
            [[CZHTagsView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth - 60, 0)
                                         style:CZHTagsViewStyleDefault];
        _tagsView.backgroundColor = [UIColor whiteColor];
        _tagsView.dataSource = self;
        _tagsView.delegate = self;
    }
    return _tagsView;
}
- (void)setNumber:(NSInteger)number {
    _number = number;
    
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", _number];
    self.totalLabel.text = [NSString stringWithFormat:@"共计：%ld种材料", (long) _number];
    if (number == 0) {
        self.numberLabel.hidden = YES;
        self.totalLabel.hidden = YES;
    } else {
        self.numberLabel.hidden = NO;
        self.totalLabel.hidden = NO;
    }
}
@end


