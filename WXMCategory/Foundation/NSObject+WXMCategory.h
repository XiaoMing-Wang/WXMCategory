//
//  NSObject+DXPCategory.h
//  类库
//
//  Created by Mac on 16/8/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN
@interface NSObject (WXMCategory)

/** GCD定时器 */
- (void)wc_stopTiming;
- (dispatch_source_t)wc_startTimingInterval:(float)interval countdown:(BOOL(^)(void))countdown;
- (dispatch_source_t)wc_startTimingInterval:(float)interval
                                   addTarget:(id)target
                                      action:(SEL)action;

/** runtime替换方法 */
+ (BOOL)wc_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;    /** 类方法 */
+ (BOOL)wc_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel; /** 对象方法 */

/** runtime获取所有属性 */
+ (NSArray *)wc_getFropertys;

/** 绑定 */
- (void)wc_setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)wc_setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/** 获取 */
- (nullable id)wc_getAssociatedValueForKey:(void *)key;

/** kvo block*/
- (void)wc_addObserverBlockForKeyPath:(NSString *)keyPath
                                block:(void (^)(id obj, id oldVal, id newVal))block;
- (void)wc_removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)wc_removeObserverBlocks;

/** 解归档 需实现归档协议 */
- (BOOL)wc_archiverWithPath:(NSString *)path;
+ (instancetype)wc_unArchiverWithPath:(NSString *)path;

/** nib文件 */
+ (UINib *)wc_nib;

/** 深拷贝 */
- (instancetype)deepsCopy;

@end
NS_ASSUME_NONNULL_END
