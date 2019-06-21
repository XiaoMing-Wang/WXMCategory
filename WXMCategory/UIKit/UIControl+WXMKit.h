//
//  UIControl+WXMKit.h
//  Multi-project-coordination
//
//  Created by wq on 2019/6/10.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIControl (WXMKit)

/** 响应间隔 */
@property (nonatomic, assign) CGFloat respondInterval;

/** 点击 block */
- (void)wxm_blockWithControlEventTouchUpInsideSup:(void (^)(void))block;

@end
