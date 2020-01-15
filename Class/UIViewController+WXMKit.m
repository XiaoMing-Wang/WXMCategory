//
//  UIViewController+WXMKit.m
//  哈哈哈
//
//  Created by edz on 2019/5/31.
//  Copyright © 2019 wq. All rights reserved.
//
#define WXM_KEYS @"NSNotificationCenterKey"
#import <objc/runtime.h>
#import "UIViewController+WXMKit.h"

@implementation UIViewController (WXMKit)

+ (void)load {
    Method method1 = class_getInstanceMethod(self, NSSelectorFromString(@"dealloc"));
    Method method2 = class_getInstanceMethod(self, @selector(_dealloc));
    method_exchangeImplementations(method1, method2);
}

- (void)_dealloc {

#if DEBUG
    NSLog(@"%@ 被释放", NSStringFromClass([self class]));
#endif
    
    /** 释放观察者 */
    NSDictionary *dictionary = objc_getAssociatedObject(self, WXM_KEYS);
    if (dictionary) {
        objc_setAssociatedObject(self, WXM_KEYS, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [dictionary enumerateKeysAndObjectsUsingBlock:^(id key, NSObject * obj, BOOL *stop) {
            [[NSNotificationCenter defaultCenter] removeObserver:obj];
        }];
    }
    [self _dealloc];
}

/* AlertController */
- (UIAlertController *)wc_showAlertViewControllerWithTitle:(NSString *)title
                                                   message:(NSString *)message
                                                    cancel:(NSString *)cancleString {
    
    return [self wc_showAlertViewControllerWithTitle:title
                                             message:message
                                              cancel:cancleString
                                         otherAction:nil
                                       completeBlock:nil];
}

/* AlertController */
- (UIAlertController *)wc_showAlertViewControllerWithTitle:(NSString *)title
                                                   message:(NSString *)message
                                                    cancel:(NSString *)cancle
                                               otherAction:(NSArray *)otherAction
                                             completeBlock:(void (^)(NSInteger idx))block {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WXM_KEYS object:nil];
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:1];
    
    UIAlertAction *cancleAction = nil;
    cancleAction = [UIAlertAction actionWithTitle:cancle style:1 handler:^(UIAlertAction *acn) {
        if (block) block(0);
    }];
    [alert addAction:cancleAction];
    
    [otherAction enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * ts = [otherAction objectAtIndex:idx];
        UIAlertAction *action = nil;
        action = [UIAlertAction actionWithTitle:ts style:0 handler:^(UIAlertAction *a) {
            if (block) block(idx + 1);
        }];
        [alert addAction:action];
    }];
    
    [(self.navigationController ?: self) presentViewController:alert animated:YES completion:nil];
    return alert;
}

/** 警告框  Sheet*/
- (UIAlertController *)wc_showSheetViewControllerWithTitle:(NSString *)title
                                                   message:(NSString *)message
                                                    cancel:(NSString *)cancle
                                               otherAction:(NSArray *)otherAction
                                             completeBlock:(void (^)(NSInteger idx))block {
    [[NSNotificationCenter defaultCenter] postNotificationName:WXM_KEYS object:nil];
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:0];
    
    UIAlertAction *cancleAction = nil;
    cancleAction = [UIAlertAction actionWithTitle:cancle style:1 handler:^(UIAlertAction *a) {
        if (block) block(0);
    }];
    [alert addAction:cancleAction];
    
    [otherAction enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSString * ts = [otherAction objectAtIndex:idx];
        UIAlertAction *action = nil;
        action = [UIAlertAction actionWithTitle:ts style:0 handler:^(UIAlertAction *a) {
            if (block) block(idx + 1);
        }];
        [alert addAction:action];
    }];
    
    [(self.navigationController ?: self) presentViewController:alert animated:YES completion:nil];
    return alert;
}

@end

/** 导航控制器  */
@implementation UINavigationController (WXMKit)

/** 颜色画图 */
static inline UIImage *WXM_colorConversionImage(UIColor *color) {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 设置导航栏透明 */
- (void)wc_setNavigationBarColor:(UIColor *)color alpha:(CGFloat)alpha {
    self.navigationBar.shadowImage = [[UIImage alloc] init];
    self.navigationBar.backgroundColor = [UIColor clearColor];
    color = [color colorWithAlphaComponent:alpha];
    [self.navigationBar setBackgroundImage:WXM_colorConversionImage(color) forBarMetrics:UIBarMetricsDefault];
}

/** 跳到某个页面 */
- (void)wc_popToViewControllerWithControllerName:(NSString *)vcName animated:(BOOL)animated {
    NSArray *arrayVC = self.viewControllers;
    if (arrayVC.count <= 1) return;
    [arrayVC enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:NSClassFromString(vcName)]){
            [self popToViewController:obj animated:animated];
            *stop = YES;
        }
    }];
}

