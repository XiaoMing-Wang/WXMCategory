//
//  NSArray+DXPCategory.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "NSArray+WXMCategory.h"
#import <objc/runtime.h>

@implementation NSArray (WXMCategory)

+ (void)load {
    Class __ArrayI = NSClassFromString(@"__NSArrayI");
    Class __ArrayM = NSClassFromString(@"__NSArrayM");

    SEL objectAtIndex = @selector(objectAtIndex:);
    SEL wd_SafeObjectAtIndex = @selector(wd_SafeObjectAtIndex:);
    
    SEL addObject = @selector(addObject:);
    SEL wd_SafeAddObject = @selector(wd_SafeAddObject:);
    
    SEL objectAtIndexedSubscript = @selector(objectAtIndexedSubscript:);
    SEL wd_SafeObjectAtIndexedSubscript = @selector(wd_SafeObjectAtIndexedSubscript:);
    
    [self wd_swizzleInstanceMethod:objectAtIndexedSubscript with:wd_SafeObjectAtIndexedSubscript class:__ArrayI];
    [self wd_swizzleInstanceMethod:objectAtIndexedSubscript with:wd_SafeObjectAtIndexedSubscript class:__ArrayM];
    
    [self wd_swizzleInstanceMethod:objectAtIndex with:wd_SafeObjectAtIndex class:__ArrayI];
    [self wd_swizzleInstanceMethod:objectAtIndex with:wd_SafeObjectAtIndex class:__ArrayM];
    
    [self wd_swizzleInstanceMethod:addObject with:wd_SafeAddObject class:__ArrayI];
    [self wd_swizzleInstanceMethod:addObject with:wd_SafeAddObject class:__ArrayM];
}

/** -方法 */
+ (BOOL)wd_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel class:(Class)aclass {
    Method original = class_getInstanceMethod(aclass, originalSel);
    Method newMethod = class_getInstanceMethod(aclass, newSel);
    if (!original || !newMethod) return NO;
    
    IMP originalImp = class_getMethodImplementation(aclass, originalSel);
    IMP newMethodImp = class_getMethodImplementation(aclass, newSel);
    class_addMethod(aclass, originalSel, originalImp, method_getTypeEncoding(original));
    class_addMethod(aclass, newSel, newMethodImp, method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(aclass, originalSel),
                                   class_getInstanceMethod(aclass, newSel));
    return YES;
}

/** 防止数组越界崩溃 */
- (id)wd_SafeObjectAtIndex:(NSUInteger)index {
    if (index + 1 > self.count || self.count == 0) {
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"数组个数:%zd____下标index:%zd", self.count, index);
        return nil;
    } else return [self wd_SafeObjectAtIndex:index];
}

/** 防止数组越界崩溃 */
- (id)wd_SafeObjectAtIndexedSubscript:(NSUInteger)index {
    if (self.count <= index  || self.count == 0) {
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"____________________________________________________________数组越界");
        NSLog(@"数组个数:%zd____下标index:%zd", self.count, index);
        return nil;
    } else return [self wd_SafeObjectAtIndexedSubscript:index];
}

/** 防止插入数组对象为空崩溃 */
- (void)wd_SafeAddObject:(id)obj {
    if (obj == nil) {
        NSLog(@"_____________________________________________________________对象为空");
        NSLog(@"_____________________________________________________________对象为空");
        NSLog(@"_____________________________________________________________对象为空");
        NSLog(@"数组个数 : %zd_____数组 : %@", self.count, self);
        return;
    }
    [self wd_SafeAddObject:obj];
}

/** 判断数组是否可用 */
- (BOOL)available {
    return (self && [self isKindOfClass:[NSArray class]] && self.count != 0);
}

/** 加载plist文件 */
+ (NSArray *)wd_arrayWithPlist:(NSString *)plistName {
    return [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"]];
}

/** 重复的object只添加一次 */
- (void)wd_addRepeatObject:(NSString *)object {
    if (!object) return;
    if (![self containsObject:object] && [self isKindOfClass:[NSMutableArray class]]) {
        NSMutableArray *arrays = (NSMutableArray *) self;
        [arrays addObject:object];
    }
}

- (NSArray *)wd_reverseArray {
    NSMutableArray *arrayTemp = [NSMutableArray arrayWithCapacity:self.count];
    NSEnumerator *enumerator = [self reverseObjectEnumerator];
    for (id element in enumerator) {
        [arrayTemp addObject:element];
    }
    return arrayTemp;
}
@end

