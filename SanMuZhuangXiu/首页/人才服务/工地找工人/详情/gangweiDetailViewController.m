//
//  gangweiDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "gangweiDetailViewController.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface gangweiDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
//公司名称 北京***公司
@property (weak, nonatomic) IBOutlet UILabel *gongsiName;
//公种名称 木工
@property (weak, nonatomic) IBOutlet UILabel *gongzhongName;
//工作经验 3年|日工|5人
@property (weak, nonatomic) IBOutlet UILabel *jingyanlabel;
//日薪 ¥300/天
@property (weak, nonatomic) IBOutlet UILabel *paybyDayLabel;
//特长要求：木工
@property (weak, nonatomic) IBOutlet UILabel *techangLabel;
//结算周期 10天
@property (weak, nonatomic) IBOutlet UILabel *jiesuanZhouqiLabel;
//工作地点：
@property (weak, nonatomic) IBOutlet UILabel *gongzuoDizhiLabel;
//上班时间 10天
@property (weak, nonatomic) IBOutlet UILabel *shangbanDate;
//籍贯要求
@property (weak, nonatomic) IBOutlet UILabel *jiguanLabel;
//是否中途支付：否
@property (weak, nonatomic) IBOutlet UILabel *zhifuLabel;
//住宿情况
@property (weak, nonatomic) IBOutlet UILabel *zhusuLabel;
//日工时间
@property (weak, nonatomic) IBOutlet UILabel *rigongTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *guanzhuBtn;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *phoneStr;

@end

@implementation gangweiDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initData];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.title = @"岗位详情";

    self.view.backgroundColor = [UIColor whiteColor];

    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0, 0);
}

#pragma mark – Network

