//
//  NSNotificationCenter+DXPCategory.m
//  Bili
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define KEYS @"NSNotificationCenterKey"
#import "NSNotificationCenter+DXPCategory.h"
#import <objc/runtime.h>

/** 在viewcontroller+dxpclass类别里面做了自动释放 */
@implementation NSNotificationCenter (DXPCategory)
- (void)addObserver:(UIViewController *)observer
               name:(NSString *)name
             object:(id)obj
         usingBlock:(void (^)(NSNotification *note))block {
    
    NSObject *object = [[NSNotificationCenter defaultCenter] addObserverForName:name object:obj queue:nil usingBlock:block];
    NSDictionary *dictionary = objc_getAssociatedObject(observer, KEYS);
    if (!dictionary) dictionary = [NSDictionary dictionary];
    NSMutableDictionary *dicM = [[NSMutableDictionary alloc] initWithDictionary:dictionary];
    [dicM setObject:object forKey:name];
    objc_setAssociatedObject(observer, KEYS, dicM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
