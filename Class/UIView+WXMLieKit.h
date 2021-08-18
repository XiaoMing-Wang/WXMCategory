//
//  UIView+WXMLieKit.h
//  Multi-project-coordination
//
//  Created by wq on 2019/5/26.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WXMLieKit) <UIGestureRecognizerDelegate>

/** 当前控制器 */
- (UIViewController *)wd_responderViewController;

/** 在window中 */
- (CGRect)wd_locationWithWindow;

/** 截图 */
- (UIImage *)wd_makeImage;

/** view截图存在本地 */
- (void)wd_saveImageInlocation:(NSString *)imageName;

/** 手势 */
- (void)wd_tappedWithTarget:(id)target action:(SEL)action;
- (UITapGestureRecognizer *)wd_addOnceTappedWithCallback:(void (^)(void))callback;
- (UITapGestureRecognizer *)wd_addDoubleTappedWithCallback:(void (^)(void))callback;

/** 渐现动画 */
- (void)wd_fadeAnimation;

/** 左右居中对齐 */
- (void)wd_horizontalSet:(UIView *)left nether:(UIView *)right interval:(CGFloat)interval;

/** 上下居中对齐 */
- (void)wd_venicalSet:(UIView *)above nether:(UIView *)nether interval:(CGFloat)interval;

/** 获取xib */
+ (instancetype)wd_xibFileWithName:(NSString *)nibName currentIdex:(NSInteger)currentIdex;

/// 任意边角画圆角
/// @param rectCorner 圆角边
/// @param cornerRadius 圆角大小
- (void)wd_drawSemicircle:(UIRectCorner)rectCorner cornerRadius:(CGFloat)cornerRadius;

@end
