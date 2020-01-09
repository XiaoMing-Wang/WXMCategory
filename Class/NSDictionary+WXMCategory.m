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
    
    [self wc_swizzleInstanceMethod:setObject with:safeSetObject class:NSDictionaryI];
    [self wc_swizzleInstanceMethod:setObject with:safeSetObject class:NSDictionaryM];
    
    [self wc_swizzleInstanceMethod:objectForKey with:safeObjectForKey class:NSDictionaryI];
    [self wc_swizzleInstanceMethod:objectForKey with:safeObjectForKey class:NSDictionaryM];
}

/** -方法 */
+ (BOOL)wc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel class:(Class)aclass {
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

/** 转字符串 */
- (NSString *)wc_jsonRepresentation {
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

/** 加载plist文件 */
+ (NSDictionary *)wc_dictionaryWithPlist:(NSString *)plistName {
    return [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle]
                                                       pathForResource:plistName
                                                       ofType:@"plist"]];
}

- (void)safeSetObject:(id)anObject forKey:(id)aKey {
    if (aKey == nil || anObject == nil) {
        NSLog(@"________________________字典插入对象为空__________________________");
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

/** 判断字典是否可用 */
- (BOOL)available {
    return (self && [self isKindOfClass:[NSDictionary class]] && self.allKeys.count != 0);
}

- (void)setNilValueForKey:(NSString *)key { }
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {}
@end
