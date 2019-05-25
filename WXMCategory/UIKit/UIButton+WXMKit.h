//
//  UIButton+DXPClass.h
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (WXMKit)

@property (nonatomic, strong) NSString *wxm_title;
@property (nonatomic, strong) UIColor *wxm_titleColor;
@property (nonatomic, assign) CGFloat wxm_respondTime;

/** 点击 block */
- (void)wxm_blockWithControlEventTouchUpInside:(void (^)(void))block;

/** 图片字体上下对齐 先设置frame且图片大小 < button 否则会盖住 */
- (void)wxm_alineTextAlignment:(CGFloat)space;

/** 左字右图 */
- (void)wxm_horizontalCenterTitleimage:(CGFloat)space;

/** 扩大Button的点击范围 */
- (void)wxm_setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom;

@end

