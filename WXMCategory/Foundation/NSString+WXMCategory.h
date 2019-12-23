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
@interface NSString (WXMCategory)

/** md5 */
- (NSString *)wc_md5String;

/** 判断是否可用 */
- (BOOL)wc_available;

/* 保留小数 */
- (NSString *)wc_preciseTdigits:(NSInteger)digits;

/** 是去掉空格*/
- (NSString *)wc_removeSpace;

/** json字符串转字典 */
- (NSDictionary *)wc_jsonToDictionary;

/** 正则 */
- (BOOL)wc_number;
- (BOOL)wc_chinese;
- (BOOL)wc_english;
- (BOOL)wc_allCharacterString;

/** 求宽高 */
- (CGFloat)wc_getHeightWithFont:(CGFloat)fontSize;
- (CGFloat)wc_getWidthWithFont:(CGFloat)fontSize;
- (CGFloat)wc_getHeightWithFont:(CGFloat)fontSize width:(CGFloat)width;
- (CGFloat)wc_getHeightOtherWithFont:(CGFloat)fontSize width:(CGFloat)width;

/* 时间戳转化String */
- (NSString *)wc_timeForYYYY_MM_DD;
- (NSString *)wc_timeForYYYY_MM_DD_HH_MM;
- (NSString *)wc_timeWithFormatter:(NSString *)formatter;

/** String转换成时间戳 */
- (NSInteger)wc_timestampForYYYY_MM_DD;
- (NSInteger)wc_timestampWithFormatter:(NSString *)formatter;

/** 拼音 */
- (NSString *)wc_changePinyin;

/** 获取字符行数 */
- (NSInteger)wc_numberRowWithMaxWidth:(CGFloat)maxWidth fontSize:(NSInteger)fontSize;

/** 转换为Base64编码 */
- (NSString *)base64EncodedString;

/** Base64解码 */
- (NSString *)base64DecodedString ;
@end

NS_ASSUME_NONNULL_END
