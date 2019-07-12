//
//  FindWorkerViewController.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/2/28.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FindWorkerViewController.h"
#import "FSSegmentTitleView.h"
#import "FSScrollContentView.h"
#import "workViewController.h"
#import "FindWorkingViewController.h"
#import "StoreFocusListCell.h"

@interface FindWorkerViewController ()<FSPageContentViewDelegate,FSSegmentTitleViewDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@property (nonatomic, strong) FSSegmentTitleView *titleView;
@property (nonatomic, strong) FSPageContentView *pageContentView;
@property (nonatomic, strong) NSMutableArray *viewControllers;
@property (nonatomic, strong) NSArray *titleArray;
@property (weak, nonatomic) IBOutlet UITableView *workTableView;


@property (strong, nonatomic) IBOutlet UIView *sectionHeaderView;
@property (nonatomic, strong) NSArray *nameArray;



@end

@implementation FindWorkerViewController



- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.navigationItem.title=@"求职";
    
    ///设置从导航栏下方为坐标0点（0，0）
    self.navigationController.navigationBar.translucent = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleArray =@[@"工地招工人",@"工人找工作"];
    
    
    
    self.titleView = [[FSSegmentTitleView alloc]initWithFrame:CGRectMake(0,51, ViewWidth, 30) titles:self.titleArray delegate:self indicatorType:FSIndicatorTypeCustom];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.titleNormalColor = UIColorFromRGB(0x666666);
    self.titleView.titleSelectColor = TabbarColor;
    self.titleView.titleSelectFont = [UIFont boldSystemFontOfSize:17];
    self.titleView.indicatorExtension = 2;
    self.titleView.indicatorColor = TabbarColor;
    
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, (self.titleView.frame.origin.y+self.titleView.frame.size.height), ViewWidth, 1)];
    lineView.backgroundColor=UIColorFromRGB(0xF5F5F5);
    
    [self.view addSubview:lineView];
    [self.view addSubview:self.titleView];
    
    _viewControllers = [NSMutableArray array];
    
    workViewController *vc = [[workViewController alloc]init];
    vc.title = self.titleArray[0];
    [self.viewControllers addObject:vc];
    
    FindWorkingViewController *vc1 = [[FindWorkingViewController alloc]init];
    vc1.title = self.titleArray[1];
    [self.viewControllers addObject:vc1];
    
    self.pageContentView = [[FSPageContentView alloc]initWithFrame:CGRectMake(0, 82, ViewWidth, ViewHeight - NavAndStatusHight - 82) childVCs:self.viewControllers parentVC:self delegate:self];
    [self.view addSubview:self.pageContentView];
    
    self.titleView.selectIndex = self.selectIndex;
    self.pageContentView.contentViewCurrentIndex = self.selectIndex;
    
   
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    NSDictionary *dict=@{
            @"title":self.searchTextField.text
                         };
    if (self.pageContentView.contentViewCurrentIndex==0) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchGongdi" object:nil userInfo:dict];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"searchGongren" object:nil userInfo:dict];
    }
    
}
#pragma mark - FSPageContentViewDelegate
- (void)FSContenViewDidEndDecelerating:(FSPageContentView *)contentView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.titleView.selectIndex = endIndex;
    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}
#pragma mark - FSSegmentTitleViewDelegate
- (void)FSSegmentTitleView:(FSSegmentTitleView *)titleView startIndex:(NSInteger)startIndex endIndex:(NSInteger)endIndex
{
    self.pageContentView.contentViewCurrentIndex = endIndex;
    //    MyOrderListViewController *vc = self.viewControllers[endIndex];
    //    [vc.tableView.mj_header beginRefreshing];
}


@end
