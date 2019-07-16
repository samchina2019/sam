//
//  NewCaiLiaoViewController.m
//  SanMuZhuangXiu
//
//  Created by apple on 2019/7/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "NewCaiLiaoViewController.h"
#import "QXSegmentView.h"
#import "CaiLiaoFenLeiViewController.h"
#import "XiangmuFenleiViewController.h"
#import"ZIdongjisuanController.h"

@interface NewCaiLiaoViewController ()<QXBaseTableViewDelegate>{
    
    CaiLiaoFenLeiViewController*CaiLiaoFenLeiVC;
    XiangmuFenleiViewController*  XiangmuFenleiVC;
    QXTableView*tableView;
    ZIdongjisuanController*ZIdongjisuanVC;
    QXSegmentView * segmentView ;
}

/**
 当前选中模块   0材料分类 1项目分类 2自动计算
 */
@property (nonatomic, assign) NSInteger         selectedDataType;
@property (nonatomic, strong) NSMutableArray        *dataArray;//内容数组

@end

@implementation NewCaiLiaoViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
     segmentView.hidden=NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    segmentView.hidden=YES;
    self.hidesBottomBarWhenPushed = YES;

}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self layoutUI];
}

- (void)layoutUI{
    
    
  
    //初始化选择器
    NSArray * titleArray = [NSArray arrayWithObjects:@"材料分类", @"项目分类",@"自动计算",nil];
    segmentView = [[QXSegmentView alloc] initWithFrame:CGRectMake(72*SCREEN_WIDTH/750, SafeAreaTopHeight-44, SCREEN_WIDTH-150*SCREEN_WIDTH/750, 44) titleArray:titleArray];
    self.selectedDataType=0;
    [self setSelectedIndex: self.selectedDataType];
    segmentView.segmentClickBlock = ^(NSInteger index) {
        //选择器选中
        self.selectedDataType = index;
        [self setSelectedIndex:self.selectedDataType];
    };
    
   [self.navigationController.view addSubview:segmentView];
    
    
    //初始化列表
//    self.dataArray = [[NSMutableArray alloc] init];
//    tableView = [[QXTableView alloc] initWithFrame:CGRectMake(0, segmentView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT-SafeAreaBottomHeight-SafeAreaTopHeight-49-44) style:UITableViewStyleGrouped];
//    tableView.delegate = self;
//    tableView.dataSource = self;
//    tableView.refreshDelegate = self;
//    [self.view addSubview:tableView];
}
-(void)setSelectedIndex:(NSInteger)selectedIndex{
    switch (selectedIndex){
     case 0://材料分类
        {
            if (!CaiLiaoFenLeiVC)
                CaiLiaoFenLeiVC = [CaiLiaoFenLeiViewController new];
                CaiLiaoFenLeiVC.view.frame =self.view.bounds;
                [self addChildViewController:CaiLiaoFenLeiVC];
             [self.view addSubview:CaiLiaoFenLeiVC.view];
            
        }
     break;
        case 1://项目分类
            
        {
            if (!XiangmuFenleiVC)
                XiangmuFenleiVC = [XiangmuFenleiViewController new];
            XiangmuFenleiVC.view.frame =self.view.bounds;
            [self addChildViewController:XiangmuFenleiVC];
            [self.view addSubview:XiangmuFenleiVC.view];
        }
            break;
        case 2://自动计算
        {
            if (!ZIdongjisuanVC)
                ZIdongjisuanVC = [ZIdongjisuanController new];
            ZIdongjisuanVC.view.frame =self.view.bounds;
            [self addChildViewController:ZIdongjisuanVC];
            [self.view addSubview:ZIdongjisuanVC.view];
        }
            break;
default:
    break;
    }
}
@end
