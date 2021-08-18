//
//  UIBarButtonItem+DXPClass.h
//  Bili
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WXMKit)

/** title 有键盘出现系统的会失去响应  */
+ (UIBarButtonItem *)wd_titleItem:(NSString *)title tintColor:(UIColor *)tintColor action:(void (^)(void))action;

/** title自定义文字(右边)  */
+ (UIBarButtonItem *)wd_titleCustomItem:(NSString *)title tintColor:(UIColor *)tintColor action:(void (^)(void))action;

/** 自定义单图 */
+ (UIBarButtonItem *)wd_imageItem:(NSString *)imageName action:(void (^)(void))action;
+ (UIBarButtonItem *)wd_imageItem:(NSString *)imageName target:(id)target action:(SEL)action;

/** 自定义图片+文字 */
+ (UIBarButtonItem *)wd_imageWithTitleItem:(NSString *)imageName title:(NSString *)title action:(void (^)(void))action;
+ (UIBarButtonItem *)wd_imageWithTitleItem:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action;

@end
