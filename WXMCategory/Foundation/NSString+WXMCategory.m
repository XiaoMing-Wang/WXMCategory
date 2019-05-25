//
//  NSString+DXPCategory.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "NSString+WXMCategory.h"
#include <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#include <zlib.h>
#import <objc/runtime.h>

@implementation NSString (WXMCategory)

+ (void)load {
    Method method1 = class_getInstanceMethod(self, @selector(stringByAppendingString:));
    Method method2 = class_getInstanceMethod(self, @selector(safeStringByAppendingString:));
    method_exchangeImplementations(method1, method2);
}

- (NSString *)safeStringByAppendingString:(NSString *)aString {
    if (!aString) {
        NSLog(@"stringByAppendingString: ____________________字符串为空");
        NSLog(@"stringByAppendingString: ____________________字符串为空");
        NSLog(@"stringByAppendingString: ____________________字符串为空");
        return self;
    }
    return [self safeStringByAppendingString:aString];
}

/** 判断是否可用 */
- (BOOL)wxm_isAvailable {
    return (self && [self isKindOfClass:[NSString class]] && self.length != 0);
}

/** 去掉空格 */
- (NSString *)wxm_removeSpace {
    if (self.wxm_isAvailable == NO) return nil;
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/** json字符串转字典*/
- (NSDictionary *)wxm_jsonToDictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) return nil;
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

/* 保留小数 */
- (NSString *)wxm_preciseTdigits:(NSInteger)digits {
    NSInteger currentDigits = [self componentsSeparatedByString:@"."].lastObject.length;
    if ([self containsString:@"."] && (digits == currentDigits)) return self;
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",(long)digits];
    return [NSString stringWithFormat:format, self.floatValue];
}

/** md5 */
- (NSString *)wxm_md5String {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(data.bytes, (CC_LONG) data.length, result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ].lowercaseString;
}

/** 求 width */
- (CGFloat)wxm_getWidthWithFont:(CGFloat)fontSize {
    if (!fontSize) fontSize = [UIFont systemFontSize];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{ NSFontAttributeName:font } context:nil];
    return rect.size.width;
}

/** 求 height */
- (CGFloat)wxm_getHeightWithFont:(CGFloat)fontSize {
    return [self wxm_getHeightWithFont:fontSize width:MAXFLOAT];
}
- (CGFloat)wxm_getHeightWithFont:(CGFloat)fontSize width:(CGFloat)width {
    if (!fontSize) fontSize = [UIFont systemFontSize];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{ NSFontAttributeName: font } context:nil];
    return rect.size.height;
}

/** 是否有字符*/
- (BOOL)quitCharacter {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @",+*;#+-/:=!，。？！,.?";
    NSRange urgentRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:phoneRegex]];
    if (urgentRange.location == NSNotFound) return NO;
    return YES;
}

/** 验证是否是数字*/
- (BOOL)wxm_number {
    if (self.length == 0) return NO;
    NSString *isNumber = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isNumber];
    return [phoneTest evaluateWithObject:self];
}

/** 中文 */
- (BOOL)wxm_chinese {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"[\u4e00-\u9fa5]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/** 英文字母 */
- (BOOL)wxm_english {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"^[A-Za-z]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/** 判断包含数字字母中文纯符号 */
- (BOOL)wxm_allCharacterString {
    BOOL allCharacter = YES;
    for (int i = 0; i < self.length; i++) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if (subStr.wxm_number || subStr.wxm_chinese || self.wxm_english) {
            allCharacter = NO;
            break;
        }
    }
    return allCharacter;
}

/** 拼音 */
- (NSString *)wxm_changePinyin {
    NSMutableString *string = [NSMutableString stringWithString:self];
    CFStringTransform((__bridge CFMutableStringRef) string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef) string, NULL, kCFStringTransformStripDiacritics, NO);
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}
#pragma mark _____________________________________________ 时间转化

/** 时间戳转换string */
- (NSString *)wxm_timeForYYYY_MM_DD {
    return [self wxm_timeForTimesTampWithFormatter:@"yyyy-MM-dd"];
}
- (NSString *)timeForYYYY_MM_DD_HH_MM {
    return [self wxm_timeForTimesTampWithFormatter:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)wxm_timeForTimesTampWithFormatter:(NSString *)formatter {
    NSString * timeFormatter = self;
    if (timeFormatter.length >= 10) timeFormatter = [timeFormatter substringToIndex:10];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[timeFormatter doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:detaildate];
}

/** string转换成时间戳 */
- (NSInteger)wxm_timestampForYYYY_MM_DD {
    return [self wxm_timestampWithFormatter:@"yyyy-MM-dd"];
}
- (NSInteger)wxm_timestampWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSDate *fromDate = [dateformatter dateFromString:self];
    return (long) [fromDate timeIntervalSince1970];
}
@end

