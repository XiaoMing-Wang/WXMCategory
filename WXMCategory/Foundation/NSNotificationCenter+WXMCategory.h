//
//  NSNotificationCenter+DXPCategory.h
//  Bili
//
//  Created by Mac on 16/10/24.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSNotificationCenter (WXMCategory)

/** 自动释放 在view和控制器的dealloc里面 */

- (void)wxm_addObserver:(UIViewController *)observer
                   name:(NSString *)name
                 object:(id)obj
             usingBlock:(void (^)(NSNotification *note))block;

@end
