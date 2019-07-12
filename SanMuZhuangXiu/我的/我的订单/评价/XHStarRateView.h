//
//  XHStarRateView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class XHStarRateView;
typedef void(^finishBlock)(CGFloat currentScore);
typedef NS_ENUM(NSInteger, RateStyle)
{
    WholeStar = 0, //只能整星评论
    HalfStar = 1,  //允许半星评论
    IncompleteStar = 2  //允许不完整星评论
};
@protocol XHStarRateViewDelegate <NSObject>
-(void)starRateView:(XHStarRateView *)starRateView currentScore:(CGFloat)currentScore;
@end
@interface XHStarRateView : UIView
@property (nonatomic,assign)BOOL isAnimation;       //是否动画显示，默认NO
@property (nonatomic,assign)RateStyle rateStyle;    //评分样式    默认是WholeStar
@property (nonatomic,assign)CGFloat currentScore;   // 当前评分：0-5  默认0
@property (nonatomic, weak) id<XHStarRateViewDelegate>delegate;
/**
 *通过代理的方法获取当前评分数currentScore
 */
-(instancetype)initWithFrame:(CGRect)frame;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation delegate:(id)delegate;
/**
 *通过Block传值的方法获取当前评分数currentScore
 */
-(instancetype)initWithFrame:(CGRect)frame finish:(finishBlock)finish;
-(instancetype)initWithFrame:(CGRect)frame numberOfStars:(NSInteger)numberOfStars rateStyle:(RateStyle)rateStyle isAnination:(BOOL)isAnimation finish:(finishBlock)finish;

@end

NS_ASSUME_NONNULL_END
