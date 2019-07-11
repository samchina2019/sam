//
//  AppraiseViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AppraiseViewController.h"
#import "XHStarRateView.h"

@interface AppraiseViewController ()<XHStarRateViewDelegate>
//物流评价
@property (weak, nonatomic) IBOutlet UITextView *wuliuTextView;
//商家评价
@property (weak, nonatomic) IBOutlet UITextView *shangjiaTextView;
//商家星星评价
@property (weak, nonatomic) IBOutlet XHStarRateView *startView;
//物流星星评价
@property (weak, nonatomic) IBOutlet XHStarRateView *wuliuStartView;

@property(nonatomic,assign)int shangjiaStar;
@property(nonatomic,assign)int wuliuStar;
@property(nonatomic,assign)NSInteger orderId;
@end

@implementation AppraiseViewController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.order_type == 20) {
        self.nameLabel.text = @"给商家打分";
    }else{
        self.nameLabel.text = @"给商品打分";
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"评价";
    self.view.backgroundColor=[UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0];
  
    
    if (self.idFromList) {
        self.orderId=self.order_id;
    }else{
     self.orderId = [self.dataDic[@"order_id"] integerValue];
    }
    [self initStartView];
}
#pragma mark – UI

-(void)initStartView{
    
    /*
     1. Delegate 方式创建
     */
    XHStarRateView *starRateView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    [self.startView addSubview:starRateView];
    starRateView.isAnimation = YES; // 有动画
    starRateView.rateStyle = 0; //完整星评论
    starRateView.tag = 1;
    starRateView.delegate = self;
    XHStarRateView *starView = [[XHStarRateView alloc] initWithFrame:CGRectMake(0, 0, 200, 24)];
    
    starView.isAnimation = YES; // 有动画
    starView.rateStyle = 0; //完整星评论
    starView.tag = 2;
    starView.delegate = self;
    [self.wuliuStartView addSubview:starView];
    
}

#pragma mark - Function
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore {

    if (starRateView.tag==1) {
        self.shangjiaStar=currentScore;
    }else if (starRateView.tag==2){
        self.wuliuStar=currentScore;
    }
  NSLog(@"%ld----  %f",(long)starRateView.tag,currentScore);
}

#pragma mark – XibFunction

//提交
- (IBAction)tijiaoBtnClick:(id)sender {
//
    
    [self.shangjiaTextView resignFirstResponder];
    [self.wuliuTextView resignFirstResponder];
    if (self.shangjiaTextView.text.length==0) {
        [DZTools showNOHud:@"对商家信息评价不能为空！" delay:2];
        return;
    }
    if (self.wuliuTextView.text.length==0) {
        [DZTools showNOHud:@"对物流评价不能为空！" delay:2];
        return;
    }
    NSDictionary *dict=@{
                         @"order_id":@(self.orderId),
                         @"seller_star":@(self.shangjiaStar),
                         @"logistics_star":@(self.wuliuStar),
                         @"seller_cmt":self.shangjiaTextView.text,
                         @"logistics_cmt":self.wuliuTextView.text
                         };
//#warning 有问题的
    [DZNetworkingTool postWithUrl:kEvaluOrder
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                  self.tabBarController.selectedIndex = 4;
                                  [self.navigationController popToRootViewControllerAnimated:NO];
                                
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];
}
//结束编辑
- (IBAction)endEditing:(id)sender {
    [self.view endEditing:YES];
}



@end
