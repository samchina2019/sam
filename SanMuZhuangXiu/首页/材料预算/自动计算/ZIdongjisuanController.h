//
//  ZIdongjisuanController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

@class ZIdongjisuanController;

NS_ASSUME_NONNULL_BEGIN

@protocol ZIdongjisuanControllerDelegate <NSObject>
@required
- (NSMutableArray *)ZidongjisuanView:(ZIdongjisuanController *)cailiaoController;

@end

@interface ZIdongjisuanController : DZBaseViewController
@property (strong, nonatomic) IBOutlet UIScrollView *shengchengScrollView;
@property (nonatomic, weak) id<ZIdongjisuanControllerDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
