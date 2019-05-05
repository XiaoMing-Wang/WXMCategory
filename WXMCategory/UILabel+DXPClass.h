//
//  UILabel+DXPClass.h
//  DinpayPurse
//
//  Created by Mac on 17/11/14.
//  Copyright © 2017年 zhangshenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DXPClass)

/** 设置最大宽度 调用adjustsFontSizeToFitWidth */
@property (nonatomic, assign) CGFloat maxShowWidth;

/** 行与行间隔 */
@property (nonatomic, assign) CGFloat space;

/** 字间距 */
@property (nonatomic, assign) CGFloat wordSpace;
@end
