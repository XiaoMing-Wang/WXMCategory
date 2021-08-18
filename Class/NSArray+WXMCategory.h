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
- (BOOL)available;

/** 加载plist文件 */
+ (NSArray *)wd_arrayWithPlist:(NSString *)plistName;

/** 重复的object只添加一次 */
- (void)wd_addRepeatObject:(NSString *)object;

/** 反转数组 */
- (NSArray *)wd_reverseArray;
@end

