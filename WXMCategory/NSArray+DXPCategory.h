//
//  NSArray+DXPCategory.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (DXPCategory)

/** 判断数组是否可用 */
- (BOOL)isAvailable;

/** 加载plist文件 */
+ (NSArray *)arrayWithPlist:(NSString *)plistName;

@end

