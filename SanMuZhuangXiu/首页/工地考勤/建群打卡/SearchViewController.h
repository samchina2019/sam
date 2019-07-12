//
//  SearchViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/11.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <MAMapKit/MAMapKit.h>
#import "AddressModel.h"
#import <AMapLocationKit/AMapLocationKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface SearchViewController : DZBaseViewController
///是否是搜索的
@property(nonatomic,assign)BOOL isSearch;

@property (nonatomic,copy) void (^mapChangeBlock)(AMapPOI  *tip);
@property (nonatomic,copy) void (^mapChangeBlock1)(AddressModel *model);

@end

NS_ASSUME_NONNULL_END
