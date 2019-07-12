//
//  GuanlianCailiaoViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/5.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN
typedef void (^myBlock)(NSArray *array);

@interface GuanlianCailiaoViewController : DZBaseViewController
@property(nonatomic, strong) NSArray *totalSelectedStuffList;
@property(nonatomic, copy) myBlock block;
@property (copy, nonatomic) void(^returnBlock)(NSMutableArray  *array);
@property(nonatomic,assign)BOOL isFromTiaoguo;
@end

NS_ASSUME_NONNULL_END

