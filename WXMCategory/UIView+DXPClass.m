//  UIView+DXPClass.m
//  runTime
//
//  Created by wq on 16/8/10.
//  Copyright © 2016年 WQ. All rights reserved.
//
#import "UIView+DXPClass.h"
#import <objc/runtime.h>

@implementation UIView (DXPClass)
- (void)setX:(CGFloat)x {
    CGRect frame   = self.frame;
    frame.origin.x = x;
    self.frame     = frame;
}
- (void)setY:(CGFloat)y {
    CGRect frame   = self.frame;
    frame.origin.y = y;
    self.frame     = frame;
}
- (void)setWidth:(CGFloat)width {
    CGRect frame     = self.frame;
    frame.size.width = width;
    self.frame       = frame;
}
- (void)setHeight:(CGFloat)height {
    CGRect frame      = self.frame;
    frame.size.height = height;
    self.frame        = frame;
}
- (void)setCenterX:(CGFloat)centerX {
    CGPoint point = self.center;
    point.x       = centerX;
    self.center   = point;
}
- (void)setCenterY:(CGFloat)centerY {
    CGPoint point = self.center;
    point.y       = centerY;
    self.center   = point;
}
- (void)setOrigin:(CGPoint)origin {
    self.frame = (CGRect) { origin, self.size };
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

@end

