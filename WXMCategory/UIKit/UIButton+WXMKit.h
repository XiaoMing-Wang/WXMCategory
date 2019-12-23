//
//  UIButton+DXPClass.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WXMKit)

- (void)wc_addTarget:(id)target action:(SEL)action;
- (void)wc_blockWithControlEventTouchUpInside:(void (^)(void))block;

/** 带动画的enabled */
- (void)wc_enabledAnimation:(BOOL)enabled;

/** 显示菊花 */
- (void)wc_showIndicator;

/** 隐藏菊花 */
- (void)wc_hideIndicator;

/**  */
- (void)wc_setFontOfSize:(CGFloat)size;
- (void)wc_setTitle:(NSString *)title;
- (void)wc_setTitleColor:(UIColor *)color;
- (void)wc_setImage:(NSString *)imageName;
- (void)wc_setImageOfSelected:(NSString *)imageName;
- (void)wc_setImageOfDisable:(NSString *)imageName;
- (void)wc_setBackgroundImage:(NSString *)imageName;
- (void)wc_setBackgroundImageOfSelected:(NSString *)imageName;
- (void)wc_setBackgroundImageOfDisabled:(NSString *)imageName;

/** 图片字体上下对齐 先设置frame且图片大小 < button 否则会盖住 */
- (void)wc_alineTextAlignment:(CGFloat)space;

/** 左字右图 */
- (void)wc_horizontalCenterTitleimage:(CGFloat)space;

/** 扩大Button的点击范围 */
- (void)wc_setEnlargeEdgeWithTop:(CGFloat)top
                            left:(CGFloat)left
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom;

@end

