//
//  QunDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/8.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QunDetailViewController.h"
#import "PeopleManagerViewController.h"
#import "ShenheManagerViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "ReLayoutButton.h"
#import "GuizeManagerViewController.h"
#import "TongJiBaoBiaoViewController.h"
#import "YBPopupMenu.h"

@interface QunDetailViewController () <FSPageContentViewDelegate, YBPopupMenuDelegate, FSSegmentTitleViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) ReLayoutButton *titleBtn;

@property (nonatomic, strong) NSArray *setArray;
@property (nonatomic, strong) NSArray *nameArray;
///1,正常，2，停工，3，结束
@property (nonatomic, assign) int gongzhuoStatus;
@end

@implementation QunDetailViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //    [self loadBasicData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    self.view.backgroundColor = [UIColor whiteColor];
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.setArray = [NSArray arrayWithObjects:@"开工", @"暂停", @"竣工", nil];
    self.titleArray = @[@" 人员管理  ", @" 规则设置  ", @" 异常管理  ", @" 统计报表  "];
    //
    [self setItemView];
    [self iniTitleView];
    [self setChildViewController];

    if (self.status == 1) {
        
         [self.titleBtn setTitle:@"开工" forState:UIControlStateNormal];
    }else if (self.status == 2){
        
         [self.titleBtn setTitle:@"暂停" forState:UIControlStateNormal];
    }else{
        
         [self.titleBtn setTitle:@"竣工" forState:UIControlStateNormal];
    }
}
#pragma mark – UI
-(void)iniTitleView{
    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 0, ViewWidth, 40) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:17];
    self.titleView.indicatorExtension = 4;
    self.titleView.indicatorColor = TabbarColor;
    
    //添加一条线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.titleView.frame.origin.y + self.titleView.frame.size.height), ViewWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);
    
    [self.view addSubview:lineView];
    
    [self.view addSubview:self.titleView];
}
//设置自控制器
- (void)setChildViewController {

    _viewControllers = [NSMutableArray array];

    PeopleManagerViewController *vc = [[PeopleManagerViewController alloc] init];
    vc.title = self.titleArray[0];
    vc.personnel_management = self.personnel_management;
    vc.group_id = self.groupId;
    vc.groupName = self.groupName;
    
    [self.viewControllers addObject:vc];

    GuizeManagerViewController *vc1 = [[GuizeManagerViewController alloc] init];
    vc1.title = self.titleArray[1];
    vc1.group_id = self.groupId;
    vc1.rule_management = self.rule_management;
    [self.viewControllers addObject:vc1];

    ShenheManagerViewController *vc2 = [[ShenheManagerViewController alloc] init];
    vc2.title = self.titleArray[2];
    vc2.group_id = self.groupId;
    vc2.audit_management = self.audit_management;
    [self.viewControllers addObject:vc2];

    //报表
    TongJiBaoBiaoViewController *vc3 = [[TongJiBaoBiaoViewController alloc] init];
    vc3.title = self.titleArray[3];
    vc3.group_id = self.groupId;
    vc3.statistical_management = self.statistical_management;
    [self.viewControllers addObject:vc3];

    self.pageContentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 40, ViewWidth, ViewHeight - (NavAndStatusHight + 40)) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];

    self.titleView.selectIndex = self.selectIndex;
    self.pageContentView.contentViewCurrentIndex = self.selectIndex;

}
//设置导航栏
- (void)setItemView {

    UIView *itemView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 64, 40)];
    UILabel *itemLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 64, 30)];
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"群管理"
                                                                               attributes:@{ NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size:17],
                                                                                             NSForegroundColorAttributeName: [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0] }];

    itemLable.attributedText = string;
    [itemView addSubview:itemLable];

    //    ReLayoutButton *titleBtn1=[[ReLayoutButton alloc]initWithFrame:CGRectMake(0, 30, 54, 10)];
    //    self.titleBtn=titleBtn1;
    //    self.titleBtn.layoutType=2;
    //    [self.titleBtn setImage:[UIImage imageNamed:@"xiasanjiao"] forState:UIControlStateNormal];
    //
    //
    //    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"正常开工" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Medium" size: 10],NSForegroundColorAttributeName: [UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0]}];
    //
    //    [self.titleBtn addTarget:self action:@selector(titleBtnClick) forControlEvents:UIControlEventTouchUpInside];
    //
    //    [self.titleBtn setContentVerticalAlignment:0];
    //    [self.titleBtn setAttributedTitle:string1 forState:UIControlStateNormal];
    //     [itemView addSubview:self.titleBtn];
    //    if (self.titleView.selectIndex ==0) {
    //        self.titleBtn.hidden=NO;
    //    }else{
    //        self.titleBtn.hidden=YES;
    //    }

    self.navigationItem.titleView = itemView;

    ReLayoutButton *titleBtn1 = [[ReLayoutButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    self.titleBtn = titleBtn1;
    self.titleBtn.layoutType = 2;
    [self.titleBtn setTitle:@" 正常开工" forState:UIControlStateNormal];
    self.titleBtn.borderWidth = 1;
    self.titleBtn.borderColor = UIColorFromRGB(0xE0E0E0);
    self.titleBtn.cornerRadius = 3;
    [self.titleBtn setImage:[UIImage imageNamed:@"xiasanjiao"] forState:UIControlStateNormal];
    [self.titleBtn addTarget:self action:@selector(rightBarButtonItemClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.titleBtn setTitleColor:UIColorFromRGB(0x3FAEE9) forState:UIControlStateNormal];
    self.titleBtn.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:titleBtn1];
}

//标题按钮的点击事件
- (void)titleBtnClick {
}

//右边按钮的点击事件
- (void)rightBarButtonItemClicked {

    if (self.setArray.count > 0) {
        [YBPopupMenu showRelyOnView:self.titleBtn
                             titles:self.setArray
                              icons:nil
                          menuWidth:140
                      otherSettings:^(YBPopupMenu *popupMenu) {
                          popupMenu.dismissOnSelected = YES;
                          popupMenu.isShowShadow = YES;
                          popupMenu.delegate = self;
                          popupMenu.type = YBPopupMenuTypeDefault;
                          popupMenu.cornerRadius = 8;
                          popupMenu.tag = 100;
                          popupMenu.backColor = [UIColor whiteColor];
                          popupMenu.separatorColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1.0];
                          popupMenu.textColor = UIColorFromRGB(0x333333);

                          popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
                      }];
    } else {
        //        [HUTools showNOHud:Localized(@"正在请求分类列表，请稍后重试！") delay:2.0];
        //        [self initData];
    }
}
#pragma mark - YBPopupMenuDelegate
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index {
    ybPopupMenu.textColor = UIColorFromRGB(0x3FAEE9);
    [self.titleBtn setTitle:self.setArray[index] forState:UIControlStateNormal];

    if (index == 0) {
        self.gongzhuoStatus = 1;

    } else if (index == 1) {
        self.gongzhuoStatus = 2;
        NSLog(@"点击了另一个。。。");
    } else {
        self.gongzhuoStatus = 3;
    }
    NSDictionary *dict = @{
        @"group_id": @(self.groupId),
        @"status": @(self.gongzhuoStatus)
    };
    [DZNetworkingTool postWithUrl:kSetGroupStatus
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {

                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                if (index==0) {
                   
                }else{
                    [self.navigationController popViewControllerAnimated:YES];
                }

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];

        }
        IsNeedHub:NO];
}

#pragma mark - FSPageContentViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.titleView.selectIndex = endIndex;

    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}
#pragma mark - FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex {
    self.pageContentView.contentViewCurrentIndex = endIndex;
    //    if (self.titleView.selectIndex ==0) {
    //        self.titleBtn.hidden=NO;
    //    }else{
    //        self.titleBtn.hidden=YES;
    //    }
    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}

@end
