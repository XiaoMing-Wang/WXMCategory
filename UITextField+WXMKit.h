//
//  UITextField+WXMKit.h
//  WXMComponentization
//
//  Created by sdjim on 2020/1/19.
//  Copyright © 2020 sdjim. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WXMKitTextFieldDelegate <NSObject>
@optional
- (void)wc_textFieldDidBeginEditing:(UITextField *)textField;
- (BOOL)wc_textFieldShouldClear:(UITextField *)textField;
- (BOOL)wc_textFieldShouldReturn:(UITextField *)textField;
- (void)wc_textFieldValueChanged:(UITextField *)textField;

- (void)wc_textViewDidBeginEditing:(UITextView *)textView;
- (BOOL)wc_textViewShouldReturn:(UITextView *)textView;
- (void)wc_textViewValueChanged:(UITextView *)textView;
@end

/** UITextField输入不会走kvo */
@interface UITextField (WXMKit) <UITextFieldDelegate>

/** 当前显示 kvo */
@property (nonatomic, copy) NSString *currentText;

/** 限制最大个数 */
@property (nonatomic, assign) NSInteger maxCharacter;

/** 代理 */
@property (nonatomic, weak) id<WXMKitTextFieldDelegate> delegateKit;

/** block */
- (void)setTextFieldValueChangedCallback:(void (^)(NSString *_Nullable text))callback;

@end

NS_ASSUME_NONNULL_END
