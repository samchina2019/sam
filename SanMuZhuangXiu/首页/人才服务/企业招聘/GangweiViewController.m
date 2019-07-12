//
//  GangweiViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GangweiViewController.h"
#import "QiyeViewCell.h"
#import "QiyeFabujiluViewController.h"
#import "FabuZhaopinViewController.h"
#import "QiyeGangweiDetailController.h"
#import "YBPopupMenu.h"
#import "ReLayoutButton.h"
#import "QiyeZhaopinModel.h"
#import "QiYeRenZhengViewController.h"
#import "YaoqiuModel.h"
#import "GridCollectionView.h"
#import "CustomCollectionViewCell.h"
#import "TypeCellClass.h"
#import "ActivityModel.h"
#import "BusinessCell.h"
#import "BusinessCellTwo.h"
#import "ActivityTwoModel.h"
//#import "UIView+SetRect.h"
typedef enum : NSUInteger {

    kBusinessOne = 20,
    kBusinessTwo,
    kBusinessThree,

} EBusinessTag;

@interface GangweiViewController () <YBPopupMenuDelegate, GridCollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (strong, nonatomic) IBOutlet UIView *yaoqiuView;
@property (weak, nonatomic) IBOutlet UITableView *workTableView;

@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (strong, nonatomic) NSMutableArray *gangweiTilteArray;
@property (strong, nonatomic) NSMutableArray *onlyClassTilteArray;
@property (weak, nonatomic) IBOutlet ReLayoutButton *tuijianBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *cityBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *yaoqiuBtn;
@property (weak, nonatomic) IBOutlet UIButton *chongzhiBtn;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollviewHeight;

@property (nonatomic, strong) NSString *gongzhongStr;
@property (nonatomic, strong) NSString *addressStr;  //区域
@property (nonatomic, strong) NSString *workyearsStr;  //工作年限
@property (nonatomic, strong) NSString *salaryStr;  //薪资
@property (nonatomic, strong) NSString *xueliStr;  //学历
@property (nonatomic, strong) NSString *searchStr;  //搜索
@property (nonatomic, strong) NSString *zuixinStr;  //最新
@property (nonatomic, assign) NSInteger lastNum;

@property (nonatomic) NSInteger page;

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *mulArray;

@property (nonatomic, strong) UIView *backOneView;
@property (nonatomic, strong) UIView *backTwoView;
@property (nonatomic, strong) UIView *backThreeView;

@property (nonatomic, strong) GridCollectionView *gridOneView;
@property (nonatomic, strong) GridCollectionView *gridTwoView;
@property (nonatomic, strong) GridCollectionView *gridThreeView;

@end

