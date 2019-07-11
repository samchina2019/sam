//
//  ZIdongjisuanController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ZIdongjisuanController.h"

#import "EditSpecView.h"
#import "CZHTagsView.h"

#import "CailaodanEditCell.h"
#import "ImgTitleCCell.h"
#import "HeadTableViewCell.h"
#import "ProjectListModel.h"

#import "FilePathManager.h"
#import "TPKeyboardAvoidingScrollView.h"

#import "SpecGuigeModel.h"
#import "CartOrdeInfoModel.h"
#import "SubModel.h"
#import "StuffJisuanModel.h"
#import "StuffInfoModel.h"
#import "SpecModel.h"
#import "PinpaiModel.h"
#import "GuigeModel.h"
#import "AddressModel.h"

#import "CaiLiaoFenLeiViewController.h"
#import "AddressManagerViewController.h"
#import "GuanlianCailiaoViewController.h"

static NSString *imgCellId = @"imgCellId";
@interface ZIdongjisuanController () <CZHTagsViewDelegate, CZHTagsViewDataSource, PPNumberButtonDelegate> {
    FilePathManager *filemanager;
}
@property (nonatomic, retain) TPKeyboardAvoidingScrollView *scrollView;
@property (strong, nonatomic) CZHTagsView *tagsView;
@property (nonatomic, strong) ProjectListModel *stufflistModel;
@property (nonatomic, strong) SpecModel *specModel;
@property (nonatomic, strong) EditSpecView *editSpecView;

