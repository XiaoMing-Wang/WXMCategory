//
//  NSArray+DXPCategory.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (WXMCategory)

/** 判断数组是否可用 */
- (BOOL)wxm_isAvailable;

/** 加载plist文件 */
+ (NSArray *)wxm_arrayWithPlist:(NSString *)plistName;

@end

