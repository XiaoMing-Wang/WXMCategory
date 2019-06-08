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

/**  */
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
    return [self convertRect:self.bounds toView:[[[UIApplication sharedApplication] delegate] window]];
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
@end
