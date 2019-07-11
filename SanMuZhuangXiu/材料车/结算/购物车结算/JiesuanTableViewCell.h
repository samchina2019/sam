//
//  JiesuanTableViewCell.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/21.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReLayoutButton.h"
#import "CartSellerModel.h"
#import "CartGoodListModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface JiesuanTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet ReLayoutButton *fapiaoBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *youhuiquanBtn;
@property (weak, nonatomic) IBOutlet ReLayoutButton *jifenBtn;
@property (weak, nonatomic) IBOutlet UILabel *yunfeiLabel;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UILabel *youhuiquanLabel;
@property (weak, nonatomic) IBOutlet UILabel *shuijinLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UITableView *cellTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeight;

@property(nonatomic ,strong) CartSellerModel *model;

@property(nonatomic,strong)NSMutableArray *dataArray;
//block
@property (copy, nonatomic) void(^fapiaoBlock)(void);
@property (copy, nonatomic) void(^jifenBlock)(BOOL isSelect);
@property (copy, nonatomic) void(^youhuiquanBlock)(void);
@end

NS_ASSUME_NONNULL_END
