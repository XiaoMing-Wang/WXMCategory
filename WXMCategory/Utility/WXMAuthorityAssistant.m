//
//  WXMAuthorityAssistant.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/22.
//  Copyright © 2019 wxm. All rights reserved.
//
#import <Photos/Photos.h>
#import <CoreLocation/CoreLocation.h>
#import "WXMAuthorityAssistant.h"

@implementation WXMAuthorityAssistant

/** 相册权限 */
+ (BOOL)wp_photoAuthority {
    if (PHPhotoLibrary.authorizationStatus == AVAuthorizationStatusNotDetermined ||
        PHPhotoLibrary.authorizationStatus == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    
    NSString *message = @"请在系统设置中打开“允许访问照片”，否则将无法获取照片";
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self showAlertViewControllerWithTitle:@"提示"
                                   message:message
                                    cancel:@"取消"
                               otherAction:@[@"去开启"]
                             completeBlock:^(NSInteger index) {
        if (index)[[UIApplication sharedApplication] openURL:settingUrl];
    }];
    return NO;
}

/** 位置权限 */
+ (BOOL)wp_locationAuthority {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    if ((status == kCLAuthorizationStatusNotDetermined ||
        status == kCLAuthorizationStatusAuthorizedWhenInUse ||
        status == kCLAuthorizationStatusAuthorizedAlways) &&
        [CLLocationManager locationServicesEnabled]) {
        return YES;
    }
    
    NSString *message = @"请在系统设置中打开“允许访问位置信息”，否则将无法获取位置信息";
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self showAlertViewControllerWithTitle:@"提示"
                                   message:message
                                    cancel:@"取消"
                               otherAction:@[@"去开启"]
                             completeBlock:^(NSInteger index) {
        if (index)[[UIApplication sharedApplication] openURL:settingUrl];
    }];
    
    return NO;
}

/** 相机权限 */
+ (BOOL)wp_cameraAuthority {
    AVAuthorizationStatus status =
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (status == AVAuthorizationStatusAuthorized ||
        status == AVAuthorizationStatusNotDetermined) {
        return YES;
    }
    
    NSString *message = @"请在系统设置中打开“允许访问相机”，否则将无法使用相机功能";
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self showAlertViewControllerWithTitle:@"提示"
                                   message:message
                                    cancel:@"取消"
                               otherAction:@[@"去开启"]
                             completeBlock:^(NSInteger index) {
        if (index)[[UIApplication sharedApplication] openURL:settingUrl];
    }];
    
    return NO;
}

/** 麦克风权限 */
+ (BOOL)wp_audioAuthority {
    AVAuthorizationStatus status =
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    if (status == AVAuthorizationStatusNotDetermined ||
        status == AVAuthorizationStatusAuthorized) {
        return YES;
    }
    
    NSString *message = @"请在系统设置中打开“允许访问麦克风”，否则将无法使用麦克风功能";
    NSURL *settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [self showAlertViewControllerWithTitle:@"提示"
                                   message:message
                                    cancel:@"取消"
                               otherAction:@[@"去开启"]
                             completeBlock:^(NSInteger index) {
        if (index)[[UIApplication sharedApplication] openURL:settingUrl];
    }];
    
    return NO;
}

/** 警告框 AlertViewController */
+ (void)showAlertViewControllerWithTitle:(NSString *)title
                                 message:(NSString *)mes
                                  cancel:(NSString *)canStr
                             otherAction:(NSArray *)otherAction
                           completeBlock:(void (^)(NSInteger index))block {
    
    UIAlertController *alert = nil;
    alert = [UIAlertController alertControllerWithTitle:title message:mes preferredStyle:1];
    
    UIAlertAction *cancle = nil;
    cancle = [UIAlertAction actionWithTitle:canStr style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        if (block) block(0);
    }];
    [alert addAction:cancle];
    
    for (int i = 0; i < otherAction.count; i++) {
        NSString *title = otherAction[i];
        UIAlertAction *action = nil;
        action = [UIAlertAction actionWithTitle:title style:0 handler:^(UIAlertAction *act) {
            if (block) block(i + 1);
        }];
        [alert addAction:action];
    }
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *rootVC = window.rootViewController;
    if (rootVC.presentedViewController) rootVC = rootVC.presentedViewController;
    [rootVC presentViewController:alert animated:YES completion:nil];
}
@end