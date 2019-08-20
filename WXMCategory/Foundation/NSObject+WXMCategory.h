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
- (void)wxm_stopTiming;
- (dispatch_source_t)wxm_startTimingInterval:(float)interval countdown:(BOOL(^)(void))countdown;
- (dispatch_source_t)wxm_startTimingInterval:(float)interval
                                   addTarget:(id)target
                                      action:(SEL)action;

/** runtime替换方法 */
+ (BOOL)wxm_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;    /** 类方法 */
+ (BOOL)wxm_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel; /** 对象方法 */


/** runtime获取所有属性 */
+ (NSArray *)wxm_getFropertys;


/** 绑定 */
- (void)wxm_setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)wxm_setAssociateWeakValue:(nullable id)value withKey:(void *)key;


/** 获取 */
- (nullable id)wxm_getAssociatedValueForKey:(void *)key;


/** kvo block*/
- (void)wxm_addObserverBlockForKeyPath:(NSString *)keyPath
                                 block:(void (^)(id obj, id oldVal, id newVal))block;
- (void)wxm_removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)wxm_removeObserverBlocks;


/** 解归档 需实现归档协议 */
- (BOOL)archiverWithPath:(NSString *)path;
+ (instancetype)unArchiverWithPath:(NSString *)path;

+ (UINib *)nib;
@end
NS_ASSUME_NONNULL_END
