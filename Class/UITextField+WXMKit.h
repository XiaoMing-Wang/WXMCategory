//
//  UITextField+WXMKit.h
//  WXMComponentization
//
//  Created by wxm on 2020/1/19.
//  Copyright © 2020 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXMKitTextFieldDelegate <NSObject>
@optional
- (void)wc_textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)wc_textFieldShouldClear:(UITextField *)textField;
- (BOOL)wc_textFieldShouldReturn:(UITextField *)textField;
- (BOOL)wc_textFieldShouldEdit:(UITextField *)textField replacementString:(NSString *)string;
- (void)wc_textFieldValueChanged:(UITextField *)textField;
@end

/** UITextField输入不会走kvo */
@interface UITextField (WXMKit) <UITextFieldDelegate>

/** 限制最大个数 */
@property (nonatomic, assign) NSInteger maxCharacter;

/** 代理 */
@property (nonatomic, weak) id<WXMKitTextFieldDelegate> delegateKit;

/** block */
- (void)setTextFieldValueChangedCallback:(void (^)(NSString *_Nullable text))callback;

@end

NS_ASSUME_NONNULL_END
