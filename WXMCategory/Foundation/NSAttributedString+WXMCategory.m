//
//  NSAttributedString+DXPCategory.m
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "NSAttributedString+WXMCategory.h"
#include <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#include <zlib.h>
#import <objc/runtime.h>

@implementation NSAttributedString (WXMCategory)

- (instancetype)initWithSafestring:(NSString *)aString {
    if (aString == nil) return nil;
    return [self initWithString:aString];
}

/** 部分换颜色 */
+ (NSMutableAttributedString *)wxm_attributedString:(NSString *)aString
                                              color:(UIColor *)color
                                              range:(NSRange)range {
    @try {
        
        NSMutableAttributedString *atts = nil;
        atts = [[NSMutableAttributedString alloc] initWithSafestring:aString];
        [atts addAttribute:NSForegroundColorAttributeName value:color range:range];
        return atts;
        
    } @catch (NSException *exception) {} @finally {};
}

/** 修改字符间距 字与字 */
+ (NSMutableAttributedString *)wxm_changeHorizontalSpace:(NSString *)aString space:(CGFloat)space {
    @try {
        
        NSMutableAttributedString *atts = nil;
        atts = [[NSMutableAttributedString alloc] initWithSafestring:aString];
        NSRange range = NSMakeRange(0, atts.length);
        long number = space;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [atts addAttribute:(id) kCTKernAttributeName value:(__bridge id) num range:range];
        CFRelease(num);
        return atts;
        
    } @catch (NSException *exception) {} @finally {};
}

/** 修改字符行间距距 行与行 */
+ (NSMutableAttributedString *)wxm_changeVerticalSpace:(NSString *)aString lineSpace:(CGFloat)lineSpace {
    @try {
        
        NSMutableAttributedString *atts = nil;
        atts = [[NSMutableAttributedString alloc] initWithSafestring:aString];
        NSRange range = NSMakeRange(0, atts.length);
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [atts addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
        return atts;
        
    } @catch (NSException *exception) {} @finally {};
    
}

/** 链接 下划线 */
+ (NSMutableAttributedString *)wxm_addUnderline:(NSString *)aString range:(NSRange)range {
    @try {
        
        NSMutableAttributedString *atts = nil;
        atts = [[NSMutableAttributedString alloc] initWithSafestring:aString];
        NSDictionary *attris = @{NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor redColor],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                 NSUnderlineColorAttributeName: [UIColor blackColor] };
        [atts setAttributes:attris range:range];
        return atts;
        
    } @catch (NSException *exception) {} @finally {};
}

@end
