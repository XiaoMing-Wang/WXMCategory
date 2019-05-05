//
//  UILabel+DXPClass.m
//  DinpayPurse
//
//  Created by Mac on 17/11/14.
//  Copyright © 2017年 zhangshenglong. All rights reserved.
//

#import "UILabel+DXPClass.h"
#import <objc/runtime.h>

@implementation UILabel (DXPClass)
@dynamic space;
@dynamic wordSpace;

- (void)setMaxShowWidth:(CGFloat)maxShowWidth {
    if (self.frame.size.width <= maxShowWidth) return;
    CGPoint origin = self.frame.origin;
    CGRect frame = self.frame;
    frame.size.width = maxShowWidth;
    frame.origin = origin;
    self.frame = frame;
    self.lineBreakMode = NSLineBreakByTruncatingTail;
    objc_setAssociatedObject(self, @selector(maxShowWidth), @(maxShowWidth), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGFloat)maxShowWidth {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setSpace:(CGFloat)space {
    NSString *labelText = self.text;
    NSMutableAttributedString *atts = [[NSMutableAttributedString alloc] initWithString:labelText ?: @""];
    NSMutableParagraphStyle *parag = [[NSMutableParagraphStyle alloc] init];
    [parag setLineSpacing:space];
    [atts addAttribute:NSParagraphStyleAttributeName value:parag range:NSMakeRange(0, labelText.length)];
    self.attributedText = atts;
    [self sizeToFit];
}

- (void)setWordSpace:(CGFloat)wordSpace {
    CGPoint origin = self.frame.origin;
    NSString *text = self.text;
    
    NSDictionary * pa = @{NSKernAttributeName:@(wordSpace)};
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
