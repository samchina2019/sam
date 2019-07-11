//
//  SelectSpecView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectSpecView : UIView
@property (weak, nonatomic) IBOutlet UITableView *guigetableView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tebleViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hideTableViewHeight;
@property (weak, nonatomic) IBOutlet UIView *footerView;
///材料名称
@property (strong, nonatomic) NSString *name;
@property (nonatomic, assign) BOOL isFromGuanlian;//属否来自关联
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *selectDataArray;

@property (copy, nonatomic) void (^sureBlock)(NSArray *array);
@property (copy, nonatomic) void (^deleteBlock)(void);
@end

NS_ASSUME_NONNULL_END
