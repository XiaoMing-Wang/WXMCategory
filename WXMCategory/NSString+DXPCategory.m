//
//  NSString+DXPCategory.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "NSString+DXPCategory.h"
#include <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#include <zlib.h>
#import <objc/runtime.h>

@implementation NSString (DXPCategory)

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
- (BOOL)isAvailable {
    return (self && [self isKindOfClass:[NSString class]] && self.length != 0);
}
/** json字符串转字典*/
- (NSDictionary *)jsonToDictionary {
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    if (!jsonData) return nil;
    return [NSJSONSerialization JSONObjectWithData:jsonData
                                           options:NSJSONReadingMutableContainers
                                             error:nil];
}

/** size*/
- (CGSize)size {
    return [self sizeWith_Fonts:[UIFont systemFontSize]];
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

/** 去掉空格 */
- (NSString *)removeSpace {
    if (self.isAvailable == NO) return nil;
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (CGSize)sizeWith_Fonts:(CGFloat)font {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.lineSpacing = 0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    CGFloat windowW = [UIScreen mainScreen].bounds.size.width;
    NSDictionary *dic = @{ NSFontAttributeName: [UIFont systemFontOfSize:font], NSParagraphStyleAttributeName: paraStyle, NSKernAttributeName: @1.5f };
    return [self boundingRectWithSize:CGSizeMake(windowW - 30, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                           attributes:dic
                              context:nil].size;
}
//根据宽度求 height
- (CGFloat)getHeightWithFont:(CGFloat)font {
    return [self getHeightWithFont:font width:MAXFLOAT];
}
//根据宽度求 height
- (CGFloat)getHeightWithFont:(CGFloat)font width:(CGFloat)width {
    if (!font) font = [UIFont systemFontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:font] }
                                     context:nil];
    return rect.size.height;
}

//根据高度度求 width
- (CGFloat)getWidthWithFont:(CGFloat)font {
    if (!font) font = [UIFont systemFontSize];
    CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                  attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:font] }
                                     context:nil];
    return rect.size.width;
}

/** 是否有字符*/
- (BOOL)haveCharacter {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @",+*;#";
    NSRange urgentRange = [self rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:phoneRegex]];
    if (urgentRange.location == NSNotFound) return NO;
    return YES;
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
- (BOOL)isNumber {
    if (self.length == 0) return NO;
    NSString *isNumber = @"^[0-9]*$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isNumber];
    return [phoneTest evaluateWithObject:self];
}

/** 中文 */
- (BOOL)isChinese {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"[\u4e00-\u9fa5]";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/** 英文字母 */
- (BOOL)isLetters {
    if (self.length == 0) return NO;
    NSString *phoneRegex = @"^[A-Za-z]+$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/** 判断是否为纯符号 */
- (BOOL)isAllCharacterString {
    BOOL isAllCharacter = YES;
    for (int i = 0; i < self.length; i++) {
        NSString *subStr = [self substringWithRange:NSMakeRange(i, 1)];
        if (subStr.isNumber || subStr.isChinese || self.isLetters) {
            isAllCharacter = NO;break;
        }
    }
    return isAllCharacter;
}

/** 手机号段 */
- (BOOL)isPhone {
    if (self.length == 0) return NO;
    //电信号段:133/149/153/173/177/180/181/189
    //联通号段:130/131/132/145/155/156/171/175/176/185/186
    //移动号段:134/135/136/137/138/139/147/150/151/152/157/158/159/178/182/183/184/187/188
    //虚拟运营商:170
    //新建号段:199 198 166
    NSString *mobile = @"^1(3[0-9]|4[0-9]|5[0-9]|6[0-9]|7[0-9]|8[0-9]|9[0-9])\\d{8}$";
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [regextestmobile evaluateWithObject:self];
}

#pragma mark ________________________________________________________ 时间转化
- (NSString *)timeForYYYY_MM_DD {
    return [self timeForTimesTampWithFormatter:@"yyyy-MM-dd"];
}
- (NSString *)timeForYYYY_MM_DD_HH_MM {
    return [self timeForTimesTampWithFormatter:@"yyyy-MM-dd HH:mm"];
}
- (NSString *)timeForTimesTampWithFormatter:(NSString *)formatter {
    NSString * timeFormatter = self;
    if (timeFormatter.length >= 10) timeFormatter = [timeFormatter substringToIndex:10];
    NSDate *detaildate = [NSDate dateWithTimeIntervalSince1970:[timeFormatter doubleValue]];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:formatter];
    return [dateFormatter stringFromDate:detaildate];
}

/* 保留小数 */
- (NSString *)preciseTdigits:(NSInteger)digits {
    NSInteger currentDigits = [self componentsSeparatedByString:@"."].lastObject.length;
    if ([self containsString:@"."] && (digits == currentDigits)) return self;
    NSString *format = [NSString stringWithFormat:@"%%.%ldf",(long)digits];
    return [NSString stringWithFormat:format, self.floatValue];
}

/* 手机打码 */
- (NSString *)safePhone {
    if (self.length < 7) return nil;
    if ([self rangeOfString:@"*"].location != NSNotFound) return self;
    NSInteger length = self.length - 6;
    return [self stringByReplacingCharactersInRange:NSMakeRange(3, length) withString:@"****"];
}
@end

