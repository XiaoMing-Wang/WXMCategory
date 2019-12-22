//
//  UITableViewCell+WXMKit.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/23.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableViewCell (WXMKit)

/** 复用ID */
+ (NSString *)identifier;

+ (UINib *)nib;

@end

NS_ASSUME_NONNULL_END
