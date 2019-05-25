//
//  NSDictionary+DXPCategory.m
//  ChaomengPlanet
//
//  Created by 超盟 on 2018/10/9.
//  Copyright © 2018年 wq. All rights reserved.
//

#import "NSDictionary+WXMCategory.h"
#import <objc/runtime.h>

@implementation NSDictionary (DXPCategory)

+ (void)load {
    Class NSDictionaryI = NSClassFromString(@"__NSDictionaryI");
    Class NSDictionaryM = NSClassFromString(@"__NSDictionaryM");
    
    SEL setObject = @selector(setObject:forKey:);
    SEL safeSetObject = @selector(safeSetObject:forKey:);
    
    SEL objectForKey = @selector(objectForKey:);
    SEL safeObjectForKey = @selector(safeObjectForKey:);
    
    [self swizzleClass:NSDictionaryI Method:setObject with:safeSetObject];
    [self swizzleClass:NSDictionaryM Method:setObject with:safeSetObject];
    [self swizzleClass:NSDictionaryI Method:objectForKey with:safeObjectForKey];
    [self swizzleClass:NSDictionaryM Method:objectForKey with:safeObjectForKey];
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

/** 转字符串 */
- (NSString *)wxm_jsonRepresentation {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)safeSetObject:(id)anObject forKey:(id)aKey {
    if (aKey == nil || anObject == nil) {
        NSLog(@"__________________________________________________字典插入对象为空");
        NSLog(@"__________________________________________________字典插入对象为空");
        NSLog(@"__________________________________________________字典插入对象为空");
        NSLog(@"键名 key === %@", aKey);
        return;
    }
    [self safeSetObject:anObject forKey:aKey];
}

- (nullable id)safeObjectForKey:(NSString *)anAttribute {
    id object = [self safeObjectForKey:anAttribute];
    if (object == [NSNull null]) return nil;
    return object;
}
@end
