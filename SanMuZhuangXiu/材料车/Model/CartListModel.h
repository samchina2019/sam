//
//  CartListModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/29.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CartListModel : NSObject
//材料车id
@property(nonatomic,assign)NSInteger stuff_cart_id;
//材料种类
@property(nonatomic,assign)NSInteger stuff_count;
//材料数量
@property(nonatomic,assign)NSInteger stuff_number;
//材料单名称
@property(nonatomic,strong)NSString *name;
//地址
@property(nonatomic,strong)NSString *address;
//更新时间
@property(nonatomic,strong)NSString *updatetime;
//状态值:-1=禁用,0=自动保存,1=等待发布（未采购）,2=发布采购报价中（未采购）,3=交易中（已采购）,4=交易完成,5=交易失败',
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *share;
@property(nonatomic,strong)NSString *sharename;


@end

NS_ASSUME_NONNULL_END
