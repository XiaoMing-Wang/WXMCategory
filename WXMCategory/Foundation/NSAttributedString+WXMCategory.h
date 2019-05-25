//
//  NSAttributedString+DXPCategory.h
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (WXMCategory)

- (instancetype)initWithSafestring:(NSString *)aString;

/** 部分换颜色 */
+ (NSMutableAttributedString *)wxm_attributedString:(NSString *)aString
                                              color:(UIColor *)color
                                              range:(NSRange)range;
/** 修改字符间距 字与字 */
+ (NSMutableAttributedString *)wxm_changeHorizontalSpace:(NSString *)aString space:(CGFloat)space;

/** 修改字符行间距距 行与行 */
+ (NSMutableAttributedString *)wxm_changeVerticalSpace:(NSString *)aString lineSpace:(CGFloat)lineSpace;

/** 链接 下划线 */
+ (NSMutableAttributedString *)wxm_addUnderline:(NSString *)aString range:(NSRange)range;

@end
