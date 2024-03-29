//
//  UIViewController+WXMKit.h
//  哈哈哈
//
//  Created by edz on 2019/5/31.
//  Copyright © 2019 wq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (WXMKit)

@property (nonatomic, assign) BOOL presentationStyleFull;

/** UIAlertController */
- (UIAlertController *)wd_showAlertViewControllerWithTitle:(NSString *)title
                                                   message:(NSString *)message
                                                    cancel:(NSString *)cancleString;
/** UIAlertController alert */
- (UIAlertController *)wd_showAlertViewControllerWithTitle:(NSString *)title
                                                   message:(NSString *)message
                                                    cancel:(NSString *)cancle
                                               otherAction:(NSArray *_Nullable)otherAction
                                             completeBlock:(void (^_Nullable)(NSInteger idx))block;
/** UIAlertController sheet */
- (UIAlertController *)wd_showSheetViewControllerWithTitle:(NSString *)title
                                                   message:(NSString *)message
                                                    cancel:(NSString *)cancle
                                               otherAction:(NSArray *_Nullable)otherAction
                                             completeBlock:(void (^_Nullable)(NSInteger idx))block;

@end


/** 导航控制器  */
@interface UINavigationController (WXMKit)

/** 设置导航栏透明 */
- (void)wd_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha;

/** 删除NavigationController子控制器 */
- (void)wd_removeViewControllerWithControllerName:(NSString *)vcName;
- (void)wd_removeViewControllerWithControllers:(NSArray *)controllers;

/** 跳到某个界面 */
- (void)wd_popToViewControllerWithControllerName:(NSString *)vcName animated:(BOOL)animated;

/** 回退到第几个界面 */
- (void)wd_popViewControllerIndex:(NSString *)index;

/** 子控制器里是否包含这个控制器 */
- (BOOL)wd_haveChildViewControllers:(NSString *)vcName;

/** 添加子控制器到NavigationController*/
- (void)wd_insertViewControlle:(NSString *)vcName index:(NSInteger)index;

@end

/** TabBar控制器  */
@interface UITabBarController (WXMKit)

- (void)wd_addChildViewController:(NSString *)viewController
                              nav:(NSString *)nav
                            title:(NSString *)title
                            image:(NSString *)image
                    selectedImage:(NSString *)selectedImage
                      imageInsets:(UIEdgeInsets)imageInsets
                    titlePosition:(UIOffset)titlePosition;
@end

/** Alert控制器  */
@interface UIAlertController (WXMKit)
@property (nonatomic, assign) NSTextAlignment wd_titleTextAlignment;
@property (nonatomic, assign) NSTextAlignment wd_messageTextAlignment;
@property (nonatomic, assign) UIFont *wd_messageFont;
@end
NS_ASSUME_NONNULL_END
