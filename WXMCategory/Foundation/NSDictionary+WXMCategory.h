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
- (BOOL)wc_available;

/** 转字符串 */
- (NSString *)wc_jsonRepresentation;

@end
