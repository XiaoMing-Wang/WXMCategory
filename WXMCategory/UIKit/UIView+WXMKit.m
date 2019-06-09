//
//  UIView+WXMKit.m
//  Multi-project-coordination
//
//  Created by wq on 2019/5/26.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import "UIView+WXMKit.h"

@implementation UIView (WXMKit)

@dynamic layoutRight;
@dynamic layoutBottom;
@dynamic layoutCenterSupView;

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
    CGPoint point = self.center;
    point.x = centerX;
    self.center = point;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y = centerY;
    self.center = point;
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
- (CGFloat)centerX {return self.center.x;}
- (CGFloat)centerY {return self.center.y;}
- (CGFloat)left {return self.frame.origin.x; }
- (CGFloat)right {return self.left + self.width; }
- (CGFloat)top {return self.frame.origin.y;}
- (CGFloat)bottom {  return self.top + self.height; }
- (CGSize)size { return self.frame.size; }
- (CGPoint)origin { return self.frame.origin; }

/** 相对定位 */
- (void)setLayoutRight:(CGFloat)layoutRight {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    if (self.superview) width = self.superview.width;
    if (self.left == 0 && self.width > 0) {
        self.left = width - self.width - layoutRight;
    } else {
        self.width = width - self.left - layoutRight;
    }
}

- (void)setLayoutBottom:(CGFloat)layoutBottom {
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    if (self.superview) height = self.superview.height;
    if (self.top == 0 && self.height > 0) {
        self.top = height - self.height - layoutBottom;
    } else {
        self.height = height - self.top - layoutBottom;
    }
}


- (void)layoutRight:(UIView *)refer offset:(CGFloat)offset {
    CGFloat width = refer.left - self.left;
    if (self.left == 0 && self.width > 0) {
        self.left = width - self.width - offset;
    } else {
        self.width = width - self.left - offset;
    }
}

- (void)layoutBottom:(UIView *)refer offset:(CGFloat)offset {
    CGFloat height = refer.top - self.top;
    if (self.top == 0 && self.height > 0) {
        self.top = height - self.height - offset;
    } else {
        self.height = height - self.top - offset;
    }
}

- (void)setLayoutCenterSupView:(BOOL)layoutCenterSupView {
    if (!self.superview) return;
    if (layoutCenterSupView) {
        self.centerX = self.superview.width / 2;
        self.centerY = self.superview.height / 2;
    } else self.centerY = self.superview.height / 2;
}

@end
