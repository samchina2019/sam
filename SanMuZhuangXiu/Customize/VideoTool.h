//
//  VideoTool.h
//  ShenglongLive
//
//  Created by benbenkeji on 2018/1/9.
//  Copyright © 2018年 周青迪. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^ConvertBlock)(NSString *path);
typedef void(^Convertfail)(void);

@interface VideoTool : NSObject
+ (void)deleteTemVieoAtPath:(NSString*)path;
+ (UIImage *)firstFrameWithVideoURL:(NSURL *)url size:(CGSize)size;
+ (void)convertMOVToMp4:(NSURL*)path success:(ConvertBlock)block fail:(Convertfail)fail;

@end
