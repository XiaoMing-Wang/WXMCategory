//
//  WXMRunLoopTransactions.m
//  Multi-project-coordination
//
//  Created by wq on 2019/12/23.
//  Copyright © 2019 wxm. All rights reserved.
//

#import "WXMRunLoopTransactions.h"

@interface WXMRunLoopTransactions ()
@property (nonatomic, strong) id target;
@property (nonatomic, strong) id object;
@property (nonatomic, assign) SEL selector;
@end

static NSMutableSet* transactionSet = nil;
static void RunLoopObserverCallBack(CFRunLoopObserverRef observer,
                                    CFRunLoopActivity activity,
                                    void *info) {
    if (transactionSet.count == 0) return;
    NSSet* currentSet = transactionSet;
    transactionSet = [[NSMutableSet alloc] init];
    [currentSet enumerateObjectsUsingBlock:^(WXMRunLoopTransactions* transactions, BOOL* stop) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [transactions.target performSelector:transactions.selector
                                  withObject:transactions.object];
#pragma clang diagnostic pop
    }];
}

static void RunLoopTransactionsSetup() {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transactionSet = [[NSMutableSet alloc] init];
        CFRunLoopRef runloop = CFRunLoopGetMain();
        CFRunLoopObserverRef observer;
        observer = CFRunLoopObserverCreate(CFAllocatorGetDefault(),
                                           kCFRunLoopBeforeWaiting | kCFRunLoopExit,
                                           true,
                                           0xFFFFFF,
                                           RunLoopObserverCallBack, NULL);
        CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
        CFRelease(observer);
    });
}

@implementation WXMRunLoopTransactions

+ (WXMRunLoopTransactions *)transactionsWithTarget:(id)target
                                          selector:(SEL)selector
                                            object:(id)object {
    if (!target || !selector) {
        return nil;
    }
    WXMRunLoopTransactions* transactions = [[WXMRunLoopTransactions alloc] init];
    transactions.target = target;
    transactions.selector = selector;
    transactions.object = object;
    return transactions;
}

- (void)commit {
    if (!_target || !_selector) {
        return;
    }
    RunLoopTransactionsSetup();
    [transactionSet addObject:self];
}

+ (void)delayRunSEL:(SEL)sel object:(id)object {
    WXMRunLoopTransactions* transactions = [WXMRunLoopTransactions
                                            transactionsWithTarget:self
                                            selector:sel
                                            object:object];
    [transactions commit];
}

@end
