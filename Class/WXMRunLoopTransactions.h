//
//  WXMRunLoopTransactions.h
//  Multi-project-coordination
//
//  Created by wq on 2019/12/23.
//  Copyright © 2019 wxm. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WXMRunLoopTransactions : NSObject

/// 监听runloop调用
/// @param sel 行数
/// @param object object
+ (void)delayRunSEL:(SEL)sel object:(id)object;

@end

NS_ASSUME_NONNULL_END
