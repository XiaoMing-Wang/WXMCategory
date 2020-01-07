//
//  NSDictionary+DXPCategory.h
//  ChaomengPlanet
//
//  Created by 超盟 on 2018/10/9.
//  Copyright © 2018年 wq. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (WXMCategory)

/** 判断字典是否可用 */
- (BOOL)available;

/** 转字符串 */
- (NSString *)wc_jsonRepresentation;

/** 加载plist文件 */
+ (NSDictionary *)wc_dictionaryWithPlist:(NSString *)plistName;

@end
