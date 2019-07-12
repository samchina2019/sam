//
//  SelectStoreModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/1.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectStoreModel : NSObject
//
@property(nonatomic,assign)int ad;
@property(nonatomic,assign)int receipt_id;
//
@property(nonatomic,assign)int seller_id;
//
@property(nonatomic,assign)float price;
//
@property(nonatomic,assign)float distance;
//
@property(nonatomic,strong)NSDictionary *seller;
@property(nonatomic,assign)float level;
@property(nonatomic,assign)int match;
@property(nonatomic,assign)float taxes_increment;
@property(nonatomic,assign)float taxes;
@end

NS_ASSUME_NONNULL_END