@property (weak, nonatomic) IBOutlet UIView *guigeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *guigeHeight;
@property (strong, nonatomic) IBOutlet UIView *guigeBgView;
@property (weak, nonatomic) IBOutlet UITextField *cailiaodanTextField;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITableView *headTableView;
@property (weak, nonatomic) IBOutlet UIButton *zinengjisuanBtn;
@property (weak, nonatomic) IBOutlet UITextField *gongchengliangTextField;
@property (weak, nonatomic) IBOutlet ReLayoutButton *addressBtn;
@property (strong, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *tongjiView;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *jisuanView;
@property (weak, nonatomic) IBOutlet UIView *gongchengView;
@property (strong, nonatomic) IBOutlet UIView *sectionFootView;
@property (weak, nonatomic) IBOutlet UIButton *xinzengBtn;
@property (weak, nonatomic) IBOutlet UIButton *shengchengBtn;
@property (weak, nonatomic) IBOutlet UILabel *NameLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhongleiLabel;
@property (weak, nonatomic) IBOutlet UILabel *cailiaoNumberLabel;

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectGuigeArray;
@property (nonatomic, strong) NSMutableArray *sectionArry;
@property (strong, nonatomic) NSMutableArray *array;
@property (nonatomic, strong) NSMutableArray *guigeArray;
@property (nonatomic, strong) NSMutableArray *pinpaiArray;
@property (nonatomic, strong) NSMutableArray *spcArray;
@property (nonatomic, strong) NSArray *selectTagArray;

/// 选中的类别
@property (assign, nonatomic) NSInteger classSelectIndex;
/// 规格名字
@property (nonatomic, strong) NSString *guigeName;
/// 第几个cell
@property (nonatomic, strong) NSIndexPath *index;
/// 选中第几个
@property (assign, nonatomic) NSInteger selectIndex;
///数量
@property (assign, nonatomic) int totalNumber;
///地址ID
@property (nonatomic, assign) int addressId;
///项目ID
@property (nonatomic, assign) int projectId;

@end

@implementation ZIdongjisuanController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    
    
    [self initView];
    [self getTotalClassDataArrayFromServer];
    [self initTableView];
    [self initData];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"YYYYMMddHHmm"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    self.cailiaodanTextField.placeholder = currentTimeString;
    [self initCollectionView];
    //    [self loadAddress];
    self.sectionArry = [NSMutableArray array];
    self.navigationItem.title = @"自动计算";
    UIView*backview=[[UIView alloc]initWithFrame:CGRectMake(0, SafeAreaTopHeight, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaTopHeight-SafeAreaBottomHeight)];
    backview.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:backview];
    UIImageView*backImg=[[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-100*SCREEN_WIDTH/750)/2, 180*SCREEN_WIDTH/750, 100*SCREEN_WIDTH/750,100*SCREEN_WIDTH/750)];
    [backImg setImage:[UIImage imageNamed:@"home_icon_budget"]];
    [backview addSubview:backImg];
    UILabel*backLab=[MTool quickCreateLabelWithleft:0 top:backImg.bottom+30*SCREEN_WIDTH/750 width:SCREEN_WIDTH heigh:44*SCREEN_WIDTH/750 title:@"功能正在开发中，请耐心等待"];
    backLab.textColor = [MTool colorWithHexString:@"#a9acb0"];
    backLab.font=[UIFont systemFontOfSize:28*SCREEN_WIDTH/750];
    backLab.textAlignment=NSTextAlignmentCenter;
    [backview addSubview:backLab];
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

    self.headView.frame = CGRectMake(0, 0, ViewWidth, 420);
    self.tableView.tableHeaderView = self.headView;
    self.bottomView.frame = CGRectMake(0, 0, self.tableView.bounds.size.width, 190);
    self.tableView.tableFooterView = self.bottomView;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    [self.headTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.headTableView.rowHeight = 50;
    self.tableView.rowHeight = 120;
    [self.headTableView registerNib:[UINib nibWithNibName:@"HeadTableViewCell" bundle:nil] forCellReuseIdentifier:@"HeadTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"CailaodanEditCell" bundle:nil] forCellReuseIdentifier:@"CailaodanEditCell"];
}

- (void)initView {
    //阴影的颜色
    self.jisuanView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.jisuanView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.jisuanView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.jisuanView.layer.shadowOffset = CGSizeMake(0, 0);
    self.jisuanView.layer.cornerRadius = 3;

    //阴影的颜色
    self.gongchengView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.gongchengView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.gongchengView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.gongchengView.layer.shadowOffset = CGSizeMake(0, 0);
    self.gongchengView.layer.cornerRadius = 3;

    //阴影的颜色
    self.tongjiView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.tongjiView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.tongjiView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.tongjiView.layer.shadowOffset = CGSizeMake(0, 0);
    self.tongjiView.layer.cornerRadius = 3;

    //设置边框的颜色
    [self.xinzengBtn.layer setBorderColor:[UIColor colorWithRed:63 / 255.0 green:174 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor];

    //设置边框的粗细
    [self.xinzengBtn.layer setBorderWidth:1.0];

    //设置圆角的半径
    [self.xinzengBtn.layer setCornerRadius:3];

    //切割超出圆角范围的子视图
    self.xinzengBtn.layer.masksToBounds = YES;
}

#pragma mark – Network

- (void)getTotalClassDataArrayFromServer {

    [DZNetworkingTool postWithUrl:kGetProjectAuto
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                NSDictionary *dict = [responseObject objectForKey:@"data"];
                NSArray *arr = [dict objectForKey:@"stuff_project"];
                NSLog(@"-----------%@", dict);
                [self.array removeAllObjects];
                for (NSDictionary *dict in arr) {
                    StuffJisuanModel *model = [StuffJisuanModel mj_objectWithKeyValues:dict];
                    [self.array addObject:model];
                }
                [self.collectionView reloadData];
                StuffJisuanModel *gongzhongModel2 = self.array[self.classSelectIndex];
                self.NameLabel.text = [NSString stringWithFormat:@"自动计算-%@", gongzhongModel2.name];
                self.headView.frame = (gongzhongModel2.spec.count > 0) ? (CGRectMake(0, 0, ViewWidth, 400 + (gongzhongModel2.spec.count) * 50)) : (CGRectMake(0, 0, ViewWidth, 400));
                self.tableView.tableHeaderView = self.headView;

                self.projectId = gongzhongModel2.project_id;
                [self.sectionArry removeAllObjects];
                NSArray *tempArray = gongzhongModel2.spec;
                for (NSDictionary *dict in tempArray) {
                    SpecModel *model = [SpecModel mj_objectWithKeyValues:dict];
                    [self.sectionArry addObject:model];
                }

                [self.headTableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];

                [self.tableView reloadData];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:RequestServerError delay:2.0];
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

    StuffJisuanModel *gongzhongModel = self.array[indexPath.row];

    cell.textLabel.text = gongzhongModel.name;

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];
    if (self.classSelectIndex == indexPath.row) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.image]] placeholderImage:[UIImage imageNamed:@"default_pre"]];
    }

    return cell;
}
// 选中某item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    StuffJisuanModel *gongzhongModel = self.array[self.classSelectIndex];
    StuffJisuanModel *gongzhongModel2 = self.array[indexPath.row];

    ImgTitleCCell *selectCell = (ImgTitleCCell *) [collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.classSelectIndex inSection:0]];

    [selectCell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel.image]] placeholderImage:[UIImage imageNamed:@"defaultImg"]];

    ImgTitleCCell *cell = (ImgTitleCCell *) [collectionView cellForItemAtIndexPath:indexPath];

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kIMageUrl, gongzhongModel2.image]] placeholderImage:[UIImage imageNamed:@"default_pre"]];
    self.classSelectIndex = indexPath.row;

    self.headView.frame = (gongzhongModel2.spec.count > 0) ? (CGRectMake(0, 0, ViewWidth, 400 + (gongzhongModel2.spec.count) * 50)) : (CGRectMake(0, 0, ViewWidth, 400));

    self.projectId = gongzhongModel2.project_id;
    self.NameLabel.text = [NSString stringWithFormat:@"自动计算-%@", gongzhongModel2.name];

    self.tableView.tableHeaderView = self.headView;
    [self.view layoutIfNeeded];

    [self.sectionArry removeAllObjects];
    NSArray *tempArray = gongzhongModel2.spec;

    for (NSDictionary *dict in tempArray) {
        SpecModel *model = [SpecModel mj_objectWithKeyValues:dict];
        [self.sectionArry addObject:model];
    }
    [self.headTableView reloadData];
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.headTableView) {
        return 1;
    }

    return (self.dataArray.count == 0) ? 0 : 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.headTableView) {
        return self.sectionArry.count;
    } else {

        return self.dataArray.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (tableView == self.headTableView) {
        return 0.01;
    } else {
        return 50;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (tableView == self.headTableView) {
        return 0.01;
    }
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {

    if (tableView == self.headTableView) {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        return view;
    } else {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sectionFootView.bounds.size.width, 50)];

        [view addSubview:self.sectionFootView];
        //    view.backgroundColor=[UIColor clearColor];
        return view;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.headTableView) {

        HeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeadTableViewCell"];
        SpecModel *model = self.sectionArry[indexPath.row];
        cell.guigeLabel.text = [NSString stringWithFormat:@"%@:", model.name];
        [self.guigeArray removeAllObjects];
        for (int i = 0; i < self.sectionArry.count; i++) {

            SpecModel *smodel = self.sectionArry[i];

            if (smodel.spec_id == model.spec_id) {
                if ([[model.selectSub allKeys] count] != 0) {
                    [cell.guigeBtn setTitle:smodel.selectSub[@"name"] forState:UIControlStateNormal];
                }
                break;
            }
        }

        cell.guigeBlock = ^{
            self.selectTagArray = nil;
            self.selectIndex = indexPath.row;
            NSArray *array = model.sub;

            [self.guigeArray removeAllObjects];

            for (NSDictionary *dict in array) {
                SubModel *subModel = [SubModel mj_objectWithKeyValues:dict];
                [self.guigeArray addObject:subModel];
            }

            [self.tagsView reloadData];

            [self.guigeView addSubview:self.tagsView];
            self.guigeBgView.frame = [DZTools getAppWindow].bounds;
            [[DZTools getAppWindow] addSubview:self.guigeBgView];
        };

        return cell;
    } else {
        CailaodanEditCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CailaodanEditCell"];
        cell.contentView.backgroundColor = [UIColor whiteColor];
        cell.guigeBtn.userInteractionEnabled = YES;
        cell.pinpaiBtn.userInteractionEnabled = YES;
        cell.numberBtn.userInteractionEnabled = YES;
        ProjectListModel *model = self.dataArray[indexPath.row];

        cell.nameLabel.text = model.stuff_name;

        if (model.selectBrandDict.count != 0) {
            [cell.pinpaiBtn setTitle:[NSString stringWithFormat:@"%@", model.selectBrandDict[@"name"]] forState:UIControlStateNormal];
        } else {
        }

        if (model.selectsSpecDict.count != 0) {
            [cell.guigeBtn setTitle:[NSString stringWithFormat:@"%@", model.selectsSpecDict[@"name"]] forState:UIControlStateNormal];
        } else {
        }
        if (model.number != 0) {
            cell.numberBtn.currentNumber = model.number;
        } else {

            if (self.gongchengliangTextField.text.length == 0) {
                self.gongchengliangTextField.text = @"1";
            }
            if (model.auto_type == 1) {
                if (model.auto_integer == 1) {
                    cell.numberBtn.currentNumber = model.auto_count;
                }

            } else if (model.auto_type == 2) {
                if (model.auto_integer == 1) {
                    cell.numberBtn.currentNumber = ceilf([self.gongchengliangTextField.text intValue] * model.auto_count);
                } else {
                    cell.numberBtn.currentNumber = [self.gongchengliangTextField.text intValue] * model.auto_count;
                }
            }

            model.number = cell.numberBtn.currentNumber;
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
        }
        __weak typeof(CailaodanEditCell *) weakself = cell;
        cell.moreBlock = ^{
            //删除
            [self.dataArray removeObjectAtIndex:indexPath.row];
            [self.tableView reloadData];

        };
        cell.numBlock = ^(CGFloat num) {
            weakself.numberBtn.currentNumber = num;
            self.totalNumber += 1;
            model.number = num;
            [self.dataArray replaceObjectAtIndex:indexPath.row withObject:model];
            [self.tableView reloadData];
        };
        cell.pinpaiBlock = ^{
            
            self.stufflistModel = model;
            [self.pinpaiArray removeAllObjects];

            NSArray *tempArray = model.brand;
            for (NSDictionary *pinpaiDict in tempArray) {
                PinpaiModel *pinModel = [PinpaiModel mj_objectWithKeyValues:pinpaiDict];
                [self.pinpaiArray addObject:pinModel];
            }

            [self alertPinpaiViewWithcellView:weakself];
        };
        cell.guigeBlock = ^{
            self.editSpecView = nil;

            self.index = indexPath;

            self.stufflistModel = model;
            [self.guigeArray removeAllObjects];

            if (model.spec.count == 0) {

            } else {
                NSArray *guiTempArray = model.spec;

                for (NSDictionary *guigeDict in guiTempArray) {
                    GuigeModel *guigeModel = [GuigeModel mj_objectWithKeyValues:guigeDict];

                    [self.guigeArray addObject:guigeModel];
                }
            }

            self.editSpecView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
            self.editSpecView.dataArray = self.guigeArray;
            [self.editSpecView.guigeView reloadData];
            [[DZTools getAppWindow] addSubview:self.editSpecView];

        };
        return cell;
    }
}
#pragma mark-- CZHTagsViewDelegateCZHTagsViewDataSource
- (NSArray *)czh_tagsArrayInTagsView:(CZHTagsView *)tagsView {
    NSMutableArray *nameArray = [NSMutableArray array];
    for (SubModel *dict in self.guigeArray) {
        [nameArray addObject:dict.name];
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
- (void)czh_tagsView:(CZHTagsView *)tagsView didSelectItemWithSelectTagsArray:(NSArray *)selectTagsArray {
    self.selectTagArray = nil;
    self.selectTagArray = selectTagsArray;
}
- (void)czh_tagsViewWithHeigth:(CGFloat)selfHeight;
{
    self.guigeHeight.constant = selfHeight + 10;
}
#pragma mark - Function
- (void)initData {

    self.array = [NSMutableArray array];
    self.pinpaiArray = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    self.selectGuigeArray = [NSMutableArray array];
    self.guigeArray = [NSMutableArray array];
    self.spcArray = [NSMutableArray array];
    self.classSelectIndex = 0;
    self.selectIndex = 0;
}
- (void)alertGuigeViewWithCellView:(CailaodanEditCell *)cell {
    UIAlertController *alert = [UIAlertController
        alertControllerWithTitle:@"请选择规格"
                         message:nil
                  preferredStyle:UIAlertControllerStyleActionSheet];
    for (int i = 0; i < self.spcArray.count; i++) {
        GuigeModel *typeModel = self.spcArray[i];
        NSString *nameStr = @"";
        NSString *name = typeModel.spec_name;

        if ([name isKindOfClass:[NSNull class]] || name == nil) {
            nameStr = @"规格1";
        } else {
            nameStr = name;
        }

        [alert addAction:[UIAlertAction
                             actionWithTitle:nameStr
                                       style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction *_Nonnull action) {
                                         [self alertGuigeClick:i intoCell:cell];
                                     }]];
    }

    [alert addAction:[UIAlertAction
                         actionWithTitle:@"取消"
                                   style:UIAlertActionStyleCancel
                                 handler:^(UIAlertAction *_Nonnull action) {
                                     [self alertGuigeClick:self.spcArray.count
                                                  intoCell:cell];
                                 }]];
    //弹出提示框；
    [self presentViewController:alert animated:true completion:nil];
}
- (void)alertGuigeClick:(NSInteger)rowInteger
               intoCell:(CailaodanEditCell *)cell {
    if (rowInteger < self.spcArray.count) {

        GuigeModel *typeModel = self.spcArray[rowInteger];

        [cell.guigeBtn setTitle:typeModel.spec_name forState:UIControlStateNormal];
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)alertPinpaiViewWithcellView:(CailaodanEditCell *)cell {
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
               intoCell:(CailaodanEditCell *)cell {
//    cell.pinpaiBtn.text = @"";
    if (rowInteger < self.pinpaiArray.count) {
        
        PinpaiModel *typeModel = self.pinpaiArray[rowInteger];
        
        [cell.pinpaiBtn setTitle:typeModel.name forState:UIControlStateNormal];
        self.stufflistModel.selectBrandDict = @{
                                        @"stuff_brand_id": @(typeModel.stuff_brand_id),
                                        @"stuff_id": @(typeModel.stuff_id),
                                        @"name": typeModel.name
                                        };
    }
    int index = -1;
    for (int i = 0; i < self.dataArray.count; i++) {
        StuffListModel *model = self.dataArray[i];
        if (model.stuff_id == self.stufflistModel.stuff_id) {
            index = i;
            break;
        }
    }
    if (index != -1) {
        [self.dataArray replaceObjectAtIndex:index withObject:self.stufflistModel];
    }
}

#pragma mark--XibFunction
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

//选好了按钮的i点击
- (IBAction)shengchengBtnClick:(id)sender {
    if (self.dataArray.count <= 0) {
        [DZTools showNOHud:@"您还没有选择材料" delay:2];
        [self.shengchengScrollView removeFromSuperview];
    } else {

        self.hidesBottomBarWhenPushed = YES;
        GuanlianCailiaoViewController *viewController = [[GuanlianCailiaoViewController alloc] init];
        viewController.totalSelectedStuffList = self.dataArray;
        if (viewController.isFromTiaoguo) {

        } else {
            viewController.returnBlock = ^(NSMutableArray *_Nonnull array) {
                NSArray *tempArray = [NSArray array];
                tempArray = [array copy];
                [self.dataArray addObjectsFromArray:tempArray];
            };
        }
        self.shengchengScrollView.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        [self.view addSubview:self.scrollView];
        [self.scrollView addSubview:self.shengchengScrollView];
        [self.navigationController pushViewController:viewController animated:YES];
        self.hidesBottomBarWhenPushed = YES;
    }

    //    self.shengchengScrollView.frame =self.view.bounds;
    //    [self.view addSubview:self.shengchengScrollView];
}
- (IBAction)cancelShengchengView:(id)sender {
    [self.scrollView removeFromSuperview];
    [self.shengchengScrollView removeFromSuperview];
}
- (IBAction)cancelClick:(id)sender {

    [self.scrollView removeFromSuperview];
}
//确定点击
- (IBAction)sureBtnClick:(id)sender {
    [self.scrollView removeFromSuperview];
    [self.shengchengScrollView removeFromSuperview];
    //    double latitude = [DZTools getAppDelegate].latitude;
    //    double longitude = [DZTools getAppDelegate].longitude;
    NSMutableArray *tempArray = [NSMutableArray array];

    if (self.cailiaodanTextField.text.length == 0) {
        self.cailiaodanTextField.text = self.cailiaodanTextField.placeholder;
    }
   

    
    for (StuffListModel *model in self.dataArray) {

        if (model.selectBrandDict.count == 0) {
            [DZTools showNOHud:@"请选择品牌" delay:2];
            return;
        }
        if (model.selectsSpecDict.count == 0) {
            [DZTools showNOHud:@"请选择规格" delay:2];
            return;
        }
        [tempArray addObject:@{
            @"number": @(model.number),
            @"stuff_id": @(model.stuff_id),
            @"stuff_name": model.stuff_name,
            @"stuff_brand_id": [model.selectBrandDict objectForKey:@"stuff_brand_id"] == nil ? @"0" : [model.selectBrandDict objectForKey:@"stuff_brand_id"],
            @"stuff_brand_name": [model.selectBrandDict objectForKey:@"name"] == nil ? @"无品牌" : [model.selectBrandDict objectForKey:@"name"],
            @"stuff_spec_id": model.selectsSpecDict[@"stuff_spec_id"] == nil ? @"" : model.selectsSpecDict[@"stuff_spec_id"],
            @"stuff_spec_name": model.selectsSpecDict[@"name"] == nil ? @"" : model.selectsSpecDict[@"name"]
        }];
    }
    NSLog(@"-------%@", tempArray);
    NSDictionary *dict = @{
        @"name": self.cailiaodanTextField.text,

        @"stuff": [tempArray mj_JSONString],

    };
    NSLog(@"%@", dict);

    [DZNetworkingTool postWithUrl:kAddStuffCart
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];

                [self.dataArray removeAllObjects];
                //                                  self.numberLabel.text = 0;
                //                                  [self.view layoutIfNeeded];
                [self.tableView reloadData];

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
//自定计算
- (IBAction)zinengjisuanBtnClick:(id)sender {

    if (self.sectionArry.count == 0) {
        [DZTools showNOHud:@"请选择版型和造型" delay:2];
        return;
    }
    NSMutableArray *tempArray = [NSMutableArray array];
    for (int i = 0; i < self.sectionArry.count; i++) {
        SpecModel *model = self.sectionArry[i];
        [tempArray addObject:@([model.selectSub[@"spec_id"] intValue])];
    }
    NSString *string = [tempArray componentsJoinedByString:@","];
    NSDictionary *dict = @{
        @"project_id": @(self.projectId),
        @"spec_ids": string,
        @"page": @(1),
        @"limit": @(8)
    };
    NSLog(@"-----------%@", dict);
    [DZNetworkingTool postWithUrl:kGetProjectList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                NSDictionary *dict = [responseObject objectForKey:@"data"];
                NSArray *arr = [dict objectForKey:@"stuff_list"];

                [self.dataArray removeAllObjects];
                for (NSDictionary *dict in arr) {
                    ProjectListModel *model = [ProjectListModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }
                self.totalNumber = 0;
                for (ProjectListModel *model in self.dataArray) {
                    if (model.auto_type == 1) {
                        self.totalNumber += model.auto_count;
                    }
                    if (model.auto_type == 2) {
                        self.totalNumber += model.auto_count * [self.gongchengliangTextField.text intValue];
                    }
                }
                self.zhongleiLabel.text = [NSString stringWithFormat:@"商品种类:%d", (int) self.dataArray.count];
                self.cailiaoNumberLabel.text = [NSString stringWithFormat:@"供给材料数量：%d", self.totalNumber];
                [self.tableView reloadData];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
                [self.dataArray removeAllObjects];
                [self.tableView reloadData];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [self.dataArray removeAllObjects];
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (IBAction)xinzengBtnCLick:(id)sender {
    CaiLiaoFenLeiViewController *vc = [[CaiLiaoFenLeiViewController alloc] init];
    ProjectListModel *cartModel = [ProjectListModel new];
    vc.isFromEdit = YES;

    vc.change = ^(NSArray *array) {
        for (StuffListModel *model in array) {

            if (model.selectBrandDict.count != 0) {
                cartModel.selectBrandDict = model.selectBrandDict;
            }
            cartModel.selectsSpecDict = model.selectsSpecDict;
            cartModel.stuff_id = (int) model.stuff_id;
            cartModel.stuff_name = model.stuff_name;
            cartModel.spec = model.spec;
            cartModel.brand = model.brand;
            cartModel.number = [model.selectsSpecDict[@"number"] integerValue];
            [self.dataArray addObject:cartModel];
            self.totalNumber += model.number;
        }
        self.cailiaoNumberLabel.text = [NSString stringWithFormat:@"供给材料数量：%d", self.totalNumber];
        self.zhongleiLabel.text = [NSString stringWithFormat:@"商品种类:%d", (int) self.dataArray.count];
        [self.tableView reloadData];

    };

    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)quxiaoCLick:(id)sender {
    [self.guigeBgView removeFromSuperview];
}

//确定添加规格
- (IBAction)sureAddBtnClick:(id)sender {

    self.tagsView = nil;
    [self.guigeBgView removeFromSuperview];
    NSString *nameStr = @"";
    NSInteger project_id = 0;
    NSInteger spec_id = 0;
    if (self.selectTagArray.count == 0) {
        return;
    }
    for (SubModel *dict in self.guigeArray) {
        if ([dict.name isEqualToString:self.selectTagArray[0]]) {

            nameStr = dict.name;
            project_id = dict.project_id;
            spec_id = dict.spec_id;
        }
    }

    SpecModel *model = self.sectionArry[self.selectIndex];
    model.selectSub = @{
        @"project_id": @(project_id),
        @"spec_id": @(spec_id),
        @"name": nameStr
    };
    [self.headTableView reloadData];
    NSLog(@"%@", model.selectSub);
    [self.tagsView reloadData];
}

#pragma mark – 懒加载
- (TPKeyboardAvoidingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[TPKeyboardAvoidingScrollView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        _scrollView.contentSize = CGSizeMake(ViewWidth, ViewHeight);
    }
    return _scrollView;
}

- (CZHTagsView *)tagsView {
    if (!_tagsView) {
        _tagsView = [[CZHTagsView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 0) style:CZHTagsViewStyleDefault];
        _tagsView.backgroundColor = [UIColor whiteColor];
        _tagsView.dataSource = self;
        _tagsView.delegate = self;
    }
    return _tagsView;
}
- (EditSpecView *)editSpecView {
    if (!_editSpecView) {
        _editSpecView = [[EditSpecView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, ViewHeight)];
        __weak typeof(ZIdongjisuanController *) weakself = self;

        _editSpecView.sureBlock = ^(NSArray *_Nonnull array) {

            for (NSDictionary *dict in array) {
                NSArray *array1 = dict[@"array"];
                NSString *selectStr = @"";
                NSMutableArray *idArray = [NSMutableArray array];
                for (SpecGuigeModel *model in array1) {
                   
                    [idArray addObject:@(model.stuff_spec_id)];
                }
                selectStr = [idArray componentsJoinedByString:@","];

                weakself.stufflistModel.selectsSpecDict = @{
                    @"stuff_spec_id": selectStr,
                    @"number": dict[@"number"],
                    @"name": dict[@"name"]
                };
                [weakself.dataArray replaceObjectAtIndex:weakself.index.row withObject:weakself.stufflistModel];
            }
            
            [weakself.tableView reloadData];

        };
        _editSpecView.deleteBlock = ^{
            weakself.editSpecView  = nil;
        };
    }
    
    return _editSpecView;
}
@end

