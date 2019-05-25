//
//  UIButton+DXPClass.m
//  类库
//
//  Created by wq on 16/8/28.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import "UIButton+WXMKit.h"
#import <objc/runtime.h>

static char touchUpInsideKey;
static char topNameKey;
static char bottomNameKey;
static char leftNameKey;
static char rightNameKey;
static char responseKey;

@implementation UIButton (WXMKit)
@dynamic wxm_title;
@dynamic wxm_titleColor;
@dynamic wxm_respondTime;

+ (void)load {
    SEL method1 = @selector(sendAction:to:forEvent:);
    SEL method2 = @selector(wxm__sendAction:to:forEvent:);
    [self swizzleInstanceMethod:method1 with:method2];
}

/** -方法 */
+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel {
    Method original = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (!original || !newMethod) return NO;
    
    IMP originalImp = class_getMethodImplementation(self, originalSel);
    IMP newMethodImp = class_getMethodImplementation(self, newSel);
    class_addMethod(self, originalSel, originalImp, method_getTypeEncoding(original));
    class_addMethod(self, newSel, newMethodImp, method_getTypeEncoding(newMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel), class_getInstanceMethod(self, newSel));
    return YES;
}

/** 点击 block */
- (void)wxm_blockWithControlEventTouchUpInside:(void (^)(void))block {
    objc_setAssociatedObject(self, &touchUpInsideKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:UIControlEventTouchUpInside];
}
- (void)callActionBlock:(id)sender {
    void (^buttonBlock)(void) = (void (^)(void))objc_getAssociatedObject(self, &touchUpInsideKey);
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


- (void)setWxm_title:(NSString *)wxm_title {
    [self setTitle:wxm_title forState:UIControlStateNormal];
}
- (void)setWxm_titleColor:(UIColor *)wxm_titleColor {
    [self setTitleColor:wxm_titleColor forState:UIControlStateNormal];
}

- (void)setWxm_respondTime:(CGFloat)wxm_respondTime {
    SEL sel = @selector(wxm_respondTime);
    objc_setAssociatedObject(self, sel, @(wxm_respondTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)wxm_respondTime {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

/** 拦截系统 */
- (void)wxm__sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    BOOL response = [objc_getAssociatedObject(self, &responseKey) boolValue];
    if (response && self.wxm_respondTime > 0) {
        NSLog(@"button暂时不能响应...");
        return;
    }
    
    if (self.wxm_respondTime > 0 && self.wxm_respondTime) {
        CGFloat delay = self.wxm_respondTime * 1.0f;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (delay * NSEC_PER_SEC)),dispatch_get_main_queue(),^{
            objc_setAssociatedObject(self, &responseKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        });
    }
    [self wxm__sendAction:action to:target forEvent:event];
}
@end

