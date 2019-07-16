//
//  DZBaseViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2018/12/13.
//  Copyright © 2018 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

@interface DZBaseViewController ()

@end

@implementation DZBaseViewController

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
  
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIImage *image = [UIImage imageNamed:@"back"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:image  style:UIBarButtonItemStyleDone target:self action:@selector(backItemClicked)];
}
- (void)backItemClicked
{
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:YES];
//    self.hidesBottomBarWhenPushed = YES;
//}
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:YES];
//    SHAREDAPP.rootNav = (UINavigationController *)[self.tabBarController.viewControllers objectAtIndex:self.tabBarController.selectedIndex];
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
