//
//  FilePathManager.m
//  SanMuZhuangXiu
//
//  Created by 王巧云 on 2019/3/20.
//  Copyright © 2019 Darius. All rights reserved.
//

#import "FilePathManager.h"

@implementation FilePathManager
+(NSString *)handlePathWithStr:(NSString *)filePath httpPath:(NSString *)httpPath{
    if (filePath==nil||filePath==NULL) {
        return @"";
    }
    if ([filePath isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if (!filePath||filePath.length==0) {
        return @"";
    }
    NSString *wsitchStr= [filePath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSRange range = [filePath rangeOfString:@"http"];
    if (range.location == NSNotFound) {
        NSString *kFilePath = [NSString stringWithFormat:@"%@/Uploads/%@",httpPath,wsitchStr];
        return kFilePath;
    }else{
        return wsitchStr;
    }
}
#pragma mark ---- 图片剪切到指定大小
- (UIImage *)cutImage:(UIImage*)image viewsize:(CGSize)viewsize
{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((image.size.width / image.size.height) < (viewsize.width / viewsize.height)) {
        newSize.width = image.size.width;
        newSize.height = image.size.width * viewsize.height / viewsize.width;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(0, fabs(image.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else {
        newSize.height = image.size.height;
        newSize.width = image.size.height * viewsize.width / viewsize.height;
        
        imageRef = CGImageCreateWithImageInRect([image CGImage], CGRectMake(fabs(image.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
        
    }
    
    return [UIImage imageWithCGImage:imageRef];
}
#pragma mark ---- 图片压缩到指定大小
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size
{
    
    // 创建一个bitmap的context, 并把它设置成为当前正在使用的context
    
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;
    
}
@end
