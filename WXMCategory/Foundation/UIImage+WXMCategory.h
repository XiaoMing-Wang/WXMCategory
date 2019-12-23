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
+ (UIImage *)wc_imageFromColor:(UIColor *)color;

/** 模糊效果 */
- (UIImage *)wc_imageWithBlurNumber:(CGFloat)blur;

/** 修改image的大小 */
- (UIImage *)wc_imageToSize:(CGSize)targetSize;

/** 裁剪图片的一部分 */
- (UIImage *)wc_tailorImageWithRect:(CGRect)rect;

/** 拉伸 */
- (UIImage *)wc_imageWithStretching;

/** 获取启动图 */
+ (UIImage *)wc_getLaunchImage;

/** 按比例重绘图片 */
+ (UIImage *)wc_compressionImageWithOriginalImage:(UIImage *)image;

/**
 画圆角遮罩图片
 @param radius    半径
 @param rectSize  大小
 @param fillColor 圆角被切掉的颜色
 @return 切好的图片
 */
+ (UIImage *)wc_drawRoundedCornerImageWithRadius:(CGFloat)radius
                                        rectSize:(CGSize)rectSize
                                       fillColor:(UIColor *)fillColor;
@end
