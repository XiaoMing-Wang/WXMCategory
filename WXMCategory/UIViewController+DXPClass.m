//
//  UIViewController+DXPClass.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define KEYS @"NSNotificationCenterKey"
#import <objc/runtime.h>
#import "UIViewController+DXPClass.h"
NSString *const ShowAlertViewNotifi = @"ShowAlertViewNotifi";

/** UIView控制器  */
@implementation UIViewController (DXPClass)

+ (void)load {
    Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod(self, @selector(_dealloc));
    method_exchangeImplementations(method1, method2);
}
- (void)_dealloc {
    
#if 1
    NSLog(@"%@ 被释放", NSStringFromClass([self class]));
#endif
    
    //释放观察者
    NSDictionary *dictionary = objc_getAssociatedObject(self, KEYS);
    if (dictionary) {
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id _Nonnull key, NSObject *_Nonnull obj, BOOL *_Nonnull stop) {
            [[NSNotificationCenter defaultCenter] removeObserver:obj];
        }];
        objc_setAssociatedObject(self, KEYS, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self _dealloc];
}

/* AlertController */
- (UIAlertController *)showAlertViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                 cancel:(NSString *)cancleString {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowAlertViewNotifi object:nil];
    
    UIAlertController *a = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *c = [UIAlertAction actionWithTitle:cancleString style:UIAlertActionStyleCancel handler:nil];
    [a addAction:c];
    a.messageFont = [UIFont systemFontOfSize:15];
    [self presentViewController:a animated:YES completion:nil];
    return a;
}

/* AlertController */
- (UIAlertController *)showAlertViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                 cancel:(NSString *)cancleString
                                            otherAction:(NSArray *)otherAction
                                          completeBlock:(void (^)(NSInteger buttonIndex))block {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowAlertViewNotifi object:nil];
    
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:1];
    UIAlertAction *c = [UIAlertAction actionWithTitle:cancleString style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) block(0);
    }];
 
    [aler addAction:c];
    if (otherAction.count > 0) {
        for (int i = 0; i < otherAction.count; i++) {
            NSString * title = otherAction[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:0 handler:^(UIAlertAction *_Nonnull action) {
                if (block) block(i + 1);
            }];
            [aler addAction:action];
        }
    }
    aler.messageFont = [UIFont systemFontOfSize:15];
    [(self.navigationController ?: self) presentViewController:aler animated:YES completion:nil];
    return aler;
}
/** 警告框  Sheet*/
- (UIAlertController *)showSheetViewControllerWithTitle:(NSString *)title
                                                message:(NSString *)message
                                                 cancel:(NSString *)cancleString
                                            otherAction:(NSArray *)otherAction
                                          completeBlock:(void (^)(NSInteger buttonIndex))block {
    [[NSNotificationCenter defaultCenter] postNotificationName:ShowAlertViewNotifi object:nil];
    
    UIAlertController *aler = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:0];
    UIAlertAction *c = [UIAlertAction actionWithTitle:cancleString style:1 handler:^(UIAlertAction * _Nonnull action) {
        if (block) block(0);
    }];
    [aler addAction:c];
    if (otherAction.count > 0) {
        for (int i = 0; i < otherAction.count; i++) {
            NSString * title = otherAction[i];
            UIAlertAction *action = [UIAlertAction actionWithTitle:title style:0 handler:^(UIAlertAction *_Nonnull action) {
                if (block) block(i + 1);
            }];
            [aler addAction:action];
        }
    }
    
    [(self.navigationController ?: self) presentViewController:aler animated:YES completion:nil];
    return aler;
}
/*获取键盘 */
+ (UIWindow *)keyBoardWindow {
    for (UIView *window in [UIApplication sharedApplication].windows) {
        if ([window isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")]) {
            return (UIWindow *) window;
        }
    }
    return nil;
}

@end

/** 导航控制器  */
@implementation UINavigationController (DXPClass)

- (void)setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha {
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    [self.navigationBar setBackgroundImage:[self imageWithColor:[color colorWithAlphaComponent:alpha]] forBarMetrics:UIBarMetricsDefault];
}

/** 跳到某个页面 */
- (void)popToViewControllerWithVCName:(NSString *)vcName animated:(BOOL)animated {
    NSArray *arrayVC = self.viewControllers;
    if (arrayVC.count <= 1) return;
    [arrayVC enumerateObjectsUsingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:NSClassFromString(vcName)]){
            [self popToViewController:obj animated:animated];
            *stop = YES;
        }
    }];
}

