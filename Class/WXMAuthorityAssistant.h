//
//  WXMAuthorityAssistant.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/22.
//  Copyright © 2019 wxm. All rights reserved.
//
/** 判断用户权限 */
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMAuthorityAssistant : NSObject

/** 相机权限 */
+ (void)wp_photoAuthorityWithCallback:(void (^)(BOOL authorized))callback;

/** 相册权限 */
+ (void)wp_cameraAuthorityWithCallback:(void (^)(BOOL authorized))callback;

/** 麦克风权限 */
+ (void)wp_audioAuthorityWithCallback:(void (^)(BOOL authorized))callback;

/** 位置权限 */
+ (BOOL)wp_locationAuthority;

@end

NS_ASSUME_NONNULL_END