/** 判断是否包含某个页面 */
- (BOOL)wc_haveChildViewControllers:(NSString *)vcName {
    NSArray *arrayVC = self.viewControllers;
    BOOL haveChild = NO;
    for (UIViewController *obj in arrayVC) {
        if ([obj isKindOfClass:NSClassFromString(vcName)]) {
            haveChild = YES;
            break;
        }
    }
    return haveChild;
}

/** 插入某个页面 */
- (void)wc_insertViewControlle:(NSString *)vcName index:(NSInteger)index {
    NSMutableArray *arrayVC = self.viewControllers.mutableCopy;
    if (index >= arrayVC.count) return;
    UIViewController *vc = [NSClassFromString(vcName) new];
    if (vc == nil) return;
    [arrayVC insertObject:vc atIndex:index];
    if (arrayVC.count > 0) vc.hidesBottomBarWhenPushed = YES;
    [self setViewControllers:arrayVC.copy];
}

/** 删除NavigationController子控制器 */
- (void)wc_removeViewControllerWithControllerName:(NSString *)vcName {
    NSMutableArray *arrayM = @[].mutableCopy;
    NSArray *vcs = self.viewControllers;
    if (vcs.count <= 1) return;
    [vcs enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:NSClassFromString(vcName)] || obj == self.visibleViewController) {
            [arrayM addObject:obj];
        }
    }];
    [self setViewControllers:arrayM];
}

/** 删除NavigationController子控制器 */
- (void)wc_removeViewControllerWithControllers:(NSArray *)controllers {
    @synchronized (self.navigationController) {
        NSMutableArray *arrayM = @[].mutableCopy;
        NSArray *vcs = self.viewControllers;
        if (vcs.count <= 1) return;
        [vcs enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
            NSString *vcString = NSStringFromClass(obj.class);
            if (![controllers containsObject:vcString] || obj == self.visibleViewController) {
                [arrayM addObject:obj];
            }
        }];
        [self setViewControllers:arrayM];
    }
}

/** 回退到第几个界面 */
- (void)wc_popViewControllerIndex:(NSString *)index {
    NSArray *arrayVC = self.viewControllers;
    NSInteger indexInt = index.integerValue;
    if (indexInt < 0 || indexInt >= 7 || indexInt >= arrayVC.count) return;
    [arrayVC enumerateObjectsUsingBlock:^(UIViewController *obj, NSUInteger idx, BOOL *stop) {
        if (indexInt == idx) {
            [self popToViewController:obj animated:YES];
            *stop = YES;
        }
    }];
}

@end

/** TabBar控制器  */
@implementation UITabBarController (WXMKit)

//UIOffset titlePosition = UIOffsetMake(0, -2); 字体的位置
- (void)wc_addChildViewController:(NSString *)viewController
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
    navigationController.title = title; /**  tabBar上的标题 */
    [self addChildViewController:navigationController];
}
@end

/** Alert控制器  */
@implementation UIAlertController (WXMKit)
@dynamic wc_messageFont;
@dynamic wc_messageTextAlignment;
@dynamic wc_titleTextAlignment;

- (void)setWc_messageFont:(UIFont *)wc_messageFont {
    if (self.message == nil) return;
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:self.message];
    NSRange range = NSMakeRange(0, self.message.length);
    [att addAttribute:NSFontAttributeName value:wc_messageFont range:range];
    self.message = @"";
    [self setValue:att forKey:@"attributedMessage"];
}

- (void)setWc_titleTextAlignment:(NSTextAlignment)wc_titleTextAlignment {
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:self.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[0];
        messageLb.textAlignment = wc_titleTextAlignment;
    }
}
- (void)setWc_messageTextAlignment:(NSTextAlignment)wc_messageTextAlignment {
    UIView *messageParentView = [self getParentViewOfTitleAndMessageFromView:self.view];
    if (messageParentView && messageParentView.subviews.count > 1) {
        UILabel *messageLb = messageParentView.subviews[1];
        messageLb.textAlignment = wc_messageTextAlignment;
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
