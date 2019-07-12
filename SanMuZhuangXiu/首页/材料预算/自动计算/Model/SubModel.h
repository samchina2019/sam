//
//  SubModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SubModel : NSObject
//品牌id
@property(nonatomic,assign)int project_id;
//
@property(nonatomic,assign)int spec_id;
//名称
@property(nonatomic,strong)NSString *name;
@end

NS_ASSUME_NONNULL_END
