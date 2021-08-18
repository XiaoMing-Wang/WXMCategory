//
//  UIButton+DXPClass.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "UIButton+WXMKit.h"
#import <objc/runtime.h>

static char touchKeyS;
static char topNameKey;
static char bottomNameKey;
static char leftNameKey;
static char rightNameKey;
static char enabledKey;
static char indicatorViewKey;
static char buttonTextObjectKey;

@implementation UIButton (WXMKit)

- (void)wd_setFontOfSize:(CGFloat)size {
    self.titleLabel.font = [UIFont systemFontOfSize:size];
}

- (void)wd_setTitle:(NSString *)title {
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)wd_setTitleColor:(UIColor *)color {
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)wd_setImage:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)wd_setImageOfSelected:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

- (void)wd_setImageOfDisable:(NSString *)imageName {
    [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

- (void)wd_setBackgroundImage:(NSString *)imageName {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
}

- (void)wd_setBackgroundImageOfSelected:(NSString *)imageName {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateSelected];
}

- (void)wd_setBackgroundImageOfDisabled:(NSString *)imageName {
    [self setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateDisabled];
}

- (void)wd_addTarget:(nullable id)target action:(SEL)action {
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

/** 点击 block */
- (void)wd_blockWithControlEventTouchUpInside:(void (^)(void))block {
    objc_setAssociatedObject(self, &touchKeyS, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIControlEvents event = UIControlEventTouchUpInside;
    [self addTarget:self action:@selector(callActionBlockButton:) forControlEvents:event];
}

- (void)callActionBlockButton:(id)sender {
    void (^buttonBlock)(void) = (void (^)(void))objc_getAssociatedObject(self, &touchKeyS);
    if (buttonBlock) buttonBlock();
}

/**  设置图片字体上下对齐 */
- (void)wd_alineTextAlignment:(CGFloat)space {
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
- (void)wd_horizontalCenterTitleimage:(CGFloat)space {
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, 0.0, imageSize.width + space / 2);
    titleSize = self.titleLabel.frame.size;
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, titleSize.width + space / 2, 0.0, -titleSize.width);
}

/** 扩大点击 */
- (void)wd_setEnlargeEdgeWithTop:(CGFloat)top left:(CGFloat)left right:(CGFloat)right bottom:(CGFloat)bottom {
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

/** 带动画的enabled */
- (void)wd_enabledAnimation:(BOOL)enabled {
    if (enabled == self.enabled) return;
    @synchronized (self) {
        UIImageView *contentView = self.wd_imageView;
        if (!contentView) return;
        UIImage *imageNormal= [self backgroundImageForState:UIControlStateNormal];
        UIImage *imageDisabled = [self backgroundImageForState:UIControlStateDisabled];
        if (!imageNormal || !imageDisabled) return;
        
        self.enabled = enabled;
        self.userInteractionEnabled = NO;
        UIViewAnimationOptions option = UIViewAnimationOptionCurveEaseInOut;
        UIImageView *wrapView = [[UIImageView alloc] initWithFrame:contentView.bounds];
        wrapView.image = (enabled ? imageDisabled : imageNormal);
        
        objc_setAssociatedObject(self, &enabledKey, @(YES), OBJC_ASSOCIATION_COPY_NONATOMIC);
        [contentView insertSubview:wrapView atIndex:0];
        [UIView animateWithDuration:.75 delay:0 options:option animations:^{
            wrapView.alpha = 0;
        } completion:^(BOOL finished) {
            [wrapView removeFromSuperview];
            self.userInteractionEnabled = YES;
            objc_setAssociatedObject(self, &enabledKey, @(NO), OBJC_ASSOCIATION_COPY_NONATOMIC);
        }];
    }
}

/** 获取背景ImageView */
- (UIImageView *)wd_imageView {
    __block UIImageView *imageView = nil;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * stop) {
        if ([obj isKindOfClass:[UIImageView class]]) imageView = (UIImageView *)obj;
    }];
    return imageView;
}

/** 显示菊花 */
- (void)wd_showIndicator {
    UIActivityIndicatorViewStyle style = UIActivityIndicatorViewStyleWhite;
    UIActivityIndicatorView *indicator = nil;
    indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    objc_setAssociatedObject(self, &buttonTextObjectKey, currentButtonText, 1);
    objc_setAssociatedObject(self, &indicatorViewKey, indicator, 1);
    
    self.userInteractionEnabled = NO;
    [self setTitle:@"" forState:UIControlStateNormal];
    [self addSubview:indicator];
}

/** 隐藏菊花 */
- (void)wd_hideIndicator {
    self.userInteractionEnabled = YES;
    UIActivityIndicatorView *indicator = nil;
    NSString *currentText = objc_getAssociatedObject(self, &buttonTextObjectKey);
    indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &indicatorViewKey);
    [indicator removeFromSuperview];
    [self setTitle:currentText forState:UIControlStateNormal];
}

@end

