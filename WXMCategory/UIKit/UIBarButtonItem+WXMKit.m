//
//  UIBarButtonItem+DXPClass.m
//  Bili
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define WXM_LP ([UIScreen mainScreen].bounds.size.width > 375) ? YES : NO
#define WXM_FontSize WXM_LP ? 17 : 16
#define WXM_TinColor [UIColor blueColor]

#import "UIBarButtonItem+WXMKit.h"
#import <objc/runtime.h>

static char touch;
static char rightTouch;
static char kimage;
static char kimage_title;

@implementation UIBarButtonItem (WXMKit)

/** title */
+ (UIBarButtonItem *)wc_titleItem:(NSString *)title
                        tintColor:(UIColor *)tintColor
                           action:(void (^)(void))action {
    
    UIFont *font = [UIFont systemFontOfSize:WXM_FontSize];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title
                                                             style:UIBarButtonItemStylePlain
                                                            target:nil
                                                            action:nil];
    
    NSDictionary *attributes = @{NSFontAttributeName : font };
    [item setTitleTextAttributes:attributes forState:UIControlStateNormal];
    [item setAction:@selector(eventTouchUpInside)];
    objc_setAssociatedObject(item, &touch, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    item.tintColor = tintColor ?: WXM_TinColor;
    return item;
}

- (void)eventTouchUpInside {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(self, &touch);
    if (block) block();
}

/** title */
+ (UIBarButtonItem *)wc_titleCustomItem:(NSString *)title
                              tintColor:(UIColor *)tintColor
                                 action:(void (^)(void))action {
    
    UIFont *font = [UIFont systemFontOfSize:WXM_FontSize];
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{ NSFontAttributeName: font }
                                      context:nil];
    
    UIButton *wrapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,rect.size.width,20)];
    [wrapButton setTitle:title forState:UIControlStateNormal];
    [wrapButton setTitleColor:tintColor ?: WXM_TinColor forState:UIControlStateNormal];
    wrapButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    wrapButton.titleLabel.font = font;
    wrapButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    objc_setAssociatedObject(wrapButton, &rightTouch, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    [wrapButton addTarget:item action:@selector(wrapEvent:) forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)wrapEvent:(UIButton *)wrapButton {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(wrapButton, &rightTouch);
    if (block) block();
}

/** button 图片 */
+ (UIBarButtonItem *)wc_imageItem:(NSString *)imageName action:(void (^)(void))action {
    
    UIButton *wrapButton = [[UIButton alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    CGSize size = wrapButton.currentBackgroundImage.size;
    wrapButton.frame = CGRectMake(0, 0, size.width, size.height);
    [wrapButton addTarget:item action:@selector(kimageEvent:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(wrapButton, &kimage, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return item;
}

+ (UIBarButtonItem *)wc_imageItem:(NSString *)imageName
                           target:(id)target
                           action:(SEL)action {
    
    UIButton *wrapButton = [[UIButton alloc] init];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [wrapButton setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateHighlighted];
    CGSize size = wrapButton.currentBackgroundImage.size;
    wrapButton.frame = CGRectMake(0, 0, size.width, size.height);
    [wrapButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return item;
}

- (void)kimageEvent:(UIButton *)wrapButton {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(wrapButton, &kimage);
    if (block) block();
}

/** wrapButton 自定义带图片带文字 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   action:(void (^)(void))action {
    
    SEL sel = @selector(kimage_titleEvent:);
    UIImage *iconImage = [UIImage imageNamed:imageName];
    UIButton *wrapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    CGFloat leftImage = (title.length > 0) ? 0 : -7;
    CGRect rect = CGRectMake(leftImage, 0, iconImage.size.width, iconImage.size.height);
    
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
    
    objc_setAssociatedObject(wrapButton, &kimage_title, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [wrapButton addTarget:item action:sel forControlEvents:UIControlEventTouchUpInside];
    return item;
}

+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                   action:(SEL)action {
    
    UIImage *iconImage = [UIImage imageNamed:imageName];
    UIButton *wrapButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:wrapButton];
    CGFloat leftImage = (title.length > 0) ? 0 : -7;
    CGRect rect = CGRectMake(leftImage, 0, iconImage.size.width, iconImage.size.height);
    
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

- (void)kimage_titleEvent:(UIButton *)wrapButton {
    void (^block) (void) = (void (^)(void))objc_getAssociatedObject(wrapButton, &kimage_title);
    if (block) block();
}
@end
