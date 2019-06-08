//
//  UIView+WXMLieKit.h
//  Multi-project-coordination
//
//  Created by wq on 2019/5/26.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (WXMLieKit) <UIGestureRecognizerDelegate>

/** 当前控制器 */
- (UIViewController *)wxm_responderViewController;

/** 在window中 */
- (CGRect)wxm_locationWithWindow;

/** 截图 */
- (UIImage *)wxm_makeImage;
- (void)wxm_saveImageInlocation:(NSString *)imageName;

/** 手势 */
- (void)wxm_addOnceTappedWithBlock:(void (^)(void))block;
- (void)wxm_addDoubleTappedWithBlock:(void (^)(void))block;

@end
