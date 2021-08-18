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
@dynamic wd_space;
@dynamic wd_wordSpace;

/** 设置最大宽度  */
- (void)setwd_maxShowWidth:(CGFloat)wd_maxShowWidth {
    if (self.frame.size.width <= wd_maxShowWidth) return;
    CGPoint origin = self.frame.origin;
    CGRect frame = self.frame;
    frame.size.width = wd_maxShowWidth;
    frame.origin = origin;
    self.frame = frame;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    SEL sel = @selector(wd_maxShowWidth);
    objc_setAssociatedObject(self, sel, @(wd_maxShowWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wd_maxShowWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

/** 行与行间隔 */
- (void)setwd_space:(CGFloat)wd_space {
    CGPoint origin = self.frame.origin;
    NSString *text = self.text;
    
    NSMutableAttributedString *atts = nil;
    atts = [[NSMutableAttributedString alloc] initWithString:text ?: @""];
    
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [parag setLineSpacing:wd_space];
    
    NSRange range = NSMakeRange(0, text.length);
    [atts addAttribute:NSParagraphStyleAttributeName value:parag range:range];
    self.attributedText = atts;
    [self sizeToFit];
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/** 字间距 */
- (void)setwd_wordSpace:(CGFloat)wd_wordSpace {
    CGPoint origin = self.frame.origin;
    NSString *text = self.text;
    
    NSDictionary * pa = @{NSKernAttributeName:@(wd_wordSpace)};
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
