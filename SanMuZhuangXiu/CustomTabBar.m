//
//  CustomTabBar.m
//  ShenglongLive
//
//  Created by benbenkeji on 2017/12/13.
//  Copyright © 2017年 尹冲. All rights reserved.
//

#import "CustomTabBar.h"
//#import "PublishViewController.h"
#import "LoginViewController.h"
@implementation CustomTabBar

- (UIButton *)publishButton {
    if (!_publishButton) {
        _publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_publishButton setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateHighlighted];
        [_publishButton setImage:[UIImage imageNamed:@"nav_menu"] forState:UIControlStateNormal];
        // 发布按钮的点击事件
        [_publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_publishButton];
    }
    return _publishButton;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    /**** 设置所有UITabBarButton的frame ****/
    // 按钮的尺寸
    CGFloat buttonW = self.frame.size.width / 5;
    CGFloat buttonH = 49;
    CGFloat buttonY = 0;
    // 按钮索引
    int buttonIndex = 0;
    
    for (UIView *subview in self.subviews) {
        // 过滤掉非UITabBarButton
        //   if (![@"UITabBarButton" isEqualToString:NSStringFromClass(subview.class)]) continue;
        if (subview.class != NSClassFromString(@"UITabBarButton")) continue;
        
        // 设置frame
        CGFloat buttonX = buttonIndex * buttonW;
        // 把发布按钮的位置预留出来
        if (buttonIndex >= 2) { // 右边的2个UITabBarButton
            buttonX += buttonW;
        }
        subview.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        // 增加索引
        buttonIndex++;
    }
    
    /**** 设置中间的发布按钮的frame ****/
    self.publishButton.frame = CGRectMake(0, 0, buttonH, buttonH);
    self.publishButton.center = CGPointMake(self.frame.size.width * 0.5, 49 * 0.5);
//    //设置文字偏移：向下偏移图片高度＋向左偏移图片宽度 （偏移量是根据［图片］大小来的，这点是关键）
//    self.publishButton.titleEdgeInsets = UIEdgeInsetsMake(self.publishButton.imageView.frame.size.height + 10, -self.publishButton.imageView.frame.size.width, 0, 0);
//    //设置图片偏移：向上偏移文字高度＋向右偏移文字宽度 （偏移量是根据［文字］大小来的，这点是关键）
//    self.publishButton.imageEdgeInsets = UIEdgeInsetsMake(-self.publishButton.titleLabel.frame.size.height + 5, 0, 0, -self.publishButton.titleLabel.frame.size.width);
    
}

-(void)publishClick{
    if (![DZTools islogin]) {
        LoginViewController *login = [LoginViewController new];
        [[DZTools topViewController] presentViewController:login animated:YES completion:nil];
        
        return;
    }
//    PublishViewController *publish = [[PublishViewController alloc] init];
//    [[DZTools topViewController] presentViewController:publish animated:YES completion:nil];
//    [WebServiceTool requestWithURL:Pass Params:@{@"uid":[UserInfoManager shareManger].uid} Success:^(id responseObject) {
//
//        int data = [responseObject[@"data"] intValue];
//        if (data == 0) {
//            [AlertUtil showAlertWithText:@"您尚未进行主播认证审,请认证后再开启直播!"];
//        }else if (data == 1){
//            [AlertUtil showAlertWithText:@"您申请的认证正在审核中"];
//        }else if (data == 2){
//            [AlertUtil showAlertWithText:@"您申请的认证审核未通过,请重新审核!"];
//        }else{
//            PublishViewController *publish = [[PublishViewController alloc] init];
//            [[DZTools topViewController] presentViewController:publish animated:YES completion:nil];
//        }
//
//
//    } Fail:^(NSError *error) {
//        [AlertUtil showAlertWithText:@"服务器异常,请稍后重试!"];
//
//    } requestMethod:GetMethod];
}

@end
