//
//  BlockAlertView.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/7.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "BlockAlertView.h"
@interface BlockAlertView()
/** 弹窗主内容view */
@property (nonatomic,strong) UIView   *contentView;
@end
@implementation BlockAlertView


- (instancetype)initWithdelegate:(id)delegate {
    if (self = [super init]) {
        
        self.delegate = delegate;
      
        // UI搭建
        [self setupUI];
    }
    return self;
}
/** 带block回调的弹窗 */
-(void)setupUI{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    //------- 弹窗主内容 -------//
    self.contentView = [[UIView alloc] init];
    self.contentView.frame =CGRectMake((ViewWidth-280)/2, (ViewHeight-240)/2, 280, 240);
    self.contentView.center = self.center;
    [self addSubview:self.contentView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 3;

    UIView *linemView=[[UIView alloc]init];

        linemView.frame=CGRectMake(0, 10, 280, 40);

    linemView.tag=0;
    [self.contentView addSubview:linemView];
    
    UIButton *btn =[[UIButton alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"icon_Radio_pre"] forState:UIControlStateNormal];
    btn.tag=0;
    [btn setImage:[UIImage imageNamed:@"icon_Radio"] forState:UIControlStateSelected];
    [linemView addSubview:btn];
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn.frame), 10, linemView.bounds.size.width-CGRectGetMaxX(btn.frame)-10, 20)];
    [linemView addSubview:titleLabel];
    titleLabel.tag=0;
    
    titleLabel.text=@"商家不能代购，取消订单，退全款";
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"商家不能代购，取消订单，退全款" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    titleLabel.attributedText = string;
   
    UIView *linemView1=[[UIView alloc]init];
    
    linemView1.frame=CGRectMake(0, CGRectGetMaxY(linemView.frame), 280, 40);
    
    linemView1.tag=1;
    [self.contentView addSubview:linemView1];
    
    UIButton *btn1 =[[UIButton alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    [btn1 setImage:[UIImage imageNamed:@"icon_Radio_pre"] forState:UIControlStateNormal];
    btn1.tag=1;
    [btn1 setImage:[UIImage imageNamed:@"icon_Radio"] forState:UIControlStateSelected];
    [linemView1 addSubview:btn1];
    [btn1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel1=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn1.frame), 10, linemView.bounds.size.width-CGRectGetMaxX(btn1.frame)-10, 20)];
    [linemView1 addSubview:titleLabel1];
    titleLabel1.tag=1;
    
    titleLabel1.text=@"商家不能代购，退代购款";
    NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:@"商家不能代购，退代购款" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    titleLabel1.attributedText = string1;
    
    
    
    UIView *linemView2=[[UIView alloc]init];
    
    linemView2.frame=CGRectMake(0, CGRectGetMaxY(linemView1.frame), 280, 40);
    
    linemView2.tag=2;
    [self.contentView addSubview:linemView2];
    
    UIButton *btn2 =[[UIButton alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    [btn2 setImage:[UIImage imageNamed:@"icon_Radio_pre"] forState:UIControlStateNormal];
    btn2.tag=2;
    [btn2 setImage:[UIImage imageNamed:@"icon_Radio"] forState:UIControlStateSelected];
    [linemView2 addSubview:btn2];
    [btn2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel2=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn2.frame), 10, linemView.bounds.size.width-CGRectGetMaxX(btn2.frame)-10, 20)];
    [linemView2 addSubview:titleLabel2];
    titleLabel2.tag=2;
    
    titleLabel2.text=@"代购部分缺货，退未购款";
    NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:@"代购部分缺货，退未购款" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    titleLabel2.attributedText = string2;
    
    
    UIView *linemView3=[[UIView alloc]init];
    
    linemView3.frame=CGRectMake(0, CGRectGetMaxY(linemView2.frame), 280, 40);
    
    linemView3.tag=3;
    [self.contentView addSubview:linemView3];
    
    UIButton *btn3 =[[UIButton alloc]initWithFrame:CGRectMake(20, 10, 20, 20)];
    [btn3 setImage:[UIImage imageNamed:@"icon_Radio_pre"] forState:UIControlStateNormal];
    btn3.tag=3;
    [btn3 setImage:[UIImage imageNamed:@"icon_Radio"] forState:UIControlStateSelected];
    [linemView3 addSubview:btn3];
    [btn3 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titleLabel3=[[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(btn3.frame), 10, linemView3.bounds.size.width-CGRectGetMaxX(btn3.frame)-10, 20)];
    [linemView3 addSubview:titleLabel3];
    titleLabel3.tag=3;
    
    titleLabel3.text=@"不需要代购，仅购买本店商品";
    NSMutableAttributedString *string3 = [[NSMutableAttributedString alloc] initWithString:@"不需要代购，仅购买本店商品" attributes:@{NSFontAttributeName: [UIFont fontWithName:@"PingFang-SC-Regular" size: 14],NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]}];
    
    titleLabel3.attributedText = string3;
    
    
    UIButton *btn4 =[[UIButton alloc]initWithFrame:CGRectMake((self.contentView.bounds.size.width-80)/2, CGRectGetMaxY(linemView3.frame)+10, 80, 30)];
    btn4.backgroundColor=[UIColor colorWithRed:63/255.0 green:174/255.0 blue:233/255.0 alpha:1.0];
    [btn4.titleLabel setTextColor:[UIColor whiteColor]];
    [btn4 setTitle:@"确定" forState:UIControlStateNormal];
    [btn4.titleLabel setFont:[UIFont systemFontOfSize:14]];
    btn4.layer.cornerRadius=3;
    btn4.clipsToBounds=YES;
    [self.contentView addSubview:btn4];
    [btn4 addTarget:self action:@selector(sureBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}
-(void)sureBtnClick:(UIButton *)btn{
    if ([self.delegate respondsToSelector:@selector(AlertView:clickedButtonWithTag:)]) {
        [self.delegate AlertView:self clickedButtonWithTag:btn.tag];
    }
}
-(void)btnClick:(UIButton *)btn{
    if (btn.tag==0) {
        
    }
    btn.selected=!btn.selected;
    if ([self.delegate respondsToSelector:@selector(AlertView:clickedButtonWithTag:)]) {
        [self.delegate AlertView:self clickedButtonWithTag:btn.tag];
    }
}
/** 弹出此弹窗 */
- (void)show {
    // 出场动画
    self.alpha = 0;
    self.contentView.transform = CGAffineTransformScale(self.contentView.transform, 1.3, 1.3);
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
        self.contentView.transform = CGAffineTransformIdentity;
    }];
    
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
}
/** 移除此弹窗 */
- (void)dismiss {
    [self removeFromSuperview];
}
@end
