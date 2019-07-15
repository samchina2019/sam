//
//  SelectSpecView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/14.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StuffListModel.h"
#import "AddGuiGe.h"
NS_ASSUME_NONNULL_BEGIN

@interface SelectSpecView : UIView
@property (weak, nonatomic) IBOutlet UIView *MiddleView;
@property (strong, nonatomic)  UITableView *guigetableView;
@property (strong, nonatomic)  UITableView *tableView;
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


@property (strong, nonatomic)AddGuiGe*AddGuiGeView;
//材料名称 选择弹框
@property (strong, nonatomic)  UITextField*xuanzefild;
@property (strong, nonatomic) StuffListModel *model;

@property (copy, nonatomic) void (^sureBlock)(NSArray *array);
@property (copy, nonatomic) void (^deleteBlock)(void);
@property (copy, nonatomic) void(^pinpaiBlock)(NSString*name);
@property (copy, nonatomic) void (^tianjiaBlock)(void);
@end

NS_ASSUME_NONNULL_END
