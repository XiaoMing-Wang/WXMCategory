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
- (UIViewController *)wc_responderViewController;

/** 在window中 */
- (CGRect)wc_locationWithWindow;

/** 截图 */
- (UIImage *)wc_makeImage;

/** view截图存在本地 */
- (void)wc_saveImageInlocation:(NSString *)imageName;

/** 手势 */
- (void)wc_addTapped:(id)target action:(SEL)action;
- (UITapGestureRecognizer *)wc_addOnceTappedWithCallback:(void (^)(void))callback;
- (UITapGestureRecognizer *)wc_addDoubleTappedWithCallback:(void (^)(void))callback;

/** 渐现动画 */
- (void)wc_fadeAnimation;

/** 居中设置 */
- (void)wc_horizontalSet:(UIView *)left nether:(UIView *)right interval:(CGFloat)interval;
- (void)wc_venicalSet:(UIView *)above nether:(UIView *)nether interval:(CGFloat)interval;

/** 获取xib */
+ (instancetype)xibFileWithName:(NSString *)nibName currentIdex:(NSInteger)currentIdex;

/// 任意边角画圆角
/// @param rectCorner 圆角边
/// @param cornerRadius 圆角大小
- (void)wc_drawSemicircle:(UIRectCorner)rectCorner cornerRadius:(CGFloat)cornerRadius;

@end
