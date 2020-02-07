//
//  UIView+WXMKit.h
//  Multi-project-coordination
//
//  Created by wq on 2019/5/26.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WXMKit)

/** 绝对定位 */
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

/** 相对定位 */
@property (nonatomic, assign) CGFloat layoutRight;
@property (nonatomic, assign) CGFloat layoutBottom;
@property (nonatomic, assign) CGFloat layCornerRadius;

- (void)layoutCenterXToSupView:(UIView *)supview;
- (void)layoutCenterYToSupView:(UIView *)supview;
- (void)layoutCenterXYToSupView:(UIView *)supview;
- (void)layoutRight:(UIView *)refer offset:(CGFloat)offset;
- (void)layoutBottom:(UIView *)refer offset:(CGFloat)offset;

@end
