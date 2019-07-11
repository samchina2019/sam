//
//  ZuJiListModel.m
//  SanMuZhuangXiu
//
//  Created by DairusZhao on 2019/4/22.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "ZuJiListModel.h"

@implementation ZuJiListModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"zuji_id": @"id",
             @"man":@"goto"};
}

@end
