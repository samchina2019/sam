//
//  UserState.m
//  YoungDrill
//
//  Created by mac on 2018/10/19.
//  Copyright © 2018年 czg. All rights reserved.
//

#import "UserState.h"

@implementation UserState


+(UserState *)instance{
    static UserState *Instance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        Instance = [[UserState alloc] init];
    });
    return Instance;
}


@end
