//
//  QiyeZhaopinViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QiyeZhaopinViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "GangweiViewController.h"
#import "QiuziViewController.h"

@interface QiyeZhaopinViewController () <FSPageContentViewDelegate, FSSegmentTitleViewDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UIImageView *sousuoImageView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) NSArray *titleArray;
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSMutableArray *viewControllers;

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;

@end

@implementation QiyeZhaopinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"企业招聘";

    self.view.backgroundColor = [UIColor whiteColor];
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.titleArray = @[@"岗位信息", @"求职信息"];

    self.titleView = [[FSSegmentTitleView alloc] initWithFrame:CGRectMake(0, 51, ViewWidth, 30) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:17];
    self.titleView.indicatorExtension = 2;
    self.titleView.indicatorColor = TabbarColor;

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (self.titleView.frame.origin.y + self.titleView.frame.size.height), ViewWidth, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xF5F5F5);

    [self.view addSubview:lineView];
    [self.view addSubview:self.titleView];

    _viewControllers = [NSMutableArray array];

    GangweiViewController *vc = [[GangweiViewController alloc] init];
    vc.title = self.titleArray[0];
    [self.viewControllers addObject:vc];

    QiuziViewController *vc1 = [[QiuziViewController alloc] init];
    vc1.title = self.titleArray[1];
    [self.viewControllers addObject:vc1];

    self.pageContentView = [[FSPageContentView alloc] initWithFrame:CGRectMake(0, 82, ViewWidth, ViewHeight - NavAndStatusHight - 82) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];

    self.titleView.selectIndex = self.selectIndex;
    self.pageContentView.contentViewCurrentIndex = self.selectIndex;
}
- (void)textFieldDidEndEditing:(UITextField *)textField {
    NSDictionary *dict = @{
        @"title": self.searchTextField.text
    };
    if (self.pageContentView.contentViewCurrentIndex == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"search" object:nil userInfo:dict];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchQiuzi" object:nil userInfo:dict];
    }
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
    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}


@end
