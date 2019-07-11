//
//  FileTool.m
//  ZhongRenJuMei
//
//  Created by benben on 2019/4/26.
//  Copyright © 2019 刘寒. All rights reserved.
//

#import "FileTool.h"

static NSString  * const KUser = @"huanxinUserNickName";
static NSString  * const KSearch = @"searcHistory";
static NSString  * const KLocation = @"locationHistory";

@implementation FileTool

+ (void)isFileExit:(NSString *)nick{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * filePath = [cachePath stringByAppendingPathComponent:nick];
    //创建一个文件管理类
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //判断该文件是否存在不存在
    BOOL fileExit = [mgr fileExistsAtPath:filePath];
    if (!fileExit) {
       [mgr createFileAtPath:filePath contents:nil attributes:nil];
    }
}


+ (NSDictionary *)readFileWithUid:(NSString *)uid{
    
    [[self class] isFileExit:KUser];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * filePath = [cachePath stringByAppendingPathComponent:KUser];
    NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *infolist= fileDict[KUser];
    NSDictionary *dict = nil;
    
    for (NSDictionary *dic in infolist) {
        if ([dic[@"uid"] isEqualToString:uid]) {
            dict = dic;
        }
    }
    return dict;
}
+ (void)writeFileWithUid:(NSDictionary *)dic{
    [[self class] isFileExit:KUser];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath = [cachePath stringByAppendingPathComponent:KUser];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
    NSMutableArray *infolist= [NSMutableArray arrayWithArray:dataDict[KUser]];
    [infolist addObject:dic];
    [dataDict setValue:infolist forKey:KUser];
    BOOL ise = [[NSDictionary dictionaryWithDictionary:dataDict] writeToFile:filePath atomically:YES];
    if (ise) {
        NSLog(@"成功");
    }
    else{
        NSLog(@"不成功");
    }
}

+ (void)deleteFile{
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * filePath = [cachePath stringByAppendingPathComponent:KUser];
    //创建一个文件管理类
    NSFileManager *mgr = [NSFileManager defaultManager];
    BOOL isSuccess = [mgr removeItemAtPath:filePath error:nil];
    if (!isSuccess) {
        
    }
}

#pragma mark -- 搜索历史
+ (NSArray *)readSearchHistory{
    [[self class] isFileExit:KSearch];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * filePath = [cachePath stringByAppendingPathComponent:KSearch];
    NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *infolist= fileDict[KSearch];
    return infolist;
}
+ (void)writeSearchHistory:(NSString *)keyword{
    [[self class] isFileExit:KSearch];
    if (keyword.length == 0) {
        return;
    }
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath = [cachePath stringByAppendingPathComponent:KSearch];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
    NSMutableArray *infolist= [NSMutableArray arrayWithArray:dataDict[KSearch]];
    if (![infolist containsObject:keyword]) {
        [infolist addObject:keyword];
        [dataDict setValue:infolist forKey:KSearch];
        BOOL ise = [[NSDictionary dictionaryWithDictionary:dataDict] writeToFile:filePath atomically:YES];
        if (ise) {
            NSLog(@"成功");
        }
        else{
            NSLog(@"不成功");
        }
    }
    
}
+ (void)deleteSearchHistory{
    [[self class] isFileExit:KSearch];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * filePath = [cachePath stringByAppendingPathComponent:KSearch];
    //创建一个文件管理类
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    //删除文件
    BOOL fileExit = [mgr removeItemAtPath:filePath error:nil];
    if (!fileExit) {
        NSLog(@"成功");
    }
    
    
}

#pragma mark -- 历史定位
+ (NSArray *)readHistoryLocation{
    [[self class] isFileExit:KLocation];
    
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    
    NSString * filePath = [cachePath stringByAppendingPathComponent:KLocation];
    NSDictionary *fileDict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *infolist= fileDict[KLocation];
    return infolist;
}
+ (void)writeHistoryLocation:(NSDictionary *)location{
    [[self class] isFileExit:KLocation];
    if (location.allKeys.count == 0) {
        return;
    }
    NSString * cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    NSString * filePath = [cachePath stringByAppendingPathComponent:KLocation];
    NSMutableDictionary *dataDict = [NSMutableDictionary dictionaryWithDictionary:[NSDictionary dictionaryWithContentsOfFile:filePath]];
    NSMutableArray *infolist= [NSMutableArray arrayWithArray:dataDict[KLocation]];
    if (![infolist containsObject:location]) {
        [infolist addObject:location];
        [dataDict setValue:infolist forKey:KLocation];
        BOOL ise = [[NSDictionary dictionaryWithDictionary:dataDict] writeToFile:filePath atomically:YES];
        if (ise) {
            NSLog(@"成功");
        }
        else{
            NSLog(@"不成功");
        }
    }
}
@end
