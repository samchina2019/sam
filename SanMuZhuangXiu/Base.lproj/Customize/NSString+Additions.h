//
//  NSString+Additions.h
//  ZSHY(B2)
//
//  Created by LiuZhengli on 16/12/29.
//  Copyright © 2016年 unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Additions)

/// Replace all occurrences of the target string with replacement color.
- (nonnull NSAttributedString *)stringByReplacingOccurrencesOfString:(nonnull NSString *)string withColor:(nonnull UIColor *)color;

/** Perform string transliteration.  The transformation represented by transform is applied to the receiver. the transformed string value without whitespace is returned (even if no characters are actually transformed).
 */
- (nullable NSString *)stringByApplyingTransformToPinYin;

/** Perform string transliteration.  The transformation represented by transform is applied to the receiver. the transformed string value without whitespace is returned (even if no characters are actually transformed).
 @param filterWhitespace Whether filter whitespace or not.
 */
- (nullable NSString *)stringByApplyingTransformToPinYinFilteringWhitespace:(BOOL)filterWhitespace;

/** Perform string filtering whitespace.  The filtering is applied to the receiver. the string value without whitespace is returned (even if no characters are actually filtered).
 */
- (nullable NSString *)stringByFilteringWhitespace;

/** Perform string filtering whitespace.  The filtering is applied to the receiver. the string value without carriage return is returned (even if no characters are actually filtered).
 */
- (nullable NSString *)stringByFilteringCarriageReturn;

/** Perform string filtering whitespace and carriage return.  The filtering is applied to the receiver. the string value without carriage return is returned (even if no characters are actually filtered).
 */
- (nullable NSString *)stringByFilteringWhitespaceAndCarriageReturn;

/** Judge a string whether is all whitespaces or not.
    return YES if a string is all whitespaces, otherwise NO.
 */
- (BOOL)stringIsAllWhitespaces;

/** Judge a string whether is all carriage returns or not.
    return YES if a string is all carriage returns, otherwise NO.
 */
- (BOOL)stringIsAllCarriageReturns;

/** Judge a string whether is all whitespaces or all carriage returns or not.
    return YES if a string is all whitespaces or all carriage returns, otherwise NO.
 */
- (BOOL)stringIsAllWhitespacesOrCarriageReturns;

@end
