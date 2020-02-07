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

- (void)routerEvent:(NSString *)event object:(nullable id)object {
    [self.nextResponder routerEvent:event object:object];
}

@end
