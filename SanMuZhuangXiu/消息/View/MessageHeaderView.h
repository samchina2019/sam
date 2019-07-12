//
//  MessageHeaderView.h
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageHeaderView : UIView

@property (weak, nonatomic) IBOutlet UIView *bgView1;
@property (weak, nonatomic) IBOutlet UIView *bgView2;
@property (weak, nonatomic) IBOutlet UIView *bgView3;
@property (weak, nonatomic) IBOutlet UIView *bgView4;
@property (weak, nonatomic) IBOutlet UIView *bgView5;
@property (weak, nonatomic) IBOutlet UIView *bgView6;
@property (weak, nonatomic) IBOutlet UILabel *xtContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *kqContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *wlContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *huodongContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *kefuContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *xtnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *kqnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *wlnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *huodongnumLabel;
@property (weak, nonatomic) IBOutlet UILabel *kefunumLabel;


@property (copy, nonatomic) void(^block)(NSInteger type);

@end

NS_ASSUME_NONNULL_END
