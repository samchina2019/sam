//
//  QiyeViewCell.m
//  SanMuZhuangXiu
//
//  Created by benben on 2019/3/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "QiyeViewCell.h"
#import "UIView+Corner.h"

@implementation QiyeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    //阴影的颜色
    self.bgView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    //阴影的透明度
    self.bgView.layer.shadowOpacity = 0.5f;
    //阴影的圆角
    self.bgView.layer.shadowRadius = 3.f;
    //阴影偏移量
    self.bgView.layer.shadowOffset = CGSizeMake(0,0);
    self.bgView.layer.cornerRadius = 3;
//
//
//    //设置圆角的半径
////    [self.baoShiSuBtn.layer setCornerRadius:6.5];
//    //设置左上角和右下角为圆角
//    UIBezierPath *maskPath=[UIBezierPath bezierPathWithRoundedRect:
//                            self.baoShiSuBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
//
//
//    CAShapeLayer *maskLayer=[[CAShapeLayer alloc]init];
//    maskLayer.frame=self.baoShiSuBtn.bounds;
//    maskLayer.path=maskPath.CGPath;
//    self.baoShiSuBtn.layer.mask=maskLayer;
//    //切割超出圆角范围的子视图
//    self.baoShiSuBtn.layer.masksToBounds = YES;
//    //设置边框的颜色
//    [self.baoShiSuBtn.layer setBorderColor:[UIColor colorWithRed:0/255.0 green:138/255.0 blue:255/255.0 alpha:1.0].CGColor];
//    //设置边框的粗细
//    [self.baoShiSuBtn.layer setBorderWidth:1.0];
//
//
////    设置圆角的半径
////    [self.shuangxiuBtn.layer setCornerRadius:6.5];
//    //切割超出圆角范围的子视图
//    self.shuangxiuBtn.layer.masksToBounds = YES;
//    //设置左上角和右下角为圆角
//
//    UIBezierPath *sxmaskPath=[UIBezierPath bezierPathWithRoundedRect:
//                            self.shuangxiuBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
//
//    CAShapeLayer *sxmaskLayer=[[CAShapeLayer alloc]init];
//    sxmaskLayer.frame=self.shuangxiuBtn.bounds;
//    sxmaskLayer.path=sxmaskPath.CGPath;
//    self.shuangxiuBtn.layer.mask=sxmaskLayer;
//    //设置边框的颜色
//    [self.shuangxiuBtn.layer setBorderColor:[UIColor colorWithRed:26/255.0 green:188/255.0 blue:156/255.0 alpha:1.0].CGColor];
//    //设置边框的粗细
//    [self.shuangxiuBtn.layer setBorderWidth:1.0];
//
//    //设置圆角的半径
////    [self.wuxianyijinBtn.layer setCornerRadius:6.5];
//
//    //设置左上角和右下角为圆角
//    UIBezierPath *wxmaskPath=[UIBezierPath bezierPathWithRoundedRect:
//                               self.wuxianyijinBtn.bounds byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomRight cornerRadii:CGSizeMake(10,10)];
//
//    CAShapeLayer *wxmaskLayer=[[CAShapeLayer alloc]init];
//    wxmaskLayer.frame=self.wuxianyijinBtn.bounds;
//    wxmaskLayer.path=wxmaskPath.CGPath;
//    self.wuxianyijinBtn.layer.mask=wxmaskLayer;
//    //切割超出圆角范围的子视图
//   self.wuxianyijinBtn.layer.masksToBounds = YES;
//    //设置边框的颜色
//    [self.wuxianyijinBtn.layer setBorderColor:[UIColor colorWithRed:255/255.0 green:148/255.0 blue:0/255.0 alpha:1.0].CGColor];
//    //设置边框的粗细
//    [self.wuxianyijinBtn.layer setBorderWidth:1.0];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