- (void)initData {
    //
    NSDictionary *dict = @{
        @"id": @(self.idStr)
    };
    [DZNetworkingTool postWithUrl:kWorkInfo
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {

            if ([responseObject[@"code"] intValue] == SUCCESS) {

                //            [DZTools showOKHud:responseObject[@"msg"] delay:2];
                NSDictionary *dict = responseObject[@"data"];
                self.gongsiName.text = [NSString stringWithFormat:@"%@", dict[@"name"]];
                self.userId = [NSString stringWithFormat:@"%@", dict[@"user_id"]];
                self.phoneStr = [NSString stringWithFormat:@"%@", dict[@"telephone"]];
                //            self.gongsiName.text=dict[@"name"];
                self.gongzhongName.text = dict[@"jobName"];
                NSString *salary_way = dict[@"salary_way"];
                NSString *xinziStr = @"";
                if ([salary_way isEqualToString:@"10"]) {
                    xinziStr = @"日工";
                } else if ([salary_way isEqualToString:@"20"]) {
                    xinziStr = @"包工";
                }
                if ([dict[@"is_follow"] intValue] == 1) {
                    [self.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
                } else {
                    [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                }
                //            3年 | 日工 | 5人
                self.jingyanlabel.text = [NSString stringWithFormat:@"%@|%@|%@人", dict[@"work_year"], xinziStr, dict[@"recruits_num"]];
                self.paybyDayLabel.text = [NSString stringWithFormat:@"¥%@", dict[@"salary"]];
                self.techangLabel.text = dict[@"speciality"];
                self.jiesuanZhouqiLabel.text = dict[@"settlement_time"];
                self.gongzuoDizhiLabel.text = [NSString stringWithFormat:@"%@%@", dict[@"work_address"], dict[@"work_addressInfo"]];
                self.shangbanDate.text = dict[@"construction_time"];
                self.jiguanLabel.text = dict[@"native_place"];
                NSString *zhifuStr = @"";
                //            是否支出预支：10=是；20=否；
                if ([dict[@"advance"] isEqualToString:@"10"]) {
                    zhifuStr = @"可以预支";
                } else if ([dict[@"advance"] isEqualToString:@"20"]) {
                    zhifuStr = @"不以预知";
                }
                self.zhifuLabel.text = zhifuStr;
                NSString *zhusuStr = @"";
                //            是否提供住宿：10=是；20=否；
                if ([dict[@"putup"] isEqualToString:@"10"]) {
                    zhusuStr = @"提供住宿";
                } else if ([dict[@"putup"] isEqualToString:@"20"]) {
                    zhusuStr = @"不提供住宿";
                }

                self.zhusuLabel.text = zhusuStr;
                self.rigongTimeLabel.text = [NSString stringWithFormat:@"%@", dict[@"daywork_time"]];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {

            [DZTools showNOHud:RequestServerError delay:2.0];
        }
        IsNeedHub:NO];
}
#pragma mark - Function
//确认
- (void)friendPay {
    NSDictionary *dict = @{
        @"user_id": self.userId
    };
    [DZNetworkingTool postWithUrl:kFriendDetails
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                NSDictionary *dict = responseObject[@"data"];
                //            NSString *userId=dict[@"user_id"];
                NSString *headImg = dict[@"avatar"];
                NSString *title = dict[@"nickname"];
                self.phoneStr = dict[@"mobile"];
                //会话列表
                ChatViewController *conversationVC = [[ChatViewController alloc] init];
                conversationVC.hidesBottomBarWhenPushed = YES;
                conversationVC.conversationType = ConversationType_PRIVATE;
                conversationVC.targetId = [NSString stringWithFormat:@"%@", self.userId];
                conversationVC.title = title;

                RCUserInfo *rcduserinfo_ = [RCUserInfo new];
                rcduserinfo_.name = title;
                rcduserinfo_.userId = self.userId;
                rcduserinfo_.portraitUri = headImg;
                [[RCIM sharedRCIM] refreshUserInfoCache:rcduserinfo_ withUserId:self.userId];

                [self.navigationController pushViewController:conversationVC animated:YES];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }
        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}

#pragma mark – XibFunction

//关注
- (IBAction)guanzhuBtnClick:(id)sender {

    NSDictionary *dict = @{
        @"type": @(1),
        @"id": @(self.idStr)
    };
    [DZNetworkingTool postWithUrl:kAddServerFollow
        params:dict
        success:^(NSURLSessionDataTask *task, id responseObject) {
            if ([responseObject[@"code"] intValue] == SUCCESS) {
                [DZTools showOKHud:responseObject[@"msg"] delay:2];
                if ([self.guanzhuBtn.titleLabel.text containsString:@"已关注"]) {
                    [self.guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
                } else {
                    [self.guanzhuBtn setTitle:@"已关注" forState:UIControlStateNormal];
                }
                [self.view layoutIfNeeded];

                //            [self.navigationController popViewControllerAnimated:YES];

            } else {
                [DZTools showNOHud:responseObject[@"msg"] delay:2];
            }

        }
        failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
        IsNeedHub:NO];
}
//在线联系
- (IBAction)onLineBtnClick:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要消耗100积分\n进入在线联系页面" preferredStyle:UIAlertControllerStyleAlert];

    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0] range:NSMakeRange(0, 2)];
    [alert setValue:title forKey:@"attributedTitle"];

    // 使用富文本来改变alert的message字体大小和颜色
    // NSMakeRange(0, 14) 代表:从0位置开始 14个字符
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"需要消耗100积分\n进入在线联系页面"];

    [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 18)];

    [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:250 / 255.0 green:84 / 255.0 blue:88 / 255.0 alpha:1.0] range:NSMakeRange(4, 3)];

    [alert setValue:message forKey:@"attributedMessage"];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认"
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction *_Nonnull action) {
                                                             [self friendPay];
                                                         }];

    //    // 设置按钮的title颜色
    [cancelAction setValue:[UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    //
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *_Nonnull action){

                                                     }];
    // 设置按钮的title颜色
    [okAction setValue:[UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [okAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}



//拨打电话
- (IBAction)callBtnClick:(id)sender {
       NSMutableString* str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneStr];
       UIWebView * callWebview = [[UIWebView alloc] init];
       [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];[self.view addSubview:callWebview];
    

}


@end
