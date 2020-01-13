//
//  UILabel+DXPClass.m
//  DinpayPurse
//
//  Created by Mac on 17/11/14.
//  Copyright © 2017年 zhangshenglong. All rights reserved.
//

#import "UILabel+WXMKit.h"
#import <objc/runtime.h>

@implementation UILabel (WXMKit)
@dynamic wc_space;
@dynamic wc_wordSpace;

/** 设置最大宽度  */
- (void)setWc_maxShowWidth:(CGFloat)wc_maxShowWidth {
    if (self.frame.size.width <= wc_maxShowWidth) return;
    CGPoint origin = self.frame.origin;
    CGRect frame = self.frame;
    frame.size.width = wc_maxShowWidth;
    frame.origin = origin;
    self.frame = frame;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    SEL sel = @selector(wc_maxShowWidth);
    objc_setAssociatedObject(self, sel, @(wc_maxShowWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wc_maxShowWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

/** 行与行间隔 */
- (void)setWc_space:(CGFloat)wc_space {
    CGPoint origin = self.frame.origin;
    NSString *text = self.text;
    
    NSMutableAttributedString *atts = nil;
    atts = [[NSMutableAttributedString alloc] initWithString:text ?: @""];
    
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [parag setLineSpacing:wc_space];
    
    NSRange range = NSMakeRange(0, text.length);
    [atts addAttribute:NSParagraphStyleAttributeName value:parag range:range];
    self.attributedText = atts;
    [self sizeToFit];
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/** 字间距 */
- (void)setWc_wordSpace:(CGFloat)wc_wordSpace {
    CGPoint origin = self.frame.origin;
    NSString *text = self.text;
    
    NSDictionary * pa = @{NSKernAttributeName:@(wc_wordSpace)};
    NSMutableAttributedString *att = nil;
    att = [[NSMutableAttributedString alloc] initWithString:text attributes:pa];

    NSRange range = NSMakeRange(0, text.length);
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [att addAttribute:NSParagraphStyleAttributeName value:parag range:range];
    self.attributedText = att;
    [self sizeToFit];

    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

@end