@implementation GangweiViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self loadData];
}
//获取区域列表
- (void)loadData {

    NSDictionary *params = @{ @"area_name": [DZTools getAppDelegate].city?[DZTools getAppDelegate].city:@"北京市" };
    [DZNetworkingTool postWithUrl:kGetQuYuList
        params:params
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSArray *array = responseObject[@"data"];
                [self.gangweiTilteArray removeAllObjects];
                [self.gangweiTilteArray addObject:[DZTools getAppDelegate].city];
                for (NSDictionary *dict in array) {
                    [self.gangweiTilteArray addObject:dict[@"name"]];
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
- (void)viewDidLoad {
    [super viewDidLoad];

    self.onlyClassTilteArray = [NSMutableArray arrayWithObjects:@"推荐", @"最新", nil];

    self.mulArray = [[NSMutableArray alloc] init];
    NSArray *array = @[@"全部", @"物流运输", @"体育运动", @"工具软件", @"电子商务",
                       @"社交网络", @"企业服务", @"文化娱乐", @"硬件", @"广告营销",
                       @"游戏", @"本地生活", @"旅游", @"医疗", @"房产", @"汽车交通",
                       @"金融", @"教育", @"其他"];

    for (NSString *string in array) {

        YaoqiuModel *model = [[YaoqiuModel alloc] init];
        model.typeName = string;
        [self.mulArray addObject:model];
    }

    self.gangweiTilteArray = [NSMutableArray array];

    self.sectionHeaderView.frame = CGRectMake(0, 0, ViewWidth, 40);
    self.workTableView.tableHeaderView = self.sectionHeaderView;
    [self.workTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    self.dataArray = [NSMutableArray arrayWithCapacity:0];
//    [self loadData];

    [self.cityBtn setTitle:[DZTools getAppDelegate].city?[DZTools getAppDelegate].city:@"北京市" forState:UIControlStateNormal];

    self.addressStr = [DZTools getAppDelegate].city?[DZTools getAppDelegate].city:@"北京市";
    self.workyearsStr = @"";
    self.salaryStr = @"";
    self.xueliStr = @"";
    self.searchStr = @"";
    self.zuixinStr = @"";
    
    self.workTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^(void) {
        NSLog(@"下拉刷新");
        [self refresh];
    }];
    self.workTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        NSLog(@"上拉加载更多");
        [self loadMore];
    }];

    [self.workTableView registerNib:[UINib nibWithNibName:@"QiyeViewCell" bundle:nil] forCellReuseIdentifier:@"QiyeViewCell"];
    [self.workTableView.mj_header beginRefreshing];

    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchClick:) name:@"search" object:nil];
}
- (void)searchClick:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    self.searchStr = [dic objectForKey:@"title"];
    [self refresh];
}
- (void)refresh {
    _page = 1;
    [self getDataArrayFromServerIsRefresh:YES];
}
- (void)getDataArrayFromServerIsRefresh:(BOOL)isRefresh {

    NSDictionary *dict = @{@"search_name":self.searchStr,
                           @"newtime":self.zuixinStr,
                           @"city":[DZTools getAppDelegate].city?[DZTools getAppDelegate].city:@"北京市",
                           @"work_address":self.addressStr,
                           @"salary":self.salaryStr,
                           @"work_year":self.workyearsStr,
                           @"education":self.xueliStr,
                           @"page": @(_page),
                           @"limit": @(20)};
    [DZNetworkingTool postWithUrl:kQiyeRecruitList
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            
            if (isRefresh) {
                [self.dataArray removeAllObjects];
            }
            
            NSDictionary *dict = responseObject[@"data"];
            NSArray *array = dict[@"area_list"];
            [self.gangweiTilteArray removeAllObjects];
            [self.gangweiTilteArray addObject:dict[@"city"]];
            for (NSDictionary *dict in array) {
                [self.gangweiTilteArray addObject:dict[@"name"]];
            }
            if ([responseObject[@"code"] intValue] == SUCCESS) {
               
                NSArray *list = dict[@"list"];
                for (NSDictionary *dict in list) {
                    QiyeZhaopinModel *model = [QiyeZhaopinModel mj_objectWithKeyValues:dict];
                    [self.dataArray addObject:model];
                }

//                [self.workTableView reloadData];
                if (self.dataArray.count == [dict[@"total"] intValue]) {
                    [self.workTableView.mj_footer endRefreshingWithNoMoreData];
                }
            } else {
                [self.dataArray removeAllObjects];
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
            
             [self.workTableView reloadData];
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            if (self.workTableView.mj_footer.isRefreshing) {
                [self.workTableView.mj_footer endRefreshing];
            }
            if (self.workTableView.mj_header.isRefreshing) {
                [self.workTableView.mj_header endRefreshing];
            }
            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
- (void)loadMore {
    _page = _page + 1;
    [self getDataArrayFromServerIsRefresh:NO];
}
#pragma mark - <UITableViewDelegate和DataSource>
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray.count == 0) {
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"no_content"]];
        self.workTableView.backgroundView = backgroundImageView;
        self.workTableView.backgroundView.contentMode = UIViewContentModeCenter;
    } else {
        self.workTableView.backgroundView = nil;
    }
    return self.dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return 100;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.sectionHeaderView;