/** 判断是否包含某个页面 */
- (BOOL)haveChildViewControllers:(NSString *)childView {
    NSArray *arrayVC = self.viewControllers;
    BOOL haveChild = NO;
    for (UIViewController *obj in arrayVC) {
        if ([obj isKindOfClass:NSClassFromString(childView)]) {
            haveChild = YES; break;
        }
    }
    return haveChild;
}

/** 插入某个页面 */
- (void)insertViewControlle:(NSString *)viewControlle index:(NSInteger)index {
    NSMutableArray *arrayVC = self.viewControllers.mutableCopy;
    if (index >= arrayVC.count) return;
    UIViewController *vc = [NSClassFromString(viewControlle) new];
    if (vc == nil) return;
    [arrayVC insertObject:vc atIndex:index];
    if (arrayVC.count > 0) vc.hidesBottomBarWhenPushed = YES;
    [self setViewControllers:arrayVC.copy];
}

/** 删除NavigationController子控制器*/
- (void)removeViewControllerWithViewControllerName:(NSString *)vcName {
    NSMutableArray *arrayM = @[].mutableCopy;
    NSArray *viewControllers = self.viewControllers;
    if (viewControllers.count <= 1) return;
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (![obj isKindOfClass:NSClassFromString(vcName)]) [arrayM addObject:obj];
    }];
    [self setViewControllers:arrayM];
    
}

/** 回退到第几个界面 */
- (void)popViewControllerIndex:(NSString *)index {
    NSArray *arrayVC = self.viewControllers;
    NSInteger indexInt = index.integerValue;
    if (indexInt < 0 || indexInt >= 7 || indexInt >= arrayVC.count) return;
    [arrayVC enumerateObjectsUsingBlock:^(UIViewController *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        if (indexInt == idx) {
            BOOL hiddenBar = [self isHiddenNavigationBarWithController:obj];
            if (hiddenBar) [self setNavigationBarColor:[UIColor whiteColor] alpha:0];
            [self popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}
- (BOOL)isHiddenNavigationBarWithController:(UIViewController *)vc {
    if ([vc isKindOfClass:NSClassFromString(@"")]) return YES;
    return NO;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
/** TabBar控制器  */
@implementation UITabBarController (DXPClass)

//UIOffset titlePosition = UIOffsetMake(0, -2); 字体的位置
- (void)addChildViewController:(NSString *)viewController
                           nav:(NSString *)nav
                         title:(NSString *)title
                         image:(NSString *)image
                 selectedImage:(NSString *)selectedImage
                   imageInsets:(UIEdgeInsets)imageInsets
                 titlePosition:(UIOffset)titlePosition  {

    UIViewController *vc = [NSClassFromString(viewController) new];
    UINavigationController *navigationController = [[NSClassFromString(nav) alloc] initWithRootViewController:vc];

    navigationController.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationController.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    navigationController.tabBarItem.imageInsets = imageInsets;
    navigationController.tabBarItem.titlePositionAdjustment = titlePosition;
    navigationController.title = title; // tabBar上的标题
    [self addChildViewController:navigationController];
}
@end

/** Alert控制器  */
@implementation UIAlertController (DXPClass)
@dynamic messageFont;
@dynamic messageTextAlignment;
@dynamic titleTextAlignment;

- (void)setMessageFont:(UIFont *)font {
    if (self.message == nil) return;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.message];
    [att addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, self.message.length)];
    self.message = @"";
    [self setValue:att forKey:@"attributedMessage"];
}
- (void)setTitleTextAlignment:(NSTextAlignment)titleTextAlignment {
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:self.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[0];
        messageLb.textAlignment = titleTextAlignment;
    }
}
- (void)setMessageTextAlignment:(NSTextAlignment)messageTextAlignment {
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:self.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[1];
        messageLb.textAlignment = messageTextAlignment;
    }
}
- (UIView *)getParentViewOfTitleAndMessageFromView:(UIView *)view {
    for (UIView *subView in view.subviews) {
        if ([subView isKindOfClass:[UILabel class]])return view;
        else {
            UIView *resultV = [self getParentViewOfTitleAndMessageFromView:subView];
            if (resultV) return resultV;
        }
    }
    return nil;
}
@end

