//
//  YanshouHuoViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/13.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YanshouHuoViewController : DZBaseViewController
@property(nonatomic,assign)int orderId;
@property (assign, nonatomic) int type;
@property (strong, nonatomic) NSDictionary *dataDic;

@end

NS_ASSUME_NONNULL_END