//}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QiyeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QiyeViewCell" forIndexPath:indexPath];
    QiyeZhaopinModel *model = self.dataArray[indexPath.row];
    cell.namelabel.text = model.recruitment_post;
    cell.gongziLabel.text = [NSString stringWithFormat:@"¥%@", model.salary];

    if ([model.putup isEqualToString:@"10"]) {
        cell.baoShiSuBtn.hidden = NO;
    } else if ([model.putup isEqualToString:@"20"]) {
        cell.baoShiSuBtn.hidden = YES;
    }
    if ([model.is_rest isEqualToString:@"10"]) {
        [cell.shuangxiuBtn setTitle:@"双休" forState:UIControlStateNormal];
    } else if ([model.is_rest isEqualToString:@"20"]) {
        [cell.shuangxiuBtn setTitle:@"单休" forState:UIControlStateNormal];
    }
    if ([model.risks_gold isEqualToString:@"10"]) {
        cell.wuxianyijinBtn.hidden = NO;
    } else if ([model.risks_gold isEqualToString:@"20"]) {
        cell.wuxianyijinBtn.hidden = YES;
    }

    cell.jinyanlabel.text = [NSString stringWithFormat:@"%@ | %@ | %d人", model.work_region, model.work_year, model.recruitment_number];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    QiyeZhaopinModel *model = self.dataArray[indexPath.row];
    QiyeGangweiDetailController *controller = [[QiyeGangweiDetailController alloc] init];
    controller.idStr = model.lookId;
    [self.navigationController pushViewController:controller animated:YES];
}
#pragma  mark --XibFunction
//区域选择
- (IBAction)gongchengshiBtnClick:(id)sender {
    if ([self.view.subviews containsObject:self.yaoqiuView]) {
        [self.yaoqiuView removeFromSuperview];
    }
    if (self.gangweiTilteArray.count > 0) {

        [YBPopupMenu showRelyOnView:sender
                             titles:self.gangweiTilteArray
                              icons:nil
                          menuWidth:140
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 200;
                          //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                      }];
    } else {
        [DZTools showNOHud:@"正在请求列表，请稍后重试！" delay:2.0];
        [self loadData];
    }
}
//推荐最新
- (IBAction)erqiBtnClick:(id)sender {
    if ([self.view.subviews containsObject:self.yaoqiuView]) {
        [self.yaoqiuView removeFromSuperview];
    }
    if (self.onlyClassTilteArray.count > 0) {
        [YBPopupMenu showRelyOnView:sender
                             titles:self.onlyClassTilteArray
                              icons:nil
                          menuWidth:140
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 100;
                          //如果不加这句默认是 UITableViewCellSeparatorStyleNone 的
                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                      }];
    } else {
        //        [HUTools showNOHud:Localized(@"正在请求分类列表，请稍后重试！") delay:2.0];
        //        [self loadData];
    }
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    if (ybPopupMenu.tag == 100) {
        //推荐回调
        NSLog(@"点击了 %@ 选项", ybPopupMenu.titles[index]);
        self.zuixinStr = [NSString stringWithFormat:@"%ld",index];
        [self.tuijianBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
    } else {
        //区域回调
        NSLog(@"点击了 %@ 选项", ybPopupMenu.titles[index]);
        self.addressStr = ybPopupMenu.titles[index];
        [self.cityBtn setTitle:ybPopupMenu.titles[index] forState:UIControlStateNormal];
    }
    [self refresh];
}


//发布记录
- (IBAction)faBujiluBtnClick:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }

    self.hidesBottomBarWhenPushed = YES;

    QiyeFabujiluViewController *qiyeFabujiluViewController = [[QiyeFabujiluViewController alloc] init];
    [self.navigationController pushViewController:qiyeFabujiluViewController animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//招聘
- (IBAction)zhaoPinBtnClick:(id)sender {
    if (![DZTools panduanLoginWithViewContorller:self isHidden:NO]) {
        return;
    }

    [DZNetworkingTool postWithUrl:kQiyeCheckIdauth
        params:nil
        success:^(NSURLSessionDataTask *task, id responseObject) {
    if ([responseObject[@"code"] intValue] == SUCCESS) {
        //            NSString *data=responseObject[@"data"];

        if ([responseObject[@"data"] intValue] == 0) {
            self.hidesBottomBarWhenPushed = YES;
            QiYeRenZhengViewController *vc = [[QiYeRenZhengViewController alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
            self.hidesBottomBarWhenPushed = YES;
        } else if ([responseObject[@"data"] intValue] == 1) {
            [DZTools showNOHud:@"企业申请中，暂不能发布招聘" delay:2];
        } else if ([responseObject[@"data"] intValue] == 2) {
            self.hidesBottomBarWhenPushed = YES;

            FabuZhaopinViewController *fabuZhaopinViewController = [[FabuZhaopinViewController alloc] init];
            [self.navigationController pushViewController:fabuZhaopinViewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
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

- (IBAction)yaoqiuBtnClick:(id)sender {
    //    self.yaoqiuBtn.selected=!self.yaoqiuBtn.selected;
    if ([self.view.subviews containsObject:self.yaoqiuView]) {
        [self.yaoqiuView removeFromSuperview];
        return;
    }
    self.yaoqiuView.frame = CGRectMake(0, CGRectGetMaxY(self.sectionHeaderView.frame), ViewWidth, self.view.height - CGRectGetMaxY(self.sectionHeaderView.frame));
    [self.view addSubview:self.yaoqiuView];

    self.backOneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    self.backOneView.backgroundColor = [UIColor whiteColor];
    [self.bgView addSubview:self.backOneView];
    {

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 15, 40)];
        label.text = @"薪资(单选)";
        label.textColor = UIColorFromRGB(0x666666);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:16];
        [self.backOneView addSubview:label];

        NSMutableArray *mulArray = [[NSMutableArray alloc] init];
        NSArray *array = @[@"全部", @"3K以下", @"3K-5k", @"5K-10K", @"10K-30K",
                           @"30K-50K", @"50K以上"];

        for (NSString *string in array) {

            ActivityModel *model = [[ActivityModel alloc] init];
            model.typeName = string;
            [mulArray addObject:model];
        }

        self.gridOneView = [[GridCollectionView alloc] initWithFrame:CGRectMake(0, self.backOneView.bottom, self.view.frame.size.width, 400)];
        self.gridOneView.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.gridOneView.HorizontalGap = 15;
        self.gridOneView.verticalGap = 15;
        self.gridOneView.cellHeight = 30;
        self.gridOneView.HorizontalCellCount = 4;
        self.gridOneView.dataArray = mulArray;
        self.gridOneView.tag = kBusinessOne;

        TypeCellClass *typeCell = [[TypeCellClass alloc] init];
        typeCell.className = [BusinessCell class];
        typeCell.registID = @"BusinessCell";

        self.gridOneView.registCell = typeCell;
        self.gridOneView.delegate = self;
        [self.gridOneView setUpFrame];
        [self.bgView addSubview:self.gridOneView];
    }
    {
        self.backTwoView = [[UIView alloc] initWithFrame:CGRectMake(0, self.gridOneView.bottom, self.view.frame.size.width, 40)];
        self.backTwoView.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.backTwoView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 15, 40)];
        label.text = @"最低学历";
        label.textColor = UIColorFromRGB(0x666666);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:16];
        [self.backTwoView addSubview:label];

        NSMutableArray *mulARR = [NSMutableArray array];
        NSArray *array = @[@"全部", @"初中以下", @"中专/中技", @"高中", @"大专", @"本科",
          @"硕士", @"博士"];

        for (NSString *string in array) {

            ActivityTwoModel *model = [[ActivityTwoModel alloc] init];
            model.typeName = string;
            [mulARR addObject:model];
        }

        self.gridTwoView = [[GridCollectionView alloc] initWithFrame:CGRectMake(0, self.backTwoView.bottom, self.view.width, 400)];
        self.gridTwoView.HorizontalGap = 15;
        self.gridTwoView.verticalGap = 15;
        self.gridTwoView.cellHeight = 30;
        self.gridTwoView.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.gridTwoView.HorizontalCellCount = 4;
        self.gridTwoView.dataArray = mulARR;
        self.gridTwoView.tag = kBusinessTwo;

        TypeCellClass *typeCell = [[TypeCellClass alloc] init];
        typeCell.className = [BusinessCellTwo class];
        typeCell.registID = @"BusinessCellTwo";

        self.gridTwoView.registCell = typeCell;
        self.gridTwoView.delegate = self;
        [self.gridTwoView setUpFrame];
        [self.bgView addSubview:self.gridTwoView];
    }
    {
        self.backThreeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.gridTwoView.bottom, self.view.frame.size.width, 40)];
        self.backThreeView.backgroundColor = [UIColor whiteColor];
        [self.bgView addSubview:self.backThreeView];

        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.frame.size.width - 15, 40)];
        label.text = @"最低经验";
        label.textColor = UIColorFromRGB(0x666666);
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:16];
        [self.backThreeView addSubview:label];

        NSMutableArray *mulARR = [NSMutableArray array];
        NSArray *array =  @[@"全部", @"应届生", @"1年以内", @"1-3年", @"3-5年", @"5-10年",
                            @"10年以上"];

        for (NSString *string in array) {

            ActivityTwoModel *model = [[ActivityTwoModel alloc] init];
            model.typeName = string;
            [mulARR addObject:model];
        }

        self.gridThreeView = [[GridCollectionView alloc] initWithFrame:CGRectMake(0, self.backThreeView.bottom, self.view.width, 400)];
        self.gridThreeView.HorizontalGap = 15;
        self.gridThreeView.verticalGap = 15;
        self.gridThreeView.cellHeight = 30;
        self.gridThreeView.contentInsets = UIEdgeInsetsMake(15, 15, 15, 15);
        self.gridThreeView.HorizontalCellCount = 4;
        self.gridThreeView.dataArray = mulARR;
        self.gridThreeView.tag = kBusinessThree;

        TypeCellClass *typeCell = [[TypeCellClass alloc] init];
        typeCell.className = [BusinessCellTwo class];
        typeCell.registID = @"BusinessCellTwo";

        self.gridThreeView.registCell = typeCell;
        self.gridThreeView.delegate = self;
        [self.gridThreeView setUpFrame];
        [self.bgView addSubview:self.gridThreeView];
    }
    self.scrollviewHeight.constant = self.gridThreeView.bottom;
}
- (void)gridCollectionView:(GridCollectionView *)gridCollectionView didSelected:(CustomCollectionViewCell *)cell {

    if (gridCollectionView.tag == kBusinessOne) {

        [gridCollectionView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
            
            cell.indexPath.row == idx ? (model.isSelected = YES):(model.isSelected = NO);
        }];

        [gridCollectionView LoadData];
        
    } else if ( gridCollectionView.tag == kBusinessTwo) {
        [gridCollectionView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
            if (cell.indexPath.row == 0 && idx !=0) {
                model.isSelected = NO;
            }
            if (cell.indexPath.row != 0 && idx ==0) {
                model.isSelected = NO;
            }
        }];
        [gridCollectionView LoadData];
    }else if ( gridCollectionView.tag == kBusinessThree) {
        [gridCollectionView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
            if (cell.indexPath.row == 0 && idx !=0) {
                model.isSelected = NO;
            }
            if (cell.indexPath.row != 0 && idx ==0) {
                model.isSelected = NO;
            }
        }];
        [gridCollectionView LoadData];
    }
}

