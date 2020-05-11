//
//  UITextField+WXMKit.m
//  WXMComponentization
//
//  Created by wxm on 2020/1/19.
//  Copyright © 2020 wxm. All rights reserved.
//
#import <objc/runtime.h>
#import "UITextField+WXMKit.h"

@implementation UITextField (WXMKit)

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([self.delegateKit respondsToSelector:@selector(wc_textFieldDidBeginEditing:)]) {
        [self.delegateKit wc_textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.delegateKit respondsToSelector:@selector(wc_textFieldShouldClear:)]) {
        return [self.delegateKit wc_textFieldShouldClear:textField];
    }

    if ([self.delegateKit respondsToSelector:@selector(wc_textFieldValueChanged:)]) {
        [self.delegateKit wc_textFieldValueChanged:textField];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.delegateKit respondsToSelector:@selector(wc_textFieldShouldReturn:)]) {
        return [self.delegateKit wc_textFieldShouldReturn:textField];
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ([string isEqualToString:@""]) return YES;
    if ([self.delegateKit respondsToSelector:@selector(wc_textFieldShouldEdit:replacementString:)]) {
        return [self.delegateKit wc_textFieldShouldEdit:textField replacementString:string];
    }
    
    if (self.maxCharacter == 0) return YES;
    if (textField.text.length >= self.maxCharacter) return NO;
    return YES;
}

- (void)textFieldValueChanged:(UITextField *)textField {
    [self willChangeValueForKey:@"text"];
    [self didChangeValueForKey:@"text"];
    if (self.callback) self.callback(textField.text);
    if ([self.delegateKit respondsToSelector:@selector(wc_textFieldValueChanged:)]) {
        [self.delegateKit wc_textFieldValueChanged:textField];
    }
    
    /** textField设置不会触发kvo */
    if (self.maxCharacter > 0 && textField.text.length > self.maxCharacter) {
        textField.text = [textField.text substringToIndex:self.maxCharacter];
    }
}

- (void)setDelegateKit:(id<WXMKitTextFieldDelegate>)delegateKit {
    self.delegate = self;
    [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    objc_setAssociatedObject(self, @selector(delegateKit), delegateKit, OBJC_ASSOCIATION_ASSIGN);
}

/** block */
- (void)setTextFieldValueChangedCallback:(void (^)(NSString *text))callback {
    [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    objc_setAssociatedObject(self, @selector(callback), callback, OBJC_ASSOCIATION_COPY);
}

- (void (^)(NSString *text))callback {
    return objc_getAssociatedObject(self, _cmd);
}

- (id<WXMKitTextFieldDelegate>)delegateKit {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMaxCharacter:(NSInteger)maxCharacter {
    [self addTarget:self action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventAllEditingEvents];
    objc_setAssociatedObject(self, @selector(maxCharacter), @(maxCharacter), OBJC_ASSOCIATION_COPY);
}

- (NSInteger)maxCharacter {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

@end
