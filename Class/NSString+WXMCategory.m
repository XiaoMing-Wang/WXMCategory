//
//  NSString+DXPCategory.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#include <zlib.h>
#include <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#import <objc/runtime.h>
#import "NSString+WXMCategory.h"

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
- (BOOL)available {
    return (self && [self isKindOfClass:[NSString class]] && self.length != 0);
}

/** 去掉空格 */
- (NSString *)removeSpace {
    if (self.available == NO) return nil;
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

/** 转换成url */
- (NSURL *)urlConvert {
    if (self.available == NO) return nil;
    return [NSURL URLWithString:self];
}

/** json字符串转字典*/
- (NSDictionary *)wd_jsonToDictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) return nil;
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

/* 保留小数 */
- (NSString *)wd_preciseTdigits:(NSInteger)digits {
    NSInteger currentDigits = [self componentsSeparatedByString:@"."].lastObject.length;
    if ([self containsString:@"."] && (digits == currentDigits)) return self;
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",(long)digits];
    return [NSString stringWithFormat:format, self.doubleValue];
}

/** md5 */
- (NSString *)md5String {
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

/** 求width */
- (CGFloat)wd_getWidthWithFont:(CGFloat)fontSize {
    if (!fontSize) fontSize = [UIFont systemFontSize];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{ NSFontAttributeName:font } context:nil];
    return rect.size.width;
}

/** 求 height */
- (CGFloat)wd_getHeightWithFont:(CGFloat)fontSize {
    return [self wd_getHeightWithFont:fontSize width:MAXFLOAT];
}

- (CGFloat)wd_getHeightWithFont:(CGFloat)fontSize width:(CGFloat)width {
    if (!fontSize) fontSize = [UIFont systemFontSize];
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{ NSFontAttributeName: font } context:nil];
    return rect.size.height;
}

- (CGFloat)wd_getHeightOtherWithFont:(CGFloat)fontSize width:(CGFloat)width {
    if (fontSize == 0) fontSize = [UIFont systemFontSize];
    NSMutableParagraphStyle *style = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.alignment = NSTextAlignmentLeft;
    style.lineSpacing = -2.5f;
    style.paragraphSpacing = 0;
    NSDictionary *dict = @{
        NSFontAttributeName: [UIFont systemFontOfSize:fontSize],
        NSParagraphStyleAttributeName: style
    };
    
    NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;

    NSAttributedString *string = [[NSAttributedString alloc]initWithString:self attributes:dict];
    CGSize size = [string boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:options context:nil].size;
    CGFloat height = ceil(size.height) + 1;
    return height;
}

/** 获取字符行数 */
- (NSInteger)wd_numberRowWithMaxWidth:(CGFloat)maxWidth fontSize:(NSInteger)fontSize {
    if (self.length == 0) return 0;
    CGFloat allHeight = [self wd_getHeightWithFont:fontSize width:maxWidth];
    CGFloat lineHeight = [self wd_getHeightWithFont:fontSize];
    NSInteger totalRow = (allHeight / lineHeight);
    return totalRow;
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
- (BOOL)wd_number {
    if (self.length == 0) return NO;
    NSString *isNumber = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isNumber];
    return [phoneTest evaluateWithObject:self];
}

/** 中文 */
- (BOOL)wd_chinese {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"[\u4e00-\u9fa5]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/** 英文字母 */
- (BOOL)wd_english {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"^[A-Za-z]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/** 判断包含数字字母中文纯符号 */
- (BOOL)wd_allCharacterString {
    BOOL allCharacter = YES;
    for (int i = 0; i < self.length; i++) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if (subStr.wd_number || subStr.wd_chinese || self.wd_english) {
            allCharacter = NO;
            break;
        }
    }
    return allCharacter;
}

/** 是否是正确的密码 */
- (BOOL)wd_correctPassword {
    BOOL allCharacter = YES;
    for (int i = 0; i < self.length; i++) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if (!subStr.wd_number && !subStr.wd_english && ![self isEqualToString:@"_"]) {
            allCharacter = NO;
            break;
        }
    }
    return allCharacter;
}

/** 拼音 */
- (NSString *)wd_changePinyin {
    
//    NSMutableString *string = [NSMutableString stringWithString:self];
//    CFStringTransform((__bridge CFMutableStringRef) string, NULL, kCFStringTransformMandarinLatin, NO);
//    CFStringTransform((__bridge CFMutableStringRef) string, NULL, kCFStringTransformStripDiacritics, NO);
//    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    /** 这个效率比较高 */
    NSMutableString *mutableString = [NSMutableString stringWithString:self];
    CFStringTransform((CFMutableStringRef)mutableString, NULL, kCFStringTransformToLatin, false);
    mutableString = (NSMutableString *) [mutableString stringByFoldingWithOptions:NSDiacriticInsensitiveSearch
                                                                           locale:[NSLocale currentLocale]];
    return mutableString;
    
}
#pragma mark _____________________________________________ 时间转化

/* 时间戳转化String */
- (NSString *)wd_timeForYYYY_MM_DD {
    return [self wd_timeWithFormatter:@"yyyy-MM-dd"];
}

/* 时间戳转化String */
- (NSString *)wd_timeForYYYY_MM_DD_HH_MM; {
    return [self wd_timeWithFormatter:@"yyyy-MM-dd HH:mm"];
}

/* 时间戳转化String */
- (NSString *)wd_timeWithFormatter:(NSString *)formatter {
    NSString * timeFormatter = self;
    if (timeFormatter.length >= 10) timeFormatter = [timeFormatter substringToIndex:10];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[timeFormatter doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:detaildate];
}

/** String转换成时间戳 */
- (NSInteger)wd_timestampWithFormatter:(NSString *)formatter {
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:formatter];
    NSDate *fromDate = [dateformatter dateFromString:self];
    return (long)[fromDate timeIntervalSince1970];
}

/** String转换成时间戳 */
- (NSInteger)wd_timestampForYYYY_MM_DD {
    return [self wd_timestampWithFormatter:@"yyyy-MM-dd"];
}

/**  转换为Base64编码 */
- (NSString *)base64EncodedString {
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedStringWithOptions:0];
}

/**  将Base64编码还原 */
- (NSString *)base64DecodedString {
    NSData *data = [[NSData alloc] initWithBase64EncodedString:self options:0];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/** 判断是否允许输入 */
+ (BOOL)allowedEnter:(NSString *)original enterString:(NSString *)enterString {
    if ([enterString isEqualToString:@""]) return YES;
    if (original.length >= 9) return NO;
    if (original.length == 8 && [enterString isEqualToString:@"."]) return NO;
    if (!enterString.wd_number && ![enterString isEqualToString:@"."]) return NO;
    if (original.length == 0 && [enterString isEqualToString:@"."]) return NO;
    
    if ([original rangeOfString:@"."].location != NSNotFound &&
        [enterString isEqualToString:@"."]) {
        return NO;
    }
    
    if ([original isEqualToString:@"0"] &&
        [enterString isEqualToString:@"0"]) {
        return NO;
    }
    
    NSRange rangePoint = [original rangeOfString:@"."];
    if (rangePoint.location != NSNotFound) {
        NSString *lastString = [original componentsSeparatedByString:@"."].lastObject;
        if (lastString.length >= 2) return NO;
    }
    return YES;
}

/** 判断是否输入的是有效金额 */
+ (BOOL)availableEnter:(NSString *)enterString {
    if ([enterString isEqualToString:@"0"] || [enterString isEqualToString:@"0."]) return NO;
    return (enterString.length > 0);
}
@end

