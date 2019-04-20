//
//  CALayer+DXPClass.m
//  Bili
//
//  Created by wq on 16/10/8.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "CALayer+DXPClass.h"

@implementation CALayer (DXPClass)
- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint point = self.position;
    point.x = centerX;
    self.position = point;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint point = self.position;
    point.y = centerY;
    self.position = point;
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left {
    [self setX:left];
}
- (void)setRight:(CGFloat)right {
    [self setX:right - self.width];
}
- (void)setTop:(CGFloat)top {
    [self setY:top];
}
- (void)setBottom:(CGFloat)bottom {
    [self setY:bottom - self.height];
}

- (CGFloat)x {
    return self.frame.origin.x;
}
- (CGFloat)y {
    return self.frame.origin.y;
}
- (CGFloat)width {
    return self.frame.size.width;
}
- (CGFloat)height {
    return self.frame.size.height;
}
- (CGFloat)centerX {
    return self.position.x;
}
- (CGFloat)centerY {
    return self.position.y;
}
- (CGFloat)left {
    return CGRectGetMidX(self.frame);
}
- (CGFloat)right {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)top {
    return CGRectGetMidY(self.frame);
}
- (CGFloat)bottom {
    return CGRectGetMaxY(self.frame);
}
- (CGSize)size {
    return self.frame.size;
}

- (void)setImage:(UIImage *)image {
    self.contents = (id) image.CGImage;
}
- (UIImage *)image {
    return (UIImage *)self.contents;
}

+ (void)removeImplicitanimationWithBlock:(void (^)(void))block {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    if (block) block();
    [CATransaction commit];
}

- (void)setBorderColorWithUIColor:(UIColor *)color {
    self.borderColor = color.CGColor;
}
@end
