//
//  CALayer+WXMKit.m
//  Multi-project-coordination
//
//  Created by wq on 2019/5/26.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import "CALayer+WXMKit.h"

@implementation CALayer (WXMKit)
@dynamic layoutRight;
@dynamic layoutBottom;
@dynamic layoutCenterSupLayer;

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
- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect){ origin, self.size};
}
- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setLeft:(CGFloat)left { [self setX:left]; }
- (void)setRight:(CGFloat)right { [self setX:right - self.width]; }
- (void)setTop:(CGFloat)top { [self setY:top]; }
- (void)setBottom:(CGFloat)bottom { [self setY:bottom - self.height]; }

- (CGFloat)x {return self.frame.origin.x;}
- (CGFloat)y {return self.frame.origin.y;}
- (CGFloat)width {return self.frame.size.width;}
- (CGFloat)height {return self.frame.size.height;}
- (CGFloat)centerX {return self.position.x;}
- (CGFloat)centerY {return self.position.y;}
- (CGFloat)left {return self.frame.origin.x; }
- (CGFloat)right {return self.left + self.width; }
- (CGFloat)top {return self.frame.origin.y;}
- (CGFloat)bottom {  return self.top + self.height; }
- (CGSize)size { return self.frame.size; }
- (CGPoint)origin { return self.frame.origin; }

/** 相对定位 */
- (void)setLayoutRight:(CGFloat)layoutRight {
    if (self.left != 0 && self.width != 0) return;
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.superlayer) width = self.superlayer.width;
    if (self.width == 0) self.width = width - self.left - layoutRight;
    if (self.left == 0) self.left = width - self.width - layoutRight;
}

- (void)setLayoutBottom:(CGFloat)layoutBottom {
    if (self.top != 0 && self.height != 0) return;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (self.superlayer) height = self.superlayer.height;
    if (self.height == 0) self.height = height - self.top - layoutBottom;
    if (self.top == 0) self.top = height - self.height - layoutBottom;
}

- (void)setLayoutCenterSupLayer:(BOOL)layoutCenterSupLayer {
    if (self.superlayer) return;
    if (layoutCenterSupLayer) {
        self.centerX = self.superlayer.width / 2;
        self.centerY = self.superlayer.height / 2;
    } else self.centerY = self.superlayer.height / 2;
}
@end
