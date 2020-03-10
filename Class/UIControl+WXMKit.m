//
//  UIControl+WXMKit.m
//  Multi-project-coordination
//
//  Created by wq on 2019/6/10.
//  Copyright © 2019年 wxm. All rights reserved.
//
#import <objc/runtime.h>
#import "UIControl+WXMKit.h"

static char responseKey;
static char touchKey;

@implementation UIControl (WXMKit)
@dynamic respondInterval;

+ (void)load {
    SEL method1 = @selector(sendAction:to:forEvent:);
    SEL method2 = @selector(wc_sendAction:to:forEvent:);
    [self swizzleInstanceMethod:method1 with:method2];
}

/** 点击 block */
- (void)wc_blockWithControlEventTouchUpInsideSup:(void (^)(void))block {
    objc_setAssociatedObject(self, &touchKey, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIControlEvents event = UIControlEventTouchUpInside;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender {
    void (^buttonBlock)(void) = (void (^)(void))objc_getAssociatedObject(self, &touchKey);
    if (buttonBlock) buttonBlock();
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
    method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                   class_getInstanceMethod(self, newSel));
    return YES;
}

/** 拦截系统 */
- (void)wc_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    if ([self isKindOfClass:[UIButton class]]) {
        BOOL interruptResponse = [objc_getAssociatedObject(self, &responseKey) boolValue];
        if (interruptResponse && self.respondInterval > 0.0) {
            NSLog(@"button暂时不能响应...");
            return;
        }
        
        if (self.respondInterval > 0.0 && self.respondInterval) {
            objc_setAssociatedObject(self, &responseKey, @(YES), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            CGFloat delay = self.respondInterval * 1.0f;
            dispatch_queue_t queue = dispatch_get_main_queue();
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (delay * NSEC_PER_SEC)), queue,^{
                objc_setAssociatedObject(self, &responseKey, @(NO), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            });
        }
    }
    
    [self wc_sendAction:action to:target forEvent:event];
}

- (void)setRespondInterval:(CGFloat)respondInterval {
    SEL sel = @selector(respondInterval);
    objc_setAssociatedObject(self, sel, @(respondInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)respondInterval {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

@end
