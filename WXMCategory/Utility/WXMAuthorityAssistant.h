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
+ (BOOL)wp_cameraAuthority;

/** 相册权限 */
+ (BOOL)wp_photoAuthority;

/** 位置权限 */
+ (BOOL)wp_locationAuthority;

/** 麦克风权限 */
+ (BOOL)wp_audioAuthority;

@end

NS_ASSUME_NONNULL_END
