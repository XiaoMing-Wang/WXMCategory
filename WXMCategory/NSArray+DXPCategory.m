//
//  NSArray+DXPCategory.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "NSArray+DXPCategory.h"
#import <objc/runtime.h>
@implementation NSArray (DXPCategory)

+ (void)load {
    Class __ArrayI = NSClassFromString(@"__NSArrayI");
    Class __ArrayM = NSClassFromString(@"__NSArrayM");

    SEL objectAtIndex = @selector(objectAtIndex:);
    SEL dxpSafeObjectAtIndex = @selector(dxpSafeObjectAtIndex:);
    
    SEL addObject = @selector(addObject:);
    SEL dxpSafeAddObject = @selector(dxpSafeAddObject:);
    
    [self swizzleClass:__ArrayI Method:objectAtIndex with:dxpSafeObjectAtIndex];
    [self swizzleClass:__ArrayM Method:objectAtIndex with:dxpSafeObjectAtIndex];
    
    [self swizzleClass:__ArrayI Method:addObject with:dxpSafeAddObject];
    [self swizzleClass:__ArrayM Method:addObject with:dxpSafeAddObject];
}
/** +方法 */
+ (BOOL)swizzleClass:(Class)aclass Method:(SEL)originalSel with:(SEL)newSel {
    Class class = object_getClass(aclass);
    Method originalMethod = class_getInstanceMethod(class, originalSel);
    Method newMethod = class_getInstanceMethod(class, newSel);
    if (!originalMethod || !newMethod) return NO;
    method_exchangeImplementations(originalMethod, newMethod);
    return YES;
}
/** 防止数组越界崩溃 */
- (id)dxpSafeObjectAtIndex:(NSUInteger)index {
    if (index + 1 > self.count) {
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"数组个数:%zd____下标index:%zd", self.count, index);
        return nil;
    } else return [self dxpSafeObjectAtIndex:index];
}
/** 防止插入数组对象为空崩溃 */
- (void)dxpSafeAddObject:(id)obj {
    if (obj == nil) {
        NSLog(@"_____________________________________________________________对象为空");
        NSLog(@"_____________________________________________________________对象为空");
        NSLog(@"_____________________________________________________________对象为空");
        NSLog(@"数组对象:%@____数组个数:%zd", self, self.count);
        return;
    }
    [self dxpSafeAddObject:obj];
}
/** 判断数组是否可用 */
- (BOOL)isAvailable {
    return (self && [self isKindOfClass:[NSArray class]] && self.count != 0);
}

/** 加载plist文件 */
+ (NSArray *)arrayWithPlist:(NSString *)plistName {
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]
                            pathForResource:plistName
                                     ofType:@"plist"]];
}
@end

