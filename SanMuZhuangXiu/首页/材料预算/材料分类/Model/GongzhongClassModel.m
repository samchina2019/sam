//
//  GongzhongClassModel.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "GongzhongClassModel.h"

@implementation GongzhongClassModel

+(instancetype)gongzhongClassWithDict:(NSDictionary *)dict{
    return [[self alloc]initWithDict:dict];
}
-(instancetype)initWithDict:(NSDictionary *)dict{
    if ([super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}
@end
