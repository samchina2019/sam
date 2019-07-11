//
//  BaojiadanDetailViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import "HYBStarEvaluationView.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaojiadanDetailViewController : DZBaseViewController
///报价单单ID
@property (nonatomic, assign) int receipt_id;
///商铺ID
@property (nonatomic, assign) int seller_id;
///名字
@property(nonatomic,strong)NSString *nameStr;

///后台没有标注的属性，不知道叫什么
@property (nonatomic,strong) NSString *sx;

@property (strong, nonatomic) HYBStarEvaluationView *starView;

///是否来自从新编排 yes是
@property (nonatomic, assign) BOOL isFromCXBinapai;


@end

NS_ASSUME_NONNULL_END
