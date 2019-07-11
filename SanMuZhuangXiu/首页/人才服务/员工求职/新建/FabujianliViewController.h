//
//  FabujianliViewController.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/2.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DZBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FabujianliViewController : DZBaseViewController
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,assign)NSInteger fabuId;

@end

NS_ASSUME_NONNULL_END
