//
//  GoodsDetailParameterViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GoodsDetailParameterViewController.h"
#import "GoodsDetailModel.h"
#import "ChatViewController.h"
#import "StoreDetailViewController.h"
@interface GoodsDetailParameterViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *bianhaoLabel;
@property (weak, nonatomic) IBOutlet UILabel *fenleiLabel;
@property (weak, nonatomic) IBOutlet UILabel *baozhuangLabel;
@property (weak, nonatomic) IBOutlet UILabel *chandiLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewHeight;
@property (weak, nonatomic) IBOutlet UILabel *jiaweiLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollViewHeight;
@end

@implementation GoodsDetailParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //注册通知(接收,监听,一个通知)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notification1:) name:@"goods_no" object:nil];
    [self refreshWithDict:self.dataDict];
}

//实现方法
- (void)notification1:(NSNotification *)noti {
    //使用userInfo处理消息
    NSDictionary *dic = [noti userInfo];
    NSString *info = [dic objectForKey:@"goods_no"];
    self.bianhaoLabel.text = info;
}
- (void)refreshWithDict:(NSDictionary *)dict {
    if ([[dict allKeys] count] == 0) {
        return;
    }
    GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dict[@"detail"]];
    self.jiaweiLabel.text = model.goods_price;
    self.chandiLabel.text = model.place_origin;

    self.bianhaoLabel.text = [NSString stringWithFormat:@"%@",model.goods_no];
    NSDictionary *category = model.category;
    self.fenleiLabel.text = category[@"name"];
    self.baozhuangLabel.text = model.packing;
    NSArray *imageArray = model.contentimages;
    NSString *imgStr = @"";
    for (int i = 0; i < imageArray.count; i++) {
        imgStr = [NSString stringWithFormat:@"%@<img src=\"%@\" width=\"100%%\">", imgStr, imageArray[i]];
    }
    NSString *content = [NSString stringWithFormat:@"<!DOCTYPE html><html><head><meta charset=\"utf-8\"><title></title></head><body><div>%@</div></body></html>", imgStr];

    [self.webView loadHTMLString:content baseURL:nil];
}
#pragma mark - webView delegate方法

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    // 获取webView的高度
    CGFloat webViewHeight = [[self.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"] floatValue];
    self.webViewHeight.constant = webViewHeight;
    self.scrollViewHeight.constant = 298 + webViewHeight;
    [self.view layoutIfNeeded];
}
#pragma mark - XibFunction
//加入材料单
- (IBAction)jiarucailiaodan:(id)sender {
}
//材料车
- (IBAction)cailiaoche:(id)sender {
}
//加入材料车
- (IBAction)jiarucailiaoche:(id)sender {
}

//店铺
- (IBAction)mallBtnClick:(id)sender {
    self.hidesBottomBarWhenPushed = YES;
    StoreDetailViewController *vc = [[StoreDetailViewController alloc] init];
    vc.seller_id = self.mallId;
    [self.navigationController pushViewController:vc animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
//在线咨询
- (IBAction)callBtnClick:(id)sender {
   
    NSDictionary *dict = @{
                           @"user_id": @(self.mallId)
                           };
    [DZNetworkingTool postWithUrl:kFriendDetails
                           params:dict
                          success:^(NSURLSessionDataTask *task, id responseObject) {
                              if ([responseObject[@"code"] intValue] == SUCCESS) {
                                  NSDictionary *dict = responseObject[@"data"];
                                  
                                  NSString *headImg = dict[@"avatar"];
                                  NSString *title = dict[@"nickname"];
//                                  self.phoneStr = dict[@"mobile"];
                                  
                                  //会话列表
                                  ChatViewController *conversationVC = [[ChatViewController alloc] init];
                                  conversationVC.hidesBottomBarWhenPushed = YES;
                                  conversationVC.conversationType = ConversationType_PRIVATE;
                                  conversationVC.targetId = [NSString stringWithFormat:@"%ld",self.mallId ];
                                  conversationVC.title = title;
                                  
                                  
                                  RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                                  rcduserinfo_.name = title;
                                  rcduserinfo_.userId = [NSString stringWithFormat:@"%ld",self.mallId];
                                  rcduserinfo_.portraitUri = headImg;
                                  
                                  
                                  [self.navigationController pushViewController:conversationVC animated:YES];
                                  
                              } else {
                                  [DZTools showNOHud:responseObject[@"msg"] delay:2];
                                  
                              }
                          }
                           failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
                               
                               [DZTools showNOHud:RequestServerError delay:2.0];
                           }
                        IsNeedHub:NO];

}
//购物车
- (IBAction)cartBtnCLick:(id)sender {
    self.tabBarController.selectedIndex = 3;
    [self.navigationController popToRootViewControllerAnimated:NO];
    
}





@end
