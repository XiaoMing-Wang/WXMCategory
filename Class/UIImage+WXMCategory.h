//
//  UIImage+WXMCategory.h
//  Multi-project-coordination
//
//  Created by wq on 2019/6/9.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WXMCategory)

/** 根据颜色绘制图片 */
+ (UIImage *)wd_imageFromColor:(UIColor *)color;

/** 模糊效果 */
- (UIImage *)wd_imageWithBlurNumber:(CGFloat)blur;

/** 修改image的大小 */
- (UIImage *)wd_imageToSize:(CGSize)targetSize;

/** 裁剪图片的一部分 */
- (UIImage *)wd_tailorImageWithRect:(CGRect)rect;

/** 拉伸 */
- (UIImage *)wd_imageWithStretching;

/** 获取启动图 */
+ (UIImage *)wd_getLaunchImage;

/** 按比例重绘图片 最大宽度1280 (1280大约等于iphoneX三倍像素) */
+ (UIImage *)wd_compressionImage1280:(UIImage *)image;
+ (UIImage *)wd_compressionImage:(UIImage *)image maxWH:(CGFloat)maxWH;

/// 画圆角遮罩图片
/// @param radius 半径
/// @param rectSize 大小
/// @param fillColor 圆角被切掉的颜色
+ (UIImage *)wd_drawRoundedCornerImageWithRadius:(CGFloat)radius
                                        rectSize:(CGSize)rectSize
                                       fillColor:(UIColor *)fillColor;
@end
