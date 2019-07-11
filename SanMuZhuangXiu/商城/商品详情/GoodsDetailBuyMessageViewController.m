//
//  GoodsDetailBuyMessageViewController.m
//  SanMuZhuangXiu
//
//  Created by 犇犇网络 on 2019/1/9.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GoodsDetailBuyMessageViewController.h"
#import "GoodsDetailModel.h"
#import "StoreDetailViewController.h"
#import "ChatViewController.h"
@interface GoodsDetailBuyMessageViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation GoodsDetailBuyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self refreshWithDict:self.dataDict];
}

- (void)refreshWithDict:(NSDictionary *)dict {
    if ([[dict allKeys] count] == 0) {
        return;
    }
    GoodsDetailModel *model = [GoodsDetailModel mj_objectWithKeyValues:dict[@"detail"]];
    self.textView.text = model.instructions;
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
