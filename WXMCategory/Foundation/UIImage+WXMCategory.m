//
//  UIImage+WXMCategory.m
//  Multi-project-coordination
//
//  Created by wq on 2019/6/9.
//  Copyright © 2019年 wxm. All rights reserved.
//

#import "UIImage+WXMCategory.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage (WXMCategory)

/** 根据颜色绘制图片 */
+ (UIImage *)wc_imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 模糊效果 */
- (UIImage *)wc_imageWithBlurNumber:(CGFloat)blur {
    return [self wc_applyBlurWithRadius:blur
                              tintColor:[UIColor colorWithWhite:0 alpha:0.0]
                  saturationDeltaFactor:1.4
                              maskImage:nil];
}

/** 修改image的大小 */
- (UIImage *)wc_imageToSize:(CGSize)targetSize {
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor < heightFactor)
            scaleFactor = widthFactor;
        else
            scaleFactor = heightFactor;
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        // center the image
        if (widthFactor < heightFactor) {
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        } else if (widthFactor > heightFactor) {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    // this is actually the interesting part:
    UIGraphicsBeginImageContext(targetSize);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [sourceImage drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage*)wc_scaleToSize:(CGSize)size {
    if ([[UIScreen mainScreen] scale] == 0.0) {
        UIGraphicsBeginImageContext(size);
    } else {
        UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    }
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

/** 裁剪图片的一部分 */
- (UIImage *)wc_tailorImageWithRect:(CGRect)rect {
    CGImageRef sourceImageRef = [self CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    return newImage;
}

/** 拉伸 */
- (UIImage *)wc_imageWithStretching {
    return [self resizableImageWithCapInsets:UIEdgeInsetsZero
                                resizingMode:UIImageResizingModeStretch];
}

/** 获取启动图 */
+ (UIImage *)wc_getLaunchImage {
    NSString *viewOrientation = @"Portrait";
    NSString *launchImageName = nil;
    NSArray *imagesDict = [[[NSBundle mainBundle] infoDictionary] valueForKey:@"UILaunchImages"];
    for (NSDictionary *dict in imagesDict) {
        CGSize imageSize = CGSizeFromString(dict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, [UIScreen mainScreen].bounds.size) &&
            [viewOrientation isEqualToString:dict[@"UILaunchImageOrientation"]]) {
            launchImageName = dict[@"UILaunchImageName"];
        }
    }
    return [UIImage imageNamed:launchImageName];
}

/** 模糊图片 */
- (UIImage *)wc_applyBlurWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(UIImage *)maskImage {
    
    if (self.size.width < 1 || self.size.height < 1) return nil;
    if (!self.CGImage) return nil;
    if (maskImage && !maskImage.CGImage) return nil;
    
    CGRect imageRect = { CGPointZero, self.size };
    UIImage *effectImage = self;
    
    BOOL hasBlur = blurRadius > __FLT_EPSILON__;
    
    BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
    if (hasBlur || hasSaturationChange) {
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectInContext = UIGraphicsGetCurrentContext();
        CGContextScaleCTM(effectInContext, 1.0, -1.0);
        CGContextTranslateCTM(effectInContext, 0, -self.size.height);
        CGContextDrawImage(effectInContext, imageRect, self.CGImage);
        
        vImage_Buffer effectInBuffer;
        effectInBuffer.data = CGBitmapContextGetData(effectInContext);
        effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
        effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
        effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);
        
        UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
        CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
        vImage_Buffer effectOutBuffer;
        effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
        effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
        effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
        effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);
        
        if (hasBlur) {
            
            CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
            NSUInteger radius = floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
            if (radius % 2 != 1) {
                radius += 1; // force radius to be odd so that the three box-blur methodology works.
            }
            
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t) radius, (uint32_t) radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, (uint32_t) radius, (uint32_t) radius, 0, kvImageEdgeExtend);
            vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, (uint32_t) radius, (uint32_t) radius, 0, kvImageEdgeExtend);
        }
        
        BOOL effectImageBuffersAreSwapped = NO;
        if (hasSaturationChange) {
            
            CGFloat s = saturationDeltaFactor;
            CGFloat floatingPointSaturationMatrix[] = {
                0.0722 + 0.9278 * s,
                0.0722 - 0.0722 * s,
                0.0722 - 0.0722 * s,
                0,
                0.7152 - 0.7152 * s,
                0.7152 + 0.2848 * s,
                0.7152 - 0.7152 * s,
                0,
                0.2126 - 0.2126 * s,
                0.2126 - 0.2126 * s,
                0.2126 + 0.7873 * s,
                0,
                0,
                0,
                0,
                1,
            };
            const int32_t divisor = 256;
            NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix) / sizeof(floatingPointSaturationMatrix[0]);
            int16_t saturationMatrix[matrixSize];
            
            for (NSUInteger i = 0; i < matrixSize; ++i) {
                
                saturationMatrix[i] = (int16_t) roundf(floatingPointSaturationMatrix[i] * divisor);
            }
            
            if (hasBlur) {
                vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
                effectImageBuffersAreSwapped = YES;
            } else {
                vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            }
        }
        
        if (!effectImageBuffersAreSwapped) {
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        
        UIGraphicsEndImageContext();
        
        if (effectImageBuffersAreSwapped) {
            effectImage = UIGraphicsGetImageFromCurrentImageContext();
        }
        UIGraphicsEndImageContext();
    }
    
    // Set up output context.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef outputContext = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(outputContext, 1.0, -1.0);
    CGContextTranslateCTM(outputContext, 0, -self.size.height);
    
    // Draw base image.
    CGContextDrawImage(outputContext, imageRect, self.CGImage);
    
    // Draw effect image.
    if (hasBlur) {
        CGContextSaveGState(outputContext);
        if (maskImage) {
            CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
        }
        CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
        CGContextRestoreGState(outputContext);
    }
    
    // Add in color tint.
    if (tintColor) {
        CGContextSaveGState(outputContext);
        CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
        CGContextFillRect(outputContext, imageRect);
        CGContextRestoreGState(outputContext);
    }
    // Output image is ready.
    UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return outputImage;
}

