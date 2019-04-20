//
//  UIViewController+DXPClass.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//


#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const ShowAlertViewNotifi;

@interface UIViewController (DXPClass)

/*获取键盘 */
+ (UIWindow *)keyBoardWindow;

/** 警告框 */
- (UIAlertController *)showAlertViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                 cancel:(NSString *)cancleString;
/** 警告框 Alert*/
- (UIAlertController *)showAlertViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                 cancel:(NSString *)cancleString
                                            otherAction:(NSArray *)otherAction
                                          completeBlock:(void (^)(NSInteger buttonIndex))block;
/** 警告框 Sheet*/
- (UIAlertController *)showSheetViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                 cancel:(NSString *)cancleString
                                            otherAction:(NSArray *)otherAction
                                          completeBlock:(void (^)(NSInteger buttonIndex))block;


@end

/** 导航控制器  */
@interface UINavigationController (DXPClass)
/**设置导航栏透明 */
- (void)setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha;
/** 删除NavigationController子控制器 */
- (void)removeViewControllerWithViewControllerName:(NSString *)vcName;
/** 跳到某个界面 */
- (void)popToViewControllerWithVCName:(NSString *)vcName animated:(BOOL)animated;
/** 回退到第几个界面 */
- (void)popViewControllerIndex:(NSString *)index;
/** 子控制器里是否包含这个控制器 */
- (BOOL)haveChildViewControllers:(NSString *)childView;
/** 添加子控制器到NavigationController*/
- (void)insertViewControlle:(NSString *)viewControlle index:(NSInteger)index;

@end

/** TabBar控制器  */
@interface UITabBarController (DXPClass)
- (void)addChildViewController:(NSString *)viewController
                           nav:(NSString *)nav
                         title:(NSString *)title
                         image:(NSString *)image
                 selectedImage:(NSString *)selectedImage
                   imageInsets:(UIEdgeInsets)imageInsets
                 titlePosition:(UIOffset)titlePosition;
@end

/** Alert控制器  */
@interface UIAlertController (DXPClass)
@property (nonatomic, assign) NSTextAlignment titleTextAlignment;
@property (nonatomic, assign) NSTextAlignment messageTextAlignment;
@property (nonatomic, assign) UIFont *messageFont;
@end
