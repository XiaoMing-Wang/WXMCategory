//
//  NSMutableAttributedString+WXMCategory.h
//  ModuleDebugging
//
//  Created by edz on 2019/9/12.
//  Copyright © 2019 wq. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableAttributedString (WXMCategory)

- (instancetype)initWithSafeString:(NSString *)aString;

/** 部分换颜色 */
+ (NSMutableAttributedString *)wc_attributedString:(NSString *)aString color:(UIColor *)color range:(NSRange)range;

/** 修改字符间距 字与字 */
+ (NSMutableAttributedString *)wc_verticalSpace:(NSString *)aString space:(CGFloat)space;

/** 修改字符行间距距 行与行 */
+ (NSMutableAttributedString *)wc_horizontalSpace:(NSString *)aString space:(CGFloat)space;

/** 链接下划线 */
+ (NSMutableAttributedString *)wc_underline:(NSString *)aString range:(NSRange)range;

/** 段落间距 */
- (void)wc_addLineSpace:(CGFloat)space;

/** 添加颜色 */
- (void)wc_addColor:(UIColor *)color range:(NSRange)range;

/** 线条颜色 */
- (void)wc_addLineWithColor:(UIColor *)lineColor range:(NSRange)range;

/** 字体大小 */
- (void)wc_setFontSize:(NSInteger)fontSize range:(NSRange)range;

@end

NS_ASSUME_NONNULL_END
