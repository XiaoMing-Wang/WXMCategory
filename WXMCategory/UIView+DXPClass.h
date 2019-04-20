//
//  UIView+DXPClass.h
//  runTime
//
//  Created by wq on 16/8/10.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIView (DXPClass)
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize  size;
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

+ (instancetype)Nib;
+ (instancetype)NibWithName:(NSString *)nibName idex:(NSInteger)idex;

@end

NS_ASSUME_NONNULL_END
