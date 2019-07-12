//
//  NSString+Additions.m
//  ZSHY(B2)
//
//  Created by LiuZhengli on 16/12/29.
//  Copyright © 2016年 unicom. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (Additions)

/// Replace all occurrences of the target string with replacement color.
- (nonnull NSAttributedString *)stringByReplacingOccurrencesOfString:(nonnull NSString *)string withColor:(nonnull UIColor *)color
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:self];

    NSRegularExpression* regex = [NSRegularExpression
                                  regularExpressionWithPattern:[NSString stringWithFormat:@"%@", string]
                                  options:NSRegularExpressionCaseInsensitive
                                  error:nil];

    NSArray *matches = [regex matchesInString:self
                                      options:0
                                        range:NSMakeRange(0, [self length])];
    for (NSTextCheckingResult* result in matches)
    {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:color range:[result range]];
    }
    
    return mutableAttributedString;
}

- (nullable NSString *)stringByApplyingTransformToPinYin
{
    return [self stringByApplyingTransformToPinYinFilteringWhitespace:YES];
}

- (nullable NSString *)stringByApplyingTransformToPinYinFilteringWhitespace:(BOOL)filterWhitespace
{
    // http://stackoverflow.com/questions/17227348/nsstring-to-cfstringref-and-cfstringref-to-nsstring-in-arc
    CFStringRef stringRef = (__bridge CFStringRef)self;
    
    // http://stackoverflow.com/questions/4813086/how-to-convert-chinese-characters-to-pinyin
    // Answered by Duan
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, stringRef);
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    
    NSString *pinYin = (__bridge_transfer NSString *)string;
    if (filterWhitespace) {
        pinYin = [pinYin stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    return pinYin;
}

- (nullable NSString *)stringByFilteringWhitespace
{
    CFStringRef stringRef = (__bridge CFStringRef)self;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, stringRef);
    NSString *result = (__bridge_transfer NSString *)string;
    result = [result stringByReplacingOccurrencesOfString:@" " withString:@""];
    return result;
}

- (nullable NSString *)stringByFilteringCarriageReturn
{
    CFStringRef stringRef = (__bridge CFStringRef)self;
    CFMutableStringRef string = CFStringCreateMutableCopy(NULL, 0, stringRef);
    NSString *result = (__bridge_transfer NSString *)string;
    result = [result stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return result;
}

- (nullable NSString *)stringByFilteringWhitespaceAndCarriageReturn
{
    return [[self stringByFilteringWhitespace] stringByFilteringCarriageReturn];
}

- (BOOL)stringIsAllWhitespaces
{
    return [self stringByFilteringWhitespace].length == 0;
}

- (BOOL)stringIsAllCarriageReturns
{
    return [self stringByFilteringCarriageReturn].length == 0;
}

- (BOOL)stringIsAllWhitespacesOrCarriageReturns
{
    return [self stringByFilteringWhitespaceAndCarriageReturn].length == 0;
}

@end
