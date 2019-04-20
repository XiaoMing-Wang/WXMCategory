//
//  NSAttributedString+DXPCategory.m
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "NSAttributedString+DXPCategory.h"
#include <CommonCrypto/CommonCrypto.h>
#import <CoreText/CoreText.h>
#include <zlib.h>
#import <objc/runtime.h>

@implementation NSAttributedString (DXPCategory)

- (instancetype)initWithString_safe:(NSString *)str {
    if (str == nil) return nil;
    return [self initWithString:str];
}
/**部分换颜色 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)aString
                                                    color:(UIColor *)color
                                                    Range:(NSRange)range {
    @try {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
        return attributedString;
    }@catch (NSException *exception) {} @finally {};
    
}

/**修改字符间距 字与字 */
+ (NSMutableAttributedString *)changeSpaceWithString:(NSString *)aString space:(CGFloat)space {
    
    @try {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        long number = space;
        CFNumberRef num = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt8Type, &number);
        [attributedString addAttribute:(id) kCTKernAttributeName
                                 value:(__bridge id) num
                                 range:NSMakeRange(0, attributedString.length)];
        CFRelease(num);
        return attributedString;
    }@catch (NSException *exception) {} @finally {};
    
}
/**修改字符行间距距 行与行 */
+ (NSMutableAttributedString *)changeLineSpaceWithString:(NSString *)aString
                                               lineSpace:(CGFloat)lineSpace {
    
    @try {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        [paragraphStyle setLineSpacing:lineSpace];
        [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attributedString.length)];
        return attributedString;
    }@catch (NSException *exception) {} @finally {};
    
}
+ (NSMutableAttributedString *)addLinkWithString:(NSString *)aString range:(NSRange)range {
    
    @try {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:aString];
        NSDictionary *attris = @{
                                 NSFontAttributeName: [UIFont systemFontOfSize:14],
                                 NSForegroundColorAttributeName: [UIColor redColor],
                                 NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                                 NSUnderlineColorAttributeName: [UIColor blackColor]
                                 };
        [attributedString setAttributes:attris range:range];
        return attributedString;
    } @catch (NSException *exception) {} @finally {};
    
}

@end
