//
//  CALayer+DXPClass.h
//  Bili
//
//  Created by wq on 16/10/8.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface CALayer (DXPClass)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;
@property (nonatomic, strong) UIImage *image;

/** 去掉隐式动画 */
+ (void)removeImplicitanimationWithBlock:(void (^)(void))block;
- (void)setBorderColorWithUIColor:(UIColor *)color;
@end
