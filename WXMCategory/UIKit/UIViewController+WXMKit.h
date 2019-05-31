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

/** UIAlertController */
- (UIAlertController *)wxm_showAlertViewControllerWithTitle:(NSString *)title
                                                    message:(NSString *)message
                                                     cancel:(NSString *)cancleString;
/** UIAlertController alert */
- (UIAlertController *)wxm_showAlertViewControllerWithTitle:(NSString *)title
                                                    message:(NSString *)message
                                                     cancel:(NSString *)cancle
                                                otherAction:(NSArray *)otherAction
                                              completeBlock:(void (^)(NSInteger index))block;
/** UIAlertController sheet */
- (UIAlertController *)wxm_showSheetViewControllerWithTitle:(NSString *)title
                                                    message:(NSString *)message
                                                     cancel:(NSString *)cancle
                                                otherAction:(NSArray *)otherAction
                                              completeBlock:(void (^)(NSInteger index))block;

@end


/** 导航控制器  */
@interface UINavigationController (WXMKit)

/** 设置导航栏透明 */
- (void)wxm_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha;

/** 删除NavigationController子控制器 */
- (void)wxm_removeViewControllerWithControllerName:(NSString *)vcName;

/** 跳到某个界面 */
- (void)wxm_popToViewControllerWithControllerName:(NSString *)vcName animated:(BOOL)animated;

/** 回退到第几个界面 */
- (void)wxm_popViewControllerIndex:(NSString *)index;

/** 子控制器里是否包含这个控制器 */
- (BOOL)wxm_haveChildViewControllers:(NSString *)vcName;

/** 添加子控制器到NavigationController*/
- (void)wxm_insertViewControlle:(NSString *)vcName index:(NSInteger)index;

@end

/** TabBar控制器  */
@interface UITabBarController (WXMKit)

- (void)wxm_addChildViewController:(NSString *)viewController
                               nav:(NSString *)nav
                             title:(NSString *)title
                             image:(NSString *)image
                     selectedImage:(NSString *)selectedImage
                       imageInsets:(UIEdgeInsets)imageInsets
                     titlePosition:(UIOffset)titlePosition;
@end

/** Alert控制器  */
@interface UIAlertController (WXMKit)
@property (nonatomic, assign) NSTextAlignment wxm_titleTextAlignment;
@property (nonatomic, assign) NSTextAlignment wxm_messageTextAlignment;
@property (nonatomic, assign) UIFont *wxm_messageFont;
@end
NS_ASSUME_NONNULL_END
