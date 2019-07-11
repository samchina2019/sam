//
//  CongxinBpViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/12.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
@class StuffListModel;
NS_ASSUME_NONNULL_BEGIN

@interface CongxinBpViewController : DZBaseViewController
@property(nonatomic,strong)NSString *stuff_cart_id;
@property (nonatomic, strong) StuffListModel* stufflistModel;

///选择商家修改时使用 多个逗号隔开
@property (strong, nonatomic) NSString *data_id;
///是否来自报价单
@property (nonatomic, assign) BOOL isFromBaojiadan;
@end

NS_ASSUME_NONNULL_END
