//
//  UIBarButtonItem+DXPClass.m
//  Bili
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define WXM_LP ([UIScreen mainScreen].bounds.size.width > 375) ? YES : NO
#define WXM_FontSize WXM_LP ? 17 : 16
#define WXM_TinColor [UIColor blackColor]
#import <objc/runtime.h>
#import "UIBarButtonItem+WXMKit.h"

@implementation UIBarButtonItem (WXMKit)

/** title 有键盘出现系统的会失去响应  */
+ (UIBarButtonItem *)wc_titleItem:(NSString *)title tintColor:(UIColor *)tintColor action:(void (^)(void))action {
    UIFont *font = [UIFont systemFontOfSize:WXM_FontSize];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:nil action:nil];
    NSDictionary *attributes = @{NSFontAttributeName : font};
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [item setAction:@selector(eventTouchUpInside)];
    objc_setAssociatedObject(item, @selector(eventTouchUpInside), action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    item.tintColor = tintColor ?: WXM_TinColor;
    return item;
}

- (void)eventTouchUpInside {
    void (^block)(void) = (void (^)(void)) objc_getAssociatedObject(self, _cmd);
    if (block) block();
}

/** title自定义文字(右边)  */
+ (UIBarButtonItem *)wc_titleCustomItem:(NSString *)title tintColor:(UIColor *)tintColor action:(void (^)(void))action {
    UIFont *font = [UIFont systemFontOfSize:WXM_FontSize];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{ NSFontAttributeName: font }
                                      context:nil];

    UIButton *wrapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 20)];
    [wrapButton setTitle:title forState:UIControlStateNormal];
    [wrapButton setTitleColor:tintColor ?: WXM_TinColor forState:UIControlStateNormal];
    wrapButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    wrapButton.titleLabel.font = font;
    wrapButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    [wrapButton addTarget:item action:@selector(wrapEvent:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(wrapButton, @selector(wrapEvent:), action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return item;
}

- (void)wrapEvent:(UIButton *)wrapButton {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(wrapButton, _cmd);
    if (block) block();
}

/** title自定义图片(左右)  */
+ (UIBarButtonItem *)wc_imageItem:(NSString *)imageName action:(void (^)(void))action {
    UIButton *wrapButton = [[UIButton alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    CGSize size = wrapButton.currentBackgroundImage.size;
    wrapButton.frame = CGRectMake(0, 0, size.width, size.height);
    [wrapButton addTarget:item action:@selector(imageEvent:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(wrapButton, @selector(imageEvent:), action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return item;
}

/** title自定义图片(左右)  */
+ (UIBarButtonItem *)wc_imageItem:(NSString *)imageName target:(id)target action:(SEL)action {
    UIButton *wrapButton = [[UIButton alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    CGSize size = wrapButton.currentBackgroundImage.size;
    wrapButton.frame = CGRectMake(0, 0, size.width, size.height);
    [wrapButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)imageEvent:(UIButton *)wrapButton {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(wrapButton, _cmd);
    if (block) block();
}

/** 自定义带图片带文字(左)  */
+ (UIBarButtonItem *)wc_imageWithTitleItem:(NSString *)imageName title:(NSString *)title action:(void (^)(void))action {
    SEL sel = @selector(image_titleEvent:);
    UIImage *iconImage = [UIImage imageNamed:imageName];
    UIButton *wrapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    CGFloat leftImage = (title.length > 0) ? 0 : 0;
    CGRect rect = CGRectMake(leftImage, 0, iconImage.size.width, iconImage.size.height);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:rect];
    icon.image = iconImage;
    icon.center = CGPointMake(icon.center.x, wrapButton.frame.size.height / 2);
    [wrapButton addSubview:icon];
    
    CGFloat left = icon.frame.origin.x + icon.frame.size.width + 1.0;
    CGFloat width = icon.frame.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 60 - width, 25)];
    titleLabel.center = CGPointMake(titleLabel.center.x, wrapButton.frame.size.height / 2 + 0.6);
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:WXM_FontSize];
    titleLabel.textColor = WXM_TinColor;
    [wrapButton addSubview:titleLabel];
    
    objc_setAssociatedObject(wrapButton, sel, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [wrapButton addTarget:item action:sel forControlEvents:UIControlEventTouchUpInside];
    return item;
}

/** 自定义带图片带文字(左)  */
+ (UIBarButtonItem *)wc_imageWithTitleItem:(NSString *)imageName title:(NSString *)title target:(id)target action:(SEL)action {
    UIImage *iconImage = [UIImage imageNamed:imageName];
    UIButton *wrapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    CGFloat leftImage = (title.length > 0) ? 0 : -3.5;
    CGRect rect = CGRectMake(leftImage, 0, 17.5, 17.5);
    
    UIImageView *icon = [[UIImageView alloc] initWithFrame:rect];
    icon.image = iconImage;
    icon.center = CGPointMake(icon.center.x, wrapButton.frame.size.height / 2);
    [wrapButton addSubview:icon];
    
    CGFloat left = icon.frame.origin.x + icon.frame.size.width + 5;
    CGFloat width = icon.frame.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 60 - width, 25)];
    titleLabel.center = CGPointMake(titleLabel.center.x, wrapButton.frame.size.height / 2 + 0.6);
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:WXM_FontSize];
    titleLabel.textColor = WXM_TinColor;
    
    [wrapButton addSubview:titleLabel];
    [wrapButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)image_titleEvent:(UIButton *)wrapButton {
    void (^block) (void) = (void (^)(void))objc_getAssociatedObject(wrapButton, _cmd);
    if (block) block();
}
@end
