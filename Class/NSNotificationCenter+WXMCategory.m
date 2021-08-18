//
//  NSNotificationCenter+DXPCategory.m
//  Bili
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define WXM_KEYS @"NSNotificationCenterKey"
#import "NSNotificationCenter+WXMCategory.h"
#import <objc/runtime.h>

/** 在viewcontroller+dxpclass类别里面做了自动释放 */
@implementation NSNotificationCenter (WXMCategory)

- (void)wd_addObserver:(UIViewController *)observer
                  name:(NSString *)name
                object:(id)obj
            usingBlock:(void (^)(NSNotification *note))block {
    
    NSNotificationCenter * notification = [NSNotificationCenter defaultCenter];
    NSObject *object = [notification addObserverForName:name object:obj queue:nil usingBlock:block];
    NSDictionary *dictionary = objc_getAssociatedObject(observer, WXM_KEYS);
    if (!dictionary) dictionary = [NSDictionary dictionary];
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    [dicM setObject:object forKey:name];
    objc_setAssociatedObject(observer, WXM_KEYS, dicM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
