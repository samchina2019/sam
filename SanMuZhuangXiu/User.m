//
//  User.m
//  HNPartyBuilding
//
//  Created by 赵江伟 on 2018/3/10.
//  Copyright © 2018年 HenanUnicom. All rights reserved.
//

#import "User.h"

@implementation User
//添加了下面的宏定义
MJExtensionCodingImplementation
/* 实现下面的方法，说明哪些属性不需要归档和解档 */
+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[];
}

+ (void)saveUser:(User *)user{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:@"userInfo"];
    if (user.token) {
        [defaults setObject:user.token forKey:Token];
        [defaults setObject:[NSString stringWithFormat:@"%ld",(long)user.user_id] forKey:UserID];
    }
    [defaults synchronize];
}


+ (User *)getUser{
    User *user = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"]];
    return user;
}

+ (void)deleUser{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:nil forKey:@"userInfo"];
    [defaults setValue:nil forKey:UserID];
    [defaults setValue:nil forKey:Token];
    [defaults setValue:nil forKey:IMToken];
    [defaults synchronize];
}

+ (NSString *)getUserID {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:UserID];
}

+ (NSString *)getToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:Token];
}

+ (NSString *)getIMToken {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:IMToken];
}

@end