- (IBAction)chongzhiBtnClick:(id)sender {
    [self.gridOneView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
         model.isSelected = NO;
    }];
    [self.gridOneView LoadData];
    [self.gridTwoView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
         model.isSelected = NO;
    }];
    [self.gridTwoView LoadData];
    [self.gridThreeView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
         model.isSelected = NO;
    }];
    [self.gridThreeView LoadData];
}

- (IBAction)quedingBtnClick:(id)sender {
    [self.gridOneView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
        if (model.isSelected) {
            if (idx == 0) {
                self.salaryStr = @"";
            }else{
                self.salaryStr = model.typeName;
            }
        }
    }];
    [self.gridTwoView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
        if (model.isSelected) {
            if (idx == 0) {
                self.workyearsStr = @"";
            }else{
                self.workyearsStr = [NSString stringWithFormat:@"%@,%@", self.workyearsStr, model.typeName];
            }
        }
    }];
    [self.gridThreeView.dataArray enumerateObjectsUsingBlock:^(ActivityModel *model, NSUInteger idx, BOOL *_Nonnull stop) {
        if (model.isSelected) {
            if (idx == 0) {
                self.xueliStr = @"";
            }else{
                self.xueliStr = [NSString stringWithFormat:@"%@,%@", self.xueliStr, model.typeName];
            }
        }
    }];
    [self refresh];
    [self.yaoqiuView removeFromSuperview];
    
}





@end
