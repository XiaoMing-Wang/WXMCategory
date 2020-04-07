//
//  UIResponder+WXMCategory.m
//  Multi-project-coordination
//
//  Created by wq on 2020/1/16.
//  Copyright © 2020 wxm. All rights reserved.
//

#import "UIResponder+WXMCategory.h"

@implementation UIResponder (WXMCategory)

/** 响应链传递给父类 */
- (void)routerEvent:(NSString *)event {
    [self.nextResponder routerEvent:event object:nil];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

/** 这个函数是持续向下传递的 直到有对象实现拦截或者nextResponder为nil */
- (void)routerEvent:(NSString *)event object:(nullable id)object {
   
    SEL nextSEL = NSSelectorFromString(event);
    SEL nextSELParameter = NSSelectorFromString([event stringByAppendingString:@":"]);
    
    /** 不带参数的 */
    if ([self.nextResponder respondsToSelector:nextSEL]) {
        [self.nextResponder performSelector:nextSEL];
        return;
    }
    
    /** 带参数的  */
    if ([self.nextResponder respondsToSelector:nextSELParameter]) {
        [self.nextResponder performSelector:nextSELParameter withObject:object];
        return;
    }
    
    /** 没有实现 继续向下传递 */
    [self.nextResponder routerEvent:event object:object];
}
#pragma clang diagnostic pop

@end
