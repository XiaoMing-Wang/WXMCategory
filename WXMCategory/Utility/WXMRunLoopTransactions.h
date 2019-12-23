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

/** runloop */
+ (void)delayRunSEL:(SEL)sel object:(id)object;


/** runloop */
+ (WXMRunLoopTransactions *)transactionsWithTarget:(id)target
                                          selector:(SEL)selector
                                            object:(id)object;
/** runloop */
- (void)commit;

@end

NS_ASSUME_NONNULL_END
