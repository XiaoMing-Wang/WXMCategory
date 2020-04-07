//
//  NSNotificationCenter+DXPCategory.h
//  Bili
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define WCSTATIC_CONST_DEFINE(DEFINE) class NSObject; static NSString *const DEFINE = (@#DEFINE);
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNotificationCenter (WXMCategory)

/** 自动释放 在view和控制器的dealloc里面 */
- (void)wc_addObserver:(UIViewController *)observer
                  name:(NSString *)name
                object:(id)obj
            usingBlock:(void (^)(NSNotification *note))block;

@end

static inline void wc_addNotificationSEL(id obser, SEL selector, NSString *name, id object) {
    [[NSNotificationCenter defaultCenter] addObserver:obser selector:selector name:name object:object];
}

static inline void wc_addNotification(UIViewController *obser, NSString *name, id object, void (^usingBlock)(NSNotification *note)) {
    [[NSNotificationCenter defaultCenter] wc_addObserver:obser name:name object:object usingBlock:usingBlock];
}

static inline void wc_postNotification(NSString *name, id object) {
    [[NSNotificationCenter defaultCenter] postNotificationName:name object:object userInfo:nil];
}
