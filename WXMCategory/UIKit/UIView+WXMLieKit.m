//
//  UIView+WXMLieKit.m
//  Multi-project-coordination
//
//  Created by wq on 2019/5/26.
//  Copyright © 2019年 wxm. All rights reserved.
//
#import <objc/runtime.h>
#import "UIView+WXMLieKit.h"

static char onceTap;
static char doubleTap;
@implementation UIView (WXMLieKit)

/** 当前控制器 */
- (UIViewController *)wxm_responderViewController {
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;
        }
        next = next.nextResponder;
    } while (next);
    return nil;
}

/** 手势 */
- (void)wxm_addOnceTappedWithBlock:(void (^)(void))block {
    [self addTapGesture:1 touches:1 selector:@selector(viewTapped:)];
    objc_setAssociatedObject(self, &onceTap, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)wxm_addDoubleTappedWithBlock:(void (^)(void))block {
    [self addTapGesture:2 touches:1 selector:@selector(viewTapped:)];
    objc_setAssociatedObject(self, &doubleTap, block, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)viewTapped:(UITapGestureRecognizer *)tap {
    void (^touch)(void) = nil;
    if (tap.numberOfTapsRequired == 1) touch = objc_getAssociatedObject(self, &onceTap);
    if (tap.numberOfTapsRequired == 2) touch = objc_getAssociatedObject(self, &doubleTap);
    if (touch) touch();
}

/** 实例化手势 */
- (UITapGestureRecognizer *)addTapGesture:(NSUInteger)taps touches:(NSUInteger)touches selector:(SEL)selector {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:selector];
    tapGes.delegate = self;
    tapGes.numberOfTapsRequired = taps;
    tapGes.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGes];
    return tapGes;
}

/** 在window中 */
- (CGRect)wxm_locationWithWindow {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return [self convertRect:self.bounds toView:window];
}

/** 截图 */
- (UIImage *)wxm_makeImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 画图存到本地 */
- (void)wxm_saveImageInlocation:(NSString *)imageName {
    UIImage *image = [self wxm_makeImage];
    NSString *document = NSHomeDirectory();
    NSString *path = [NSString stringWithFormat:@"/Documents/%@.png",imageName];
    NSString *imagePath = [document stringByAppendingString:path];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    NSLog(@"%@",imagePath);
}

/** 上下居中对齐 */
- (void)wxm_venicalSet:(UIView *)above nether:(UIView *)nether interval:(CGFloat)interval {
    if (!above || !nether || self.frame.size.height == 0) return;
    CGFloat totalHeight = self.frame.size.height;
    CGFloat totalInterval = totalHeight - above.frame.size.height - nether.frame.size.height;
    CGFloat topAbove = (totalInterval - interval) / 2.0;
    CGRect rectAbove = above.frame;
    rectAbove.origin.y = topAbove;
    above.frame = rectAbove;
    
    CGRect rectNether = nether.frame;
    rectNether.origin.y = totalHeight - topAbove - nether.frame.size.height;
    nether.frame = rectNether;
}

/** 左右居中对齐 */
- (void)wxm_horizontalSet:(UIView *)left nether:(UIView *)right interval:(CGFloat)interval {
    if (!left || !right || self.frame.size.width == 0) return;
    CGFloat totalWidth = self.frame.size.width;
    CGFloat totalInterval = totalWidth - left.frame.size.width - right.frame.size.width;
    CGFloat topAbove = (totalInterval - interval) / 2.0;
    CGRect rectAbove = left.frame;
    rectAbove.origin.x = topAbove;
    left.frame = rectAbove;
    
    CGRect rectNether = right.frame;
    rectNether.origin.x = totalWidth - topAbove - right.frame.size.width;
    right.frame = rectNether;
}


@end
