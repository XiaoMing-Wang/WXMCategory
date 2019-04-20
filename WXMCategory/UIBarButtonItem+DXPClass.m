//
//  UIBarButtonItem+DXPClass.m
//  Bili
//
//  Created by Mac on 16/11/7.
//  Copyright © 2016年 WQ. All rights reserved.
//
#define LargePhone ([UIScreen mainScreen].bounds.size.width > 375) ? YES : NO
#import "UIBarButtonItem+DXPClass.h"
#import <objc/runtime.h>

static char barT;
static char barImage;
static char rightT;
static char barButtonItemImageWithTitleKey;

@implementation UIBarButtonItem (DXPClass)

/** title */
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title
                                  tintColor:(UIColor *)tintColor
                                     action:(void (^)(void))action {
    
    UIFont *font = [UIFont systemFontOfSize:LargePhone ? 17 : 16];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithTitle:title
                                                                    style:UIBarButtonItemStylePlain target:nil
                                                                     action:nil];
    
    [barButtonItem setTitleTextAttributes:@{NSFontAttributeName : font }
                                 forState:UIControlStateNormal];
    
    [barButtonItem setAction:@selector(barButtonClick)];
    objc_setAssociatedObject(barButtonItem, &barT, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    barButtonItem.tintColor = tintColor ?: [UIColor blueColor];
    return barButtonItem;
}
- (void)barButtonClick {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(self, &barT);
    if (block) block();
}

/** 右边UIBarButtonItem */
+ (UIBarButtonItem *)barButtonCustomWithTitle:(NSString *)title
                                    tintColor:(UIColor *)tintColor
                                       action:(void (^)(void))action {
    
    CGRect rect = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT)
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:@{ NSFontAttributeName: [UIFont systemFontOfSize:LargePhone ? 16.5 : 16] }
                                      context:nil];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 20)];
    objc_setAssociatedObject(rightButton, &rightT, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    [rightButton addTarget:barButtonItem action:@selector(rightBarClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:title forState:UIControlStateNormal];
    [rightButton setTitleColor:tintColor ?: [UIColor blueColor] forState:UIControlStateNormal];
    rightButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightButton.titleLabel.font = [UIFont systemFontOfSize:LargePhone ? 16.5 : 16];
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
    return barButtonItem;
}
- (void)rightBarClick:(UIButton *)btn {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(btn, &rightT);
    if (block) block();
}

/** button 图片 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                     highlightedImageName:(NSString *)highlightedImageName
                                   action:(void (^)(void))action {
    
    UIButton *button = [[UIButton alloc] init];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];

    [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    if (highlightedImageName) {
        [button setBackgroundImage:[UIImage imageNamed:highlightedImageName] forState:UIControlStateHighlighted];
    }
    
    CGSize size = button.currentBackgroundImage.size;
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button addTarget:barButtonItem action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    objc_setAssociatedObject(button, &barImage, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    return barButtonItem;
}
- (void)click:(UIButton *)btn {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(btn, &barImage);
    if (block) block();
}


/** button 自定义带图片带文字 */
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   action:(void (^)(void))action {
    
    CGFloat leftImage = (title.length > 0) ? 0 : -7;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImage, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.center = CGPointMake(imageView.center.x, backButton.frame.size.height / 2);
    
    CGFloat left = imageView.frame.origin.x + imageView.frame.size.width + 5;
    CGFloat width = imageView.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 60 - width, 25)];
    titleLabel.center = CGPointMake(titleLabel.center.x, backButton.frame.size.height / 2 + 0.6);
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:LargePhone ? 17 : 16];;
    titleLabel.textColor = [UIColor blueColor];
    
    [backButton addSubview:imageView];
    [backButton addSubview:titleLabel];
    objc_setAssociatedObject(backButton, &barButtonItemImageWithTitleKey, action, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:barButtonItem action:@selector(BarButtonClickImageWithTitle:) forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}
- (void)BarButtonClickImageWithTitle:(UIButton *)btn {
    void (^block)(void) = (void (^)(void))objc_getAssociatedObject(btn, &barButtonItemImageWithTitleKey);
    if (block) block();
}
+ (UIBarButtonItem *)barItemWithImageName:(NSString *)imageName
                                    title:(NSString *)title
                                   target:(id)target
                                   action:(SEL)action {
    CGFloat leftImage = (title.length > 0) ? 0 : -7;
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 44)];
    
    UIImage *image = [UIImage imageNamed:imageName];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImage, 0, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.center = CGPointMake(imageView.center.x, backButton.frame.size.height / 2);
    
    CGFloat left = imageView.frame.origin.x + imageView.frame.size.width + 5;
    CGFloat width = imageView.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(left, 0, 60 - width, 25)];
    titleLabel.center = CGPointMake(titleLabel.center.x, backButton.frame.size.height / 2 + 0.6);
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:LargePhone ? 17 : 16];;
    titleLabel.textColor = [UIColor blueColor];
    
    [backButton addSubview:imageView];
    [backButton addSubview:titleLabel];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return barButtonItem;
}
@end
