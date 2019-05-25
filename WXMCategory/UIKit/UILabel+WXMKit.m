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
@dynamic wxm_space;
@dynamic wxm_wordSpace;

/** 设置最大宽度  */
- (void)setWxm_maxShowWidth:(CGFloat)wxm_maxShowWidth {
    if (self.frame.size.width <= wxm_maxShowWidth) return;
    CGPoint origin = self.frame.origin;
    CGRect frame = self.frame;
    frame.size.width = wxm_maxShowWidth;
    frame.origin = origin;
    self.frame = frame;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    
    SEL sel = @selector(wxm_maxShowWidth);
    objc_setAssociatedObject(self, sel, @(wxm_maxShowWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)wxm_maxShowWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

/** 行与行间隔 */
- (void)setWxm_space:(CGFloat)wxm_space {
    CGPoint origin = self.frame.origin;
    NSString *labelText = self.text;
    
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:labelText ?: @""];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [parag setLineSpacing:wxm_space];
    [atts addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, labelText.length)];
    self.attributedText = atts;
    [self sizeToFit];
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

/** 字间距 */
- (void)setWxm_wordSpace:(CGFloat)wxm_wordSpace {
    CGPoint origin = self.frame.origin;
    NSString *text = self.text;
    
    NSDictionary * pa = @{NSKernAttributeName:@(wxm_wordSpace)};
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc] initWithString:text attributes:pa];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [att addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, text.length)];
    self.attributedText = att;
    [self sizeToFit];
    
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
@end
