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
- (NSString *)wxm_md5String;

/** 判断是否可用 */
- (BOOL)wxm_isAvailable;

/* 保留小数 */
- (NSString *)wxm_preciseTdigits:(NSInteger)digits;

/** 是去掉空格*/
- (NSString *)wxm_removeSpace;

/** json字符串转字典 */
- (NSDictionary *)wxm_jsonToDictionary;


/** 正则 */
- (BOOL)wxm_number;
- (BOOL)wxm_chinese;
- (BOOL)wxm_english;
- (BOOL)wxm_allCharacterString;

/** 求宽高 */
- (CGFloat)wxm_getHeightWithFont:(CGFloat)fontSize;
- (CGFloat)wxm_getWidthWithFont:(CGFloat)fontSize;
- (CGFloat)wxm_getHeightWithFont:(CGFloat)fontSize width:(CGFloat)width;

/* 时间转化 */
- (NSString *)wxm_timeForYYYY_MM_DD;
- (NSString *)wxm_timeForYYYY_MM_DD_HH_MM;
- (NSString *)wxm_timeForTimesTampWithFormatter:(NSString *)formatter;

/** 转换成时间戳 */
- (NSInteger)wxm_timestampForYYYY_MM_DD;
- (NSInteger)wxm_timestampWithFormatter:(NSString *)formatter;

/** 拼音 */
- (NSString *)wxm_changePinyin;

/** 获取字符行数 */
- (NSInteger)wxm_numberRowWithMaxWidth:(CGFloat)maxWidth fontSize:(NSInteger)fontSize;
@end

NS_ASSUME_NONNULL_END
