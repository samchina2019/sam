//
//  EditSpecView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EditSpecView : UIView
@property (weak, nonatomic) IBOutlet UITableView *guigeView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property(nonatomic,strong)NSMutableArray *selectDataArray;
@property(nonatomic,strong)NSMutableArray *dataArray;

///block
@property (copy, nonatomic) void(^sureBlock)(NSArray *array);
@property (copy, nonatomic) void(^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
