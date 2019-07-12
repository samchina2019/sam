//
//  QXBaseViewController.m
//  YoungDrill
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 czg. All rights reserved.
//

#import "QXBaseViewController.h"

@interface QXBaseViewController ()

@property (nonatomic, strong) UILabel   *QXtitleLable;

@end

@implementation QXBaseViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.navigationController.navigationBar.clipsToBounds = YES;
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    [self createTitleView];
}


- (void)createTitleView{
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, SafeAreaTopHeight-44, SCREEN_WIDTH, 44)];
    [self.view addSubview:titleView];
    
    self.QXtitleLable = [[UILabel alloc] initWithFrame:CGRectMake(FitRealValue(48), 0, 300, 44)];
    _QXtitleLable.textColor = [UIColor blackColor];
//    _QXtitleLable.backgroundColor = [UIColor clearColor];
//    _QXtitleLable.text = @"绿茵之星 教练端";
    _QXtitleLable.font = [UIFont boldSystemFontOfSize:18];
    _QXtitleLable.textAlignment = NSTextAlignmentLeft;
    [titleView addSubview:_QXtitleLable];
    
    self.navigationItem.titleView = titleView;

}
//设置UINavigation Button item
- (void)setNavigationButtonItrmWithiamge:(NSString *)imagename withRightOrleft:(NSString*)f withtargrt:(id)t withAction:(SEL)s
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 30, 30);
    [btn addTarget:self action:s forControlEvents:UIControlEventTouchUpInside];
    [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
    
    UIBarButtonItem * navItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
    if ([f isEqualToString:@"right"]) {
        self.navigationItem.rightBarButtonItem = navItem;
        
    }else if ([f isEqualToString:@"left"]){
        self.navigationItem.leftBarButtonItem = navItem;
    }
    
    //    [navItem release];
}
-(void)backDefault
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setTitleStr:(NSString *)titleStr{
    _QXtitleLable.text = titleStr;
}

-(void)leftClicked
{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)setLeftView {
    [self setNavigationButtonItrmWithiamge:@"back" withRightOrleft:@"left" withtargrt:self withAction:@selector(leftClicked)];
}






//是否自动旋转,返回YES可以自动旋转,返回NO禁止旋转
- (BOOL)shouldAutorotate{
    return YES;
}
//返回支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
//由模态推出的视图控制器 优先支持的屏幕方向
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
