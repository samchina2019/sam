//
//  FilePathManager.h
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FilePathManager : NSObject
+(NSString *)handlePathWithStr:(NSString *)filePath httpPath:(NSString *)httpPath;
- (UIImage *)cutImage:(UIImage*)image viewsize:(CGSize)viewsize;
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
