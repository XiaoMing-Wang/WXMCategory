//
//  UIScrollView+DXPClass.m
//  MyLoveApp
//
//  Created by wq on 2019/4/9.
//  Copyright © 2019年 wq. All rights reserved.
//

#import "UIScrollView+WXMKit.h"

@implementation UIScrollView (WXMKit)

- (void)setContentOffsetX:(CGFloat)contentOffsetX {
    self.contentOffset = CGPointMake(contentOffsetX, self.contentOffset.y);
}

- (CGFloat)contentOffsetX {
    return self.contentOffset.x;
}

- (void)setContentOffsetY:(CGFloat)contentOffsetY {
    self.contentOffset = CGPointMake(self.contentOffset.x, contentOffsetY);
}

- (CGFloat)contentOffsetY {
    return self.contentOffset.y;
}

- (void)setContentSizeWidth:(CGFloat)contentSizeWidth {
    self.contentSize = CGSizeMake(contentSizeWidth, self.contentSize.height);
}

- (CGFloat)contentSizeWidth {
    return self.contentSize.width;
}

- (void)setContentSizeHeight:(CGFloat)contentSizeHeight {
    self.contentSize = CGSizeMake(self.contentSize.width, contentSizeHeight);
}

- (CGFloat)contentSizeHeight {
    return self.contentSize.height;
}

- (void)setContentInsetTop:(CGFloat)contentInsetTop {
    [self setContentInset:UIEdgeInsetsMake(contentInsetTop,
                                           self.contentInset.left,
                                           self.contentInset.bottom,
                                           self.contentInset.right)];
}
- (void)setContentInsetLeft:(CGFloat)contentInsetLeft {
    [self setContentInset:UIEdgeInsetsMake(self.contentInset.top,
                                           contentInsetLeft,
                                           self.contentInset.bottom,
                                           self.contentInset.right)];
}

- (void)setContentInsetBottom:(CGFloat)contentInsetBottom {
    [self setContentInset:UIEdgeInsetsMake(self.contentInset.top,
                                           self.contentInset.left,
                                           contentInsetBottom,
                                           self.contentInset.right)];
}

- (void)setContentInsetRight:(CGFloat)contentInsetRight {
    [self setContentInset:UIEdgeInsetsMake(self.contentInset.top,
                                           self.contentInset.left,
                                           self.contentInset.bottom,
                                           contentInsetRight)];
}

- (CGFloat)contentInsetTop {
    return self.contentInset.top;
}

- (CGFloat)contentInsetLeft {
    return self.contentInset.left;
}

- (CGFloat)contentInsetBottom {
    return self.contentInset.bottom;
}

- (CGFloat)contentInsetRight {
    return self.contentInset.right;
}

/** 滚到到顶部 */
- (void)wc_crollsToTopWithAnimation:(BOOL)animation {
    [self setContentOffset:CGPointZero animated:animation];
}

/** 尾部 */
- (void)wc_crollsToBottomWithAnimation:(BOOL)animation {
    if (self.contentSize.height > self.frame.size.height) {
        CGPoint offset = CGPointMake(0, self.contentSize.height - self.frame.size.height);
        [self setContentOffset:offset animated:animation];
    }
}

/** 滚动优先级低于返回 */
- (void)wc_rollingPriorityLow:(UIViewController *)controller {
    @try {
        
        if (!self.panGestureRecognizer || !self.scrollEnabled) return;
        UIGestureRecognizer *gesturecognizer = controller.navigationController.interactivePopGestureRecognizer;
        UIPanGestureRecognizer *panGestureRecognizer = self.panGestureRecognizer;
        if (!gesturecognizer || !panGestureRecognizer) return;
        if ([panGestureRecognizer respondsToSelector:@selector(requireGestureRecognizerToFail:)]) {
            [panGestureRecognizer requireGestureRecognizerToFail:gesturecognizer];
        }
        
    } @catch (NSException *exception) {} @finally {}
}

/** 滚动优先级低于返回 */
- (void)wc_rollingPriorityHight:(UIViewController *)controller {
    @try {
        
        if (!self.panGestureRecognizer || !self.scrollEnabled) return;
        UIGestureRecognizer *gesturecognizer = controller.navigationController.interactivePopGestureRecognizer;
        UIPanGestureRecognizer *panGestureRecognizer = self.panGestureRecognizer;
        if (!gesturecognizer || !panGestureRecognizer) return;
        if ([gesturecognizer respondsToSelector:@selector(requireGestureRecognizerToFail:)]) {
            [gesturecognizer requireGestureRecognizerToFail:panGestureRecognizer];
        }
        
    } @catch (NSException *exception) {} @finally {}
}

@end
