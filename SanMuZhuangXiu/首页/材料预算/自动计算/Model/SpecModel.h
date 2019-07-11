//
//  SpecModel.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/3.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SpecModel : NSObject
//工种ID
@property(nonatomic,assign)int project_id;
//工种ID
@property(nonatomic,assign)int spec_id;
//名称
@property(nonatomic,strong)NSString *name;

//材料分类
@property(nonatomic,strong)NSArray *sub;
@property(nonatomic,strong)NSDictionary *selectSub;
@end

NS_ASSUME_NONNULL_END
