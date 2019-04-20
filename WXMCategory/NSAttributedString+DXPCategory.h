//
//  NSAttributedString+DXPCategory.h
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString (DXPCategory)

- (instancetype)initWithString_safe:(NSString *)str;

/**部分换颜色 */
+ (NSMutableAttributedString *)attributedStringWithString:(NSString *)aString
                                                    color:(UIColor *)color
                                                    Range:(NSRange)range;
/**修改字符间距 字与字 */
+ (NSMutableAttributedString *)changeSpaceWithString:(NSString *)aString space:(CGFloat)space;

/**修改字符行间距距 行与行 */
+ (NSMutableAttributedString *)changeLineSpaceWithString:(NSString *)aString
                                               lineSpace:(CGFloat)lineSpace;

/**链接 下划线 */
+ (NSMutableAttributedString *)addLinkWithString:(NSString *)aString range:(NSRange)range;

@end
