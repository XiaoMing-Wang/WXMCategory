//
//  UIBarButtonItem+DXPClass.h
//  Bili
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DXPClass)

/** title 系统的有键盘出现系统的会失去响应  */
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                  tintColor:(UIColor *)tintColor
                                     action:(void (^)(void))action;

/** title 自定义的 */
+ (UIBarButtonItem *)barButtonCustomWithTitle:(NSString *)title
                                    tintColor:(UIColor *)tintColor
                                       action:(void (^)(void))action;

/** 自定义单图片 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                   action:(void (^)(void))action;
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                   target:(id)target
                                   action:(SEL)action;

/** 自定义图片+文字 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   action:(void (^)(void))action;
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                   action:(SEL)action;
@end
