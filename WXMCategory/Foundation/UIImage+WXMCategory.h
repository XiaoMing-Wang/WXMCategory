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
+ (UIImage *)wxm_imageFromColor:(UIColor *)color;

/** 模糊效果 */
- (UIImage *)wxm_imageWithBlurNumber:(CGFloat)blur;

/** 修改image的大小 */
- (UIImage *)wxm_imageToSize:(CGSize)targetSize;

/** 裁剪图片的一部分 */
- (UIImage *)wxm_tailorImageWithRect:(CGRect)rect;

/** 拉伸 */
- (UIImage *)wxm_imageWithStretching;

/** 获取启动图 */
+ (UIImage *)wxm_getLaunchImage;
@end
