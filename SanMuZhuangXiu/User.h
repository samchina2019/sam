//
//  User.h
//  HNPartyBuilding
//
//  Created by 赵江伟 on 2018/3/10.
//  Copyright © 2018年 HenanUnicom. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject<NSCoding>

@property (nonatomic, assign) NSInteger user_id;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *money;
@property (nonatomic, assign) NSInteger score;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) NSInteger createtime;
@property (nonatomic, assign) NSInteger expiretime;
@property (nonatomic, assign) NSInteger expires_in;


+ (void)saveUser:(User *)user;
+ (User *)getUser;
+ (void)deleUser;
+ (NSString *)getUserID;
+ (NSString *)getToken;
+ (NSString *)getIMToken;

@end
