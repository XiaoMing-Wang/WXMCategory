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
- (UIViewController *)wd_responderViewController {
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
- (void)wd_tappedWithTarget:(id)target action:(SEL)action {
    UITapGestureRecognizer *tapGes = nil;
    tapGes = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGes.numberOfTapsRequired = 1;
    tapGes.numberOfTouchesRequired = 1;
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:tapGes];
}

- (UITapGestureRecognizer *)wd_addOnceTappedWithCallback:(void (^)(void))callback {
    UITapGestureRecognizer *tap = [self addTapGesture:1 touches:1 selector:@selector(viewTapped:)];
    objc_setAssociatedObject(self, &onceTap, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tap;
}

- (UITapGestureRecognizer *)wd_addDoubleTappedWithCallback:(void (^)(void))callback {
    UITapGestureRecognizer *tap = [self addTapGesture:2 touches:1 selector:@selector(viewTapped:)];
    objc_setAssociatedObject(self, &doubleTap, callback, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return tap;
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
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self  action:selector];
    tapGes.delegate = self;
    tapGes.numberOfTapsRequired = taps;
    tapGes.numberOfTouchesRequired = touches;
    [self addGestureRecognizer:tapGes];
    return tapGes;
}

/** 在window位置 */
- (CGRect)wd_locationWithWindow {
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    return [self convertRect:self.bounds toView:window];
}

/** 截图 */
- (UIImage *)wd_makeImage {
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 画图存到本地 */
- (void)wd_saveImageInlocation:(NSString *)imageName {
    UIImage *image = [self wd_makeImage];
    NSString *document = NSHomeDirectory();
    NSString *path = [NSString stringWithFormat:@"/Documents/%@.png",imageName];
    NSString *imagePath = [document stringByAppendingString:path];
    [UIImagePNGRepresentation(image) writeToFile:imagePath atomically:YES];
    NSLog(@"%@",imagePath);
}

/** 上下居中对齐 */
- (void)wd_venicalSet:(UIView *)above nether:(UIView *)nether interval:(CGFloat)interval {
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
- (void)wd_horizontalSet:(UIView *)left nether:(UIView *)right interval:(CGFloat)interval {
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

/** 获取nib文件 */
+ (instancetype)wd_xibFileWithName:(NSString *)nibName currentIdex:(NSInteger)currentIdex {
    return [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][currentIdex];
}

/// UIView任意边角画圆角
/// @param rectCorner 圆角边
/// @param cornerRadius  圆角大小
- (void)wd_drawSemicircle:(UIRectCorner)rectCorner cornerRadius:(CGFloat)cornerRadius {
    
    CGSize size = CGSizeMake(cornerRadius,cornerRadius);
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:(rectCorner)
                                                         cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

/** 渐现动画 */
- (void)wd_fadeAnimation {
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade;
    transition.subtype = kCATransitionFromRight;
    [self.layer addAnimation:transition forKey:@"animation"];
}

@end