/**
画圆角遮罩图片
@param radius    半径
@param rectSize  大小
@param fillColor 圆角被切掉的颜色
@return 切好的图片
*/
+ (UIImage *)wc_drawRoundedCornerImageWithRadius:(CGFloat)radius
                                        rectSize:(CGSize)rectSize
                                       fillColor:(UIColor *)fillColor {
    
    UIGraphicsBeginImageContextWithOptions(rectSize, false, [[UIScreen mainScreen] scale]);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];

    CGPoint hLeftUpPoint = CGPointMake(radius, 0);
    CGPoint hRightUpPoint = CGPointMake(rectSize.width - radius, 0);
    CGPoint hLeftDownPoint = CGPointMake(radius, rectSize.height);
    
    CGPoint vLeftUpPoint = CGPointMake(0, radius);
    CGPoint vRightDownPoint = CGPointMake(rectSize.width, rectSize.height - radius);
    
    CGPoint centerLeftUp = CGPointMake(radius, radius);
    CGPoint centerRightUp = CGPointMake(rectSize.width - radius, radius);
    CGPoint centerLeftDown = CGPointMake(radius, rectSize.height - radius);
    CGPoint centerRightDown = CGPointMake(rectSize.width - radius, rectSize.height - radius);
    
    [bezierPath moveToPoint:hLeftUpPoint];
    [bezierPath addLineToPoint:hRightUpPoint];
    
    [bezierPath addArcWithCenter:centerRightUp
                          radius:radius
                      startAngle:(M_PI * 3 / 2)
                        endAngle:(M_PI * 2)
                       clockwise:YES];

    [bezierPath addLineToPoint:vRightDownPoint];
    [bezierPath addArcWithCenter:centerRightDown
                          radius:radius
                      startAngle:0
                        endAngle:(M_PI / 2)
                       clockwise:YES];

    [bezierPath addLineToPoint:hLeftDownPoint];
    [bezierPath addArcWithCenter:centerLeftDown
                          radius:radius
                      startAngle:(M_PI / 2)
                        endAngle:(M_PI)
                       clockwise:YES];

    [bezierPath addLineToPoint:vLeftUpPoint];
    [bezierPath addArcWithCenter:centerLeftUp
                          radius:radius
                      startAngle:(M_PI)
                        endAngle:(M_PI * 3 / 2)
                       clockwise:YES];

    [bezierPath addLineToPoint:hLeftUpPoint];
    [bezierPath closePath];

    // If draw drection of outer path is same with inner path, final result is just outer path.
    [bezierPath moveToPoint:CGPointZero];
    [bezierPath addLineToPoint:CGPointMake(0, rectSize.height)];
    [bezierPath addLineToPoint:CGPointMake(rectSize.width, rectSize.height)];
    [bezierPath addLineToPoint:CGPointMake(rectSize.width, 0)];
    [bezierPath addLineToPoint:CGPointZero];
    [bezierPath closePath];

    [fillColor setFill];
    [bezierPath fill];

    CGContextDrawPath(currentContext, kCGPathFillStroke);
    UIImage *antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return antiRoundedCornerImage;
    
}
@end
