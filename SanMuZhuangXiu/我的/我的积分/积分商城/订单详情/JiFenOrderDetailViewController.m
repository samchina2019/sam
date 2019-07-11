//
//  JiFenOrderDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "JiFenOrderDetailViewController.h"
#import "JiFenStoreViewController.h"

@interface JiFenOrderDetailViewController ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layOutheigth;
@property (weak, nonatomic) IBOutlet UILabel *statesLabel;//待收货
@property (weak, nonatomic) IBOutlet UILabel *shouhuoNameLabel;//收货人
@property (weak, nonatomic) IBOutlet UILabel *shouhuoPhoneLabel;//收货人电话
@property (weak, nonatomic) IBOutlet UILabel *shouhuoAddressLabel;//收货地址
@property (weak, nonatomic) IBOutlet UIImageView *goodsImgView;
@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsJifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderPeisongLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderWuliuLabel;
@property (weak, nonatomic) IBOutlet UIButton *surebtn;

@property(nonatomic ,strong)NSString *stutes;

@end

@implementation JiFenOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"订单详情";
    
    if (@available(iOS 11.0, *))
    {
        self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets =NO;
    }
    
    if (ViewHeight + 1 - NavAndStatusHight > 540) {
        _layOutheigth.constant = ViewHeight + 1 - NavAndStatusHight;
    }else{
        self.layOutheigth.constant = 470;
    }
    [self loadData];
}

#pragma mark -- xib Action
//确认收货
- (IBAction)shouhuoBtnClicked:(id)sender {
 
    if ([self.stutes isEqualToString:@"10"]) {
//        确认付款
 
    }else if ([self.stutes isEqualToString:@"20"]){
//        取消订单
        NSDictionary *dict = @{
                               @"order_id": @(self.order_id)
                               };
        
        [DZNetworkingTool postWithUrl:kJiFenCancelOrder
                               params:dict
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
                                      [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                      [self.navigationController popViewControllerAnimated:YES];
                                  } else {
                                      [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                  }
                              }
                               failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                   
                                   [DZTools showNOHud:RequestServerError delay:2.0];
                               }
                            IsNeedHub:NO];
        
    }else if ([self.stutes isEqualToString:@"30"]){
        NSDictionary *dict = @{
                               @"order_id": @(self.order_id)
                               };
        
        [DZNetworkingTool postWithUrl:kJiFenReceivingGoodsr
                               params:dict
                              success:^(NSURLSessionDataTask *task, id responseObject) {
                                  
                                  if ([responseObject[@"code"] intValue] == SUCCESS) {
                                      [DZTools showOKHud:responseObject[@"msg"] delay:2];
                                      [self.navigationController popViewControllerAnimated:YES];
                                  } else {
                                      [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                  }
                              }
                               failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                                   
                                   [DZTools showNOHud:RequestServerError delay:2.0];
                               }
                            IsNeedHub:NO];
        
    }else if ([self.stutes isEqualToString:@"40"]){
        self.hidesBottomBarWhenPushed=YES;
        JiFenStoreViewController *vc=[[JiFenStoreViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed=YES;
    }else if ([self.stutes isEqualToString:@"50"]){
        self.hidesBottomBarWhenPushed=YES;
        JiFenStoreViewController *vc=[[JiFenStoreViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
        self.hidesBottomBarWhenPushed=YES;
    }

}
-(void)loadData{

    NSDictionary *params = @{
                             @"order_id":@(self.order_id)
                             
                             };
    [DZNetworkingTool postWithUrl: kJiFenOrderDetails params:params success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            self.statesLabel.text=[NSString stringWithFormat:@"%@",dict[@"order_status_name"]];
            NSDictionary *temp=dict[@"address"];
            self.shouhuoNameLabel.text=[NSString stringWithFormat:@"收件人:%@",temp[@"name"]];
            self.shouhuoPhoneLabel.text=[NSString stringWithFormat:@"%@",temp[@"phone"]];
            self.shouhuoAddressLabel.text=[NSString stringWithFormat:@"%@%@%@%@",temp[@"area"][0],temp[@"area"][1],temp[@"area"][2],temp[@"detail"]];
            [self.goodsImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"goods_img"]]]];
            self.goodsNameLabel.text=[NSString stringWithFormat:@"%@",dict[@"goods_name"]];
            self.goodsJifenLabel.text=[NSString stringWithFormat:@"%@",dict[@"score"]];
            
            self.orderIDLabel.text=[NSString stringWithFormat:@"%@",dict[@"order_no"]];
//            // 时间戳 -> NSDate *
//            NSDate *date = [NSDate dateWithTimeIntervalSince1970:[dict[@"createtime"] intValue]];
//            //设置时间格式
//            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//
//            [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
//            //将时间转换为字符串
//            NSString *timeStr = [formatter stringFromDate:date];
            self.orderTimeLabel.text=[NSString stringWithFormat:@"%@",dict[@"createtime"]];
            
            self.orderWuliuLabel.text=[NSString stringWithFormat:@"%@",dict[@"express_no"]];
            self.orderPeisongLabel.text=[NSString stringWithFormat:@"%@",dict[@"express_company"]];
            self.stutes=dict[@"order_status_ing"];
            if ([dict[@"order_status_ing"] isEqualToString:@"10"]) {
                
                [self.surebtn setTitle:@"确认付款" forState:UIControlStateNormal];
            }else if ([dict[@"order_status_ing"] isEqualToString:@"20"]){
                
                [self.surebtn setTitle:@"取消订单" forState:UIControlStateNormal];
            }else if ([dict[@"order_status_ing"] isEqualToString:@"30"]){
                
                [self.surebtn setTitle:@"确认收货" forState:UIControlStateNormal];
            }else if ([dict[@"order_status_ing"] isEqualToString:@"40"]){
                
                [self.surebtn setTitle:@"再来一单" forState:UIControlStateNormal];
            }else if ([dict[@"order_status_ing"] isEqualToString:@"50"]){
                
                [self.surebtn setTitle:@"继续购买" forState:UIControlStateNormal];
            }
            
        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
       
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];

}

@end
