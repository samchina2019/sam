
//
//  DaKaListModel.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/4/26.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "DaKaListModel.h"

@implementation DaKaListModel
//添加了下面的宏定义
MJExtensionCodingImplementation
/* 实现下面的方法，说明哪些属性不需要归档和解档 */
+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[];
}

+ (void)saveDakaInfo:(DaKaListModel *)dakaInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:dakaInfo] forKey:@"dakaInfo"];
   
    [defaults synchronize];
}
+ (DaKaListModel *)getdakaInfo{
    DaKaListModel *dakaInfo = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"dakaInfo"]];
    return dakaInfo;
}
+ (void)deledakaInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:@"dakaInfo"];
    [defaults synchronize];
}
@end
