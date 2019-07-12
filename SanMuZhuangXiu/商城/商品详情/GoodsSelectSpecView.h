//
//  GoodsSelectSpecView.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/5/19.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPNumberButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface GoodsSelectSpecView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet PPNumberButton *numberBtn;
@property (weak, nonatomic) IBOutlet UITableView *guigeView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, strong) NSString *imageStr;

@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *pingPaiArray;
@property(nonatomic,strong) NSDictionary *dataDict;

@property(nonatomic,assign)int cartTiaozhuan;//1,购物车，2立即购买

@property (copy, nonatomic) void(^sureBlock)(NSString *num, NSString *guigeID, NSString *guigeName, NSString *goods_spec_id, NSString *pingPaiID, NSString *goods_name, NSString *goods_price, NSString *pingPaiName,int cartTiaozhuan );
@property (copy, nonatomic) void(^deleteBlock)(void);//清空

@end

NS_ASSUME_NONNULL_END
