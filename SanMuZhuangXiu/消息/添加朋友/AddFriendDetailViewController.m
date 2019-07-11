//
//  AddFriendDetailViewController.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/25.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "AddFriendDetailViewController.h"
#import "ChatViewController.h"

@interface AddFriendDetailViewController ()

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIImageView *iconImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIButton *agreeBn;
@property (weak, nonatomic) IBOutlet UIButton *refuseBtn;



@end

@implementation AddFriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title = @"详细资料";
    
    self.bgView1.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView1.layer.shadowOpacity = 0.5f;
    self.bgView1.layer.shadowRadius = 3.f;
    self.bgView1.layer.shadowOffset = CGSizeMake(0,0);
    
    self.bgView2.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    self.bgView2.layer.shadowOpacity = 0.5f;
    self.bgView2.layer.shadowRadius = 3.f;
    self.bgView2.layer.shadowOffset = CGSizeMake(0,0);
    
    self.nameLabel.text = self.model.nickname;
    self.phoneLabel.text = self.model.mobile;
    [self.iconImgV sd_setImageWithURL:[NSURL URLWithString:self.model.avatar] placeholderImage:[UIImage imageNamed:@"img_head"]];
    
    if ([self.model.status intValue] == 2) {
        self.agreeBn.hidden = NO;
        self.refuseBtn.hidden = NO;
    }else if ([self.model.status intValue] == 0) {
        self.agreeBn.hidden = NO;
        self.refuseBtn.hidden = YES;
        [self.agreeBn setTitle:@"发消息" forState:UIControlStateNormal];
    }else {
        self.agreeBn.hidden = YES;
        self.refuseBtn.hidden = YES;
    }
    
    [self getDataFromServer];
}
- (void)getDataFromServer
{
    NSString *url = @"";
    NSDictionary *params = @{};
    if (self.model.apply_id == 0) {
        url = kFriendDetails;
        params = @{@"user_id":@(self.model.user_id)};
    }else{
        url = kApplyFriendDetail;
        params = @{@"apply_id":@(self.model.apply_id)};
    }
   
    [DZNetworkingTool postWithUrl:url params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            if (self.model.apply_id == 0) {
                NSDictionary *dict = responseObject[@"data"];
                self.addressLabel.text = dict[@"nickname"];
                self.fromLabel.text = dict[@"mobile"];
            }else{
                NSDictionary *dict = responseObject[@"data"][0];
                self.addressLabel.text = dict[@"region"];
                self.fromLabel.text = dict[@"source"];
            }
        }else{
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
#pragma mark - XibFunction
//同意
- (IBAction)agreeBtnClicked:(id)sender {
    if ([self.model.status intValue] == 0) {
        RCUserInfo *rcduserinfo_ = [RCUserInfo new];
        rcduserinfo_.name = self.model.nickname;
        rcduserinfo_.userId = [NSString stringWithFormat:@"%ld", (long)self.model.user_id];
        rcduserinfo_.portraitUri = self.model.avatar;
        [[RCIM sharedRCIM] refreshUserInfoCache:rcduserinfo_ withUserId:[NSString stringWithFormat:@"%ld", (long)self.model.user_id]];
        //会话列表
        ChatViewController *conversationVC = [[ChatViewController alloc] init];
        conversationVC.hidesBottomBarWhenPushed = YES;
        conversationVC.conversationType = ConversationType_PRIVATE;
        conversationVC.targetId = [NSString stringWithFormat:@"%ld", (long)self.model.user_id];
        conversationVC.title = self.model.nickname;
        [self.navigationController pushViewController:conversationVC animated:YES];
        return;
    }
    [self requsetServerWithType:@"0"];
}
//拒绝
- (IBAction)refuseBtnClicked:(id)sender {
    [self requsetServerWithType:@"1"];
}
- (void)requsetServerWithType:(NSString *)type
{
    NSDictionary *params = @{@"apply_id":@(self.model.apply_id),
                             @"type":type};
    [DZNetworkingTool postWithUrl:kReceiveFriend params:params success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([responseObject[@"code"] intValue] == SUCCESS) {
            [DZTools showOKHud:responseObject[@"msg"] delay:2];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
             [self.navigationController popViewControllerAnimated:YES];
            [DZTools showNOHud:responseObject[@"msg"] delay:2];
        }
    } failed:^(NSURLSessionDataTask *task, NSError *error, id responseObject) {
        [DZTools showNOHud:RequestServerError delay:2.0];
    } IsNeedHub:NO];
}
@end
