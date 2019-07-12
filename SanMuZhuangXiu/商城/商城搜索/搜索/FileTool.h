//
//  FileTool.h
//  ZhongRenJuMei
//
//  Created by benben on 2019/4/26.
//  Copyright © 2019 刘寒. All rights reserved.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@interface FileTool : NSObject

//保存im 的你昵称和头像
+ (NSDictionary *)readFileWithUid:(NSString *)uid;
+ (void)writeFileWithUid:(NSDictionary *)dic;
+ (void)deleteFile;

//保存搜索历史
+ (NSArray *)readSearchHistory;
+ (void)writeSearchHistory:(NSString *)keyword;
+ (void)deleteSearchHistory;

//保存历史定位
+ (NSArray *)readHistoryLocation;
+ (void)writeHistoryLocation:(NSDictionary *)location;
@end

NS_ASSUME_NONNULL_END
