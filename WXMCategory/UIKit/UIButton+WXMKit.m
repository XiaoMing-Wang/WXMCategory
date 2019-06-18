//
//  UIButton+DXPClass.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "UIButton+WXMKit.h"
#import <objc/runtime.h>

static char touchKey;
static char topNameKey;
static char bottomNameKey;
static char leftNameKey;
static char rightNameKey;

@implementation UIButton (WXMKit)

- (void)wxm_setFontOfSize:(CGFloat)size {
    self.titleLabel.font = [UIFont systemFontOfSize:size];
}

- (void)wxm_setTitleOfNormal:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)wxm_setTitleColorOfNormal:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)wxm_setImageOfNormal:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)wxm_setImageOfSelected:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

- (void)wxm_setImageOfDisable:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}


- (void)wxm_setBackgroundImageOfNormal:(NSString *)imageName {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)wxm_setBackgroundImageOfSelected:(NSString *)imageName {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

- (void)wxm_setBackgroundImageOfDisabled:(NSString *)imageName {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

- (void)wxm_addTarget:(nullable id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/** 点击 block */
- (void)wxm_blockWithControlEventTouchUpInside:(void (^)(void))block {
    objc_setAssociatedObject(self, &touchKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIControlEvents event = UIControlEventTouchUpInside;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    void (^buttonBlock)(void) = (void (^)(void))objc_getAssociatedObject(self, &touchKey);
    if (buttonBlock) buttonBlock();
}

/**  设置图片字体上下对齐 */
- (void)wxm_alineTextAlignment:(CGFloat)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    CGSize textSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];
    
    CGSize frameSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height));
    if (titleSize.width + 0.5 < frameSize.width) titleSize.width = frameSize.width;
    CGFloat totalHeight = (imageSize.height + titleSize.height + space);
    self.imageEdgeInsets = UIEdgeInsetsMake(-(totalHeight - imageSize.height), 0.0, 0.0, -titleSize.width);
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -imageSize.width, -(totalHeight - titleSize.height), 0);
}

/** 左图右字 */
- (void)wxm_horizontalCenterTitleimage:(CGFloat)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, 0.0, imageSize.width + space / 2);
    titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + space / 2, 0.0, -titleSize.width);
}

/** 扩大点击 */
- (void)wxm_setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom {
    objc_setAssociatedObject(self, &topNameKey, @(top), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, @(right), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, @(bottom), OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, @(left), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (CGRect)enlargedRect {
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge) {
        CGFloat x = self.bounds.origin.x - leftEdge.floatValue;
        CGFloat y = self.bounds.origin.y - topEdge.floatValue;
        CGFloat w = self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue;
        CGFloat h = self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue;
        return CGRectMake(x, y, w, h);
    } else return self.bounds;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds)) return [super hitTest:point withEvent:event];
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end

