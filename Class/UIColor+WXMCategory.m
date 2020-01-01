//
//  UIColor+WXMCategory.m
//  ModuleDebugging
//
//  Created by edz on 2019/6/21.
//  Copyright © 2019 wq. All rights reserved.
//

#import "UIColor+WXMCategory.h"

@implementation UIColor (WXMCategory)

/**
 *  @brief  渐变颜色
 *
 *  @param c1     开始颜色
 *  @param c2     结束颜色
 *  @param height 渐变高度
 *
 *  @return 渐变颜色
 */
+ (UIColor *)wc_gradientFromColor:(UIColor *)c1
                          toColor:(UIColor *)c2
                       withHeight:(int)height {
    
    CGSize size = CGSizeMake(1, height);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGColorSpaceRef space = CGColorSpaceCreateDeviceRGB();

    NSArray *colors = [NSArray arrayWithObjects:(id) c1.CGColor, (id) c2.CGColor, nil];
    CGGradientRef gradient = CGGradientCreateWithColors(space, (__bridge CFArrayRef) colors, NULL);
    CGContextDrawLinearGradient(context, gradient,
                                CGPointMake(0, 0),
                                CGPointMake(0, size.height),
                                kCGGradientDrawsBeforeStartLocation);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGColorSpaceRelease(space);
    UIGraphicsEndImageContext();
    return [UIColor colorWithPatternImage:image];
}

+ (UIColor *)wc_randomColor {
    CGFloat red = (CGFloat) random() / (CGFloat) RAND_MAX;
    CGFloat blue = (CGFloat) random() / (CGFloat) RAND_MAX;
    CGFloat green = (CGFloat) random() / (CGFloat) RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}
@end
