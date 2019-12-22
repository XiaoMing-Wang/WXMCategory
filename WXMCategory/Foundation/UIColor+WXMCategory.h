//
//  UIColor+WXMCategory.h
//  ModuleDebugging
//
//  Created by edz on 2019/6/21.
//  Copyright © 2019 wq. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
/** RR wxm_=wc_ */
@interface UIColor (WXMCategory)

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
                       withHeight:(int)height;



/** 随机色 */
+ (UIColor *)wc_randomColor;

@end

NS_ASSUME_NONNULL_END