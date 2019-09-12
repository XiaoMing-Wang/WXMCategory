//
//  NSMutableAttributedString+WXMCategory.m
//  ModuleDebugging
//
//  Created by edz on 2019/9/12.
//  Copyright © 2019 wq. All rights reserved.
//
#define WXMCreatAttributedString(aString) \
[[NSMutableAttributedString alloc] initWithSafeString:aString]

#include <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#include <zlib.h>
#import <objc/runtime.h>
#import "NSMutableAttributedString+WXMCategory.h"

@implementation NSMutableAttributedString (WXMCategory)

- (instancetype)initWithSafeString:(NSString *)aString {
    if (aString == nil) return nil;
    return [self initWithString:aString];
}

/** 部分换颜色 */
+ (NSMutableAttributedString *)wxm_attributedString:(NSString *)aString
                                              color:(UIColor *)color
                                              range:(NSRange)range {
    @try {
        NSMutableAttributedString *atts = WXMCreatAttributedString(aString);
        [atts addAttribute:NSForegroundColorAttributeName value:color range:range];
        return atts;
    } @catch (NSException *exception) {} @finally {};
}

/** 修改字符间距 字与字 */
+ (NSMutableAttributedString *)wxm_changeVerticalSpace:(NSString *)aString
                                                 space:(CGFloat)space {
    @try {
        
        NSMutableAttributedString *atts = WXMCreatAttributedString(aString);
        NSRange range = NSMakeRange(0, atts.length);
        long number = space;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [atts addAttribute:(id) kCTKernAttributeName value:(__bridge id) num range:range];
        CFRelease(num);
        return atts;
    } @catch (NSException *exception) {} @finally {};
}

/** 修改字符行间距距 行与行 */
+ (NSMutableAttributedString *)wxm_changeHorizontalSpace:(NSString *)aString
                                                   space:(CGFloat)space {
    @try {
        NSMutableAttributedString *atts = WXMCreatAttributedString(aString);
        NSRange range = NSMakeRange(0, atts.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:space];
        [atts addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        return atts;
    } @catch (NSException *exception) {} @finally {};
}

/** 链接下划线 */
+ (NSMutableAttributedString *)wxm_addUnderline:(NSString *)aString
                                          range:(NSRange)range {
    @try {
        NSMutableAttributedString *atts = WXMCreatAttributedString(aString);
        NSDictionary *attris = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor redColor],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                 NSUnderlineColorAttributeName: [UIColor blackColor] };
        [atts setAttributes:attris range:range];
        return atts;
    } @catch (NSException *exception) {} @finally {};
}

- (void)wxm_addLineSpace:(CGFloat)space {
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [parag setLineSpacing:space];
    
    NSRange range = NSMakeRange(0, self.length);
    [self addAttribute:NSParagraphStyleAttributeName value:parag range:range];
}

- (void)wxm_addColor:(UIColor *)color range:(NSRange)range {
    if (self.length == 0) return;
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void)wxm_addLineWithColor:(UIColor *)lineColor range:(NSRange)range {
    if (self.length == 0) return;
    NSDictionary *attris = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                             NSUnderlineColorAttributeName: lineColor };
    [self setAttributes:attris range:range];
    
}

- (void)wxm_setFontSize:(NSInteger)fontSize range:(NSRange)range {
    if (self.length == 0) return;
    NSDictionary *attris = @{NSFontAttributeName: [UIFont systemFontOfSize:fontSize] };
    [self setAttributes:attris range:range];
}

@end
