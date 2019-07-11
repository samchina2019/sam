//
//  QiyeGangweiDetailController.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/4.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QiyeGangweiDetailController.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>

@interface QiyeGangweiDetailController ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
//公司名称
@property (weak, nonatomic) IBOutlet UILabel *gognsiNameLabel;
//工种
@property (weak, nonatomic) IBOutlet UILabel *gongzhongLabel;
//学历要求
@property (weak, nonatomic) IBOutlet UILabel *xueliYaoqiuLabel;
//薪资¥5000
@property (weak, nonatomic) IBOutlet UILabel *xinziLabel;
//招聘人数
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
//联系电话
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
//公司邮箱
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
//工作地址
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
//福利待遇
@property (weak, nonatomic) IBOutlet UILabel *daiyulabel;


@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *phoneStr;
@end

@implementation QiyeGangweiDetailController
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
      [self loadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"岗位详情";
  
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
}

#pragma mark – Network

-(void)loadData{
    NSDictionary *params = @{
                         
                             @"id":@(self.idStr)
                             };
    [DZNetworkingTool postWithUrl:kQiyeWorkInfo params:params success:^(NSURLSessionDataTask *task, id responseObject) {
       
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            NSDictionary *dict = responseObject[@"data"];
            self.userId=[NSString stringWithFormat:@"%@",dict[@"user_id"]];
            self.phoneStr=[NSString stringWithFormat:@"%@",dict[@"telephone"]];
            if ([dict[@"company_address"] length] == 0) {
                self.addressLabel.text = @"暂无地址";
            }else{
                self.addressLabel.text=[NSString stringWithFormat:@"%@",dict[@"company_address"]];
            }
           
            self.gongzhongLabel.text=[NSString stringWithFormat:@"%@",dict[@"recruitment_post"]];
            self.xueliYaoqiuLabel.text=[NSString stringWithFormat:@"%@|%@",dict[@"education"],dict[@"work_year"]];
//            ¥8000/月
            self.xinziLabel.text=[NSString stringWithFormat:@"¥%@",dict[@"salary"]];
            self.numberLabel.text=[NSString stringWithFormat:@"%@",dict[@"recruitment_number"]];
            if ([dict[@"telephone"] length] == 0) {
                 self.phoneLabel.text=@"暂无电话";
            }else{
                 self.phoneLabel.text=[NSString stringWithFormat:@"%@",dict[@"telephone"]];
            }
           
            self.emailLabel.text=[NSString stringWithFormat:@"%@",dict[@""]];
          
            NSString *is_rest=@"";
            
            if ([dict[@"is_rest"] isEqualToString:@"10"]) {
                is_rest=@"双休";
            }else{
                is_rest=@"单休";
            }
            NSString *putup=@"";
            if ([dict[@"putup"] isEqualToString:@"10"]) {
                putup=@"提供";
            }else{
                putup=@"不提供";
            }
            
            NSString *risks_gold=@"";
            if ([dict[@"risks_gold"] isEqualToString:@"10"]) {
                risks_gold=@"有五险一金";
            }else{
                risks_gold=@"没有五险一金";
            }
            self.daiyulabel.text=[NSString stringWithFormat:@"%@,%@,%@",is_rest,putup,risks_gold];

        }else
        {
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
       
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];

}
#pragma mark - Function
//在线联系
-(void)onlineSure{
    if (self.userId.length == 0) {
        [DZTools showNOHud:@"暂无数据" delay:2];
        return;
    }
    
    NSDictionary *dict=@{
                         @"user_id":self.userId
                         };
    [DZNetworkingTool postWithUrl:kFriendDetails params:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue ] ==SUCCESS) {
            NSDictionary *dict=responseObject[@"data"];
            //            NSString *userId=dict[@"user_id"];
            NSString *headImg=dict[@"avatar"];
            NSString *title=dict[@"nickname"];
            self.phoneStr=dict[@"mobile"];
            //会话列表
            ChatViewController *conversationVC = [[ChatViewController alloc] init];
            conversationVC.hidesBottomBarWhenPushed = YES;
            conversationVC.conversationType = ConversationType_PRIVATE;
            conversationVC.targetId = [NSString stringWithFormat:@"%@",self.userId ];
            conversationVC.title =title;
            
            RCUserInfo *rcduserinfo_ = [RCUserInfo new];
            rcduserinfo_.name = title;
            rcduserinfo_.userId = self.userId;
            rcduserinfo_.portraitUri = headImg;
            [[RCIM sharedRCIM] refreshUserInfoCache:rcduserinfo_ withUserId:self.userId];
            
            [self.navigationController pushViewController:conversationVC animated:YES];
            
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:responseObject[@"msg"] delay:2];
    } IsNeedHub:NO];
}
#pragma mark --XibFunction
//打电话
- (IBAction)callBtnClick:(id)sender {
    
    
    if (self.phoneStr.length == 0) {
        [DZTools showNOHud:@"暂无数据" delay:2];
        return;
    }
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel:%@", self.phoneStr];
    UIWebView *callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];
}
//在线联系
- (IBAction)onLineBtnClick:(id)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"需要消耗100积分\n进入在线联系页面" preferredStyle:UIAlertControllerStyleAlert];
    // 使用富文本来改变alert的title字体大小和颜色
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:@"提示"];
    [title addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    [title addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] range:NSMakeRange(0, 2)];
    [alert setValue:title forKey:@"attributedTitle"];
    
    // 使用富文本来改变alert的message字体大小和颜色
    // NSMakeRange(0, 14) 代表:从0位置开始 14个字符
    NSMutableAttributedString *message = [[NSMutableAttributedString alloc] initWithString:@"需要消耗100积分\n进入在线联系页面"];
    
    [message addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, 18)];
    
    [message addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:250/255.0 green:84/255.0 blue:88/255.0 alpha:1.0] range:NSMakeRange(4, 3)];
    
    [alert setValue:message forKey:@"attributedMessage"];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self   onlineSure];
    }];
    
    //    // 设置按钮的title颜色
    [cancelAction setValue:[UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [cancelAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    //
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    // 设置按钮的title颜色
    [okAction setValue:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0] forKey:@"titleTextColor"];
    //
    //    // 设置按钮的title的对齐方式
    [okAction setValue:[NSNumber numberWithInteger:NSTextAlignmentCenter] forKey:@"titleTextAlignment"];
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
   
}

@end
