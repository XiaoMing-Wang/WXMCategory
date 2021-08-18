//
//  UIButton+DXPClass.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WXMKit)

- (void)wd_addTarget:(id)target action:(SEL)action;
- (void)wd_blockWithControlEventTouchUpInside:(void (^)(void))block;

/** 带动画的enabled */
- (void)wd_enabledAnimation:(BOOL)enabled;

/** 显示菊花 */
- (void)wd_showIndicator;

/** 隐藏菊花 */
- (void)wd_hideIndicator;

- (void)wd_setFontOfSize:(CGFloat)size;
- (void)wd_setTitle:(NSString *)title;
- (void)wd_setTitleColor:(UIColor *)color;
- (void)wd_setImage:(NSString *)imageName;
- (void)wd_setImageOfSelected:(NSString *)imageName;
- (void)wd_setImageOfDisable:(NSString *)imageName;
- (void)wd_setBackgroundImage:(NSString *)imageName;
- (void)wd_setBackgroundImageOfSelected:(NSString *)imageName;
- (void)wd_setBackgroundImageOfDisabled:(NSString *)imageName;

/** 图片字体上下对齐 先设置frame且图片大小 < button 否则会盖住 */
- (void)wd_alineTextAlignment:(CGFloat)space;

/** 左字右图 */
- (void)wd_horizontalCenterTitleimage:(CGFloat)space;

/** 扩大Button的点击范围 */
- (void)wd_setEnlargeEdgeWithTop:(CGFloat)top
                            left:(CGFloat)left
                           right:(CGFloat)right
                          bottom:(CGFloat)bottom;

@end

