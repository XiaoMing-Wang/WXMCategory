 //
//  NSString+DXPCategory.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSString (DXPCategory)

/** 计算size + 边距 */
@property (nonatomic, assign, readonly) CGSize size;

/** md5*/
- (NSString *)md5String;

/** 判断是否可用 */
- (BOOL)isAvailable;

/** 是否有字符*/
- (BOOL)quitCharacter;
- (BOOL)haveCharacter;

/** 是否数字 */
- (BOOL)isNumber;
/** 是否中文 */
- (BOOL)isChinese;
/** 是否英文 */
- (BOOL)isLetters;
/** 是否全符号 */
- (BOOL)isAllCharacterString;
/** 是否手机号 */
- (BOOL)isPhone;

/** 是去掉空格*/
- (NSString *)removeSpace;

/** json字符串转字典 */
- (NSDictionary *)jsonToDictionary;

/**根据宽度求宽和高 */
- (CGSize)sizeWith_Fonts:(CGFloat)font;
- (CGFloat)getHeightWithFont:(CGFloat)font;
- (CGFloat)getWidthWithFont:(CGFloat)font;
- (CGFloat)getHeightWithFont:(CGFloat)font width:(CGFloat)width;

/* 时间转化 */
- (NSString *)timeForYYYY_MM_DD_HH_MM;
- (NSString *)timeForYYYY_MM_DD;
- (NSString *)timeForTimesTampWithFormatter:(NSString *)formatter;

/* 保留小数 */
- (NSString *)preciseTdigits:(NSInteger)digits;

/** 手机打码 */
- (NSString *)safePhone;

@end

NS_ASSUME_NONNULL_END
