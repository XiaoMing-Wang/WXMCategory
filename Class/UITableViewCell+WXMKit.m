//
//  UITableViewCell+WXMKit.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/23.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "UITableViewCell+WXMKit.h"

@implementation UITableViewCell (WXMKit)

+ (NSString *)identifier {
    return NSStringFromClass(self);
}

+ (UINib *)nib {
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
}

@end
