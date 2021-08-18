//
//  UIScrollView+DXPClass.h
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (WXMKit)

@property (nonatomic, assign) CGFloat contentOffsetX;
@property (nonatomic, assign) CGFloat contentOffsetY;
@property (nonatomic, assign) CGFloat contentSizeWidth;
@property (nonatomic, assign) CGFloat contentSizeHeight;
@property (nonatomic, assign) CGFloat contentInsetTop;
@property (nonatomic, assign) CGFloat contentInsetLeft;
@property (nonatomic, assign) CGFloat contentInsetBottom;
@property (nonatomic, assign) CGFloat contentInsetRight;

/** 滚到到顶部 */
- (void)wd_crollsToTopWithAnimation:(BOOL)animation;

/** 尾部 */
- (void)wd_crollsToBottomWithAnimation:(BOOL)animation;

/** 滚动优先级低于返回 */
- (void)wd_rollingPriorityLow:(UIViewController *)controller;
- (void)wd_rollingPriorityHight:(UIViewController *)controller;

@end
