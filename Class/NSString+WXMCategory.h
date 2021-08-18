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
 - (NSString *)md5String;

 /** 判断是否可用 */
 - (BOOL)available;

 /** 是去掉空格*/
 - (NSString *)removeSpace;

 /** 转换成url */
 - (NSURL *)urlConvert;

 /* 保留小数 */
 - (NSString *)wd_preciseTdigits:(NSInteger)digits;

 /** json字符串转字典 */
 - (NSDictionary *)wd_jsonToDictionary;

 /** 正则 */
 - (BOOL)wd_number;
 - (BOOL)wd_chinese;
 - (BOOL)wd_english;
 - (BOOL)wd_allCharacterString;

 /** 是否是正确的密码 */
 - (BOOL)wd_correctPassword;

 /** 求宽高 */
 - (CGFloat)wd_getHeightWithFont:(CGFloat)fontSize;
 - (CGFloat)wd_getWidthWithFont:(CGFloat)fontSize;
 - (CGFloat)wd_getHeightWithFont:(CGFloat)fontSize width:(CGFloat)width;
 - (CGFloat)wd_getHeightOtherWithFont:(CGFloat)fontSize width:(CGFloat)width;

 /* 时间戳转化String */
 - (NSString *)wd_timeForYYYY_MM_DD;
 - (NSString *)wd_timeForYYYY_MM_DD_HH_MM;
 - (NSString *)wd_timeWithFormatter:(NSString *)formatter;

 /** String转换成时间戳 */
 - (NSInteger)wd_timestampForYYYY_MM_DD;
 - (NSInteger)wd_timestampWithFormatter:(NSString *)formatter;

 /** 拼音 */
 - (NSString *)wd_changePinyin;

 /** 获取字符行数 */
 - (NSInteger)wd_numberRowWithMaxWidth:(CGFloat)maxWidth fontSize:(NSInteger)fontSize;

 /** 转换为Base64编码 */
 - (NSString *)base64EncodedString;

 /** Base64解码 */
 - (NSString *)base64DecodedString;

 + (BOOL)availableEnter:(NSString *)enterString;
 + (BOOL)allowedEnter:(NSString *)original enterString:(NSString *)enterString;

 @end

 NS_ASSUME_NONNULL_END
