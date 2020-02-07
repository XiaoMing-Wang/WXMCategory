//
//  UIResponder+WXMCategory.h
//  Multi-project-coordination
//
//  Created by wq on 2020/1/16.
//  Copyright © 2020 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIResponder (WXMCategory)

/** 响应链传递给父类 */
- (void)routerEvent:(NSString *)event;

/** 响应链传递给父类 */
- (void)routerEvent:(NSString *)event object:(nullable id)object;

@end

NS_ASSUME_NONNULL_END
