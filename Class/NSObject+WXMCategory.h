//
//  NSObject+DXPCategory.h
//  类库
//
//  Created by Mac on 16/8/26.
//  Copyright © 2016年 WQ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface NSObject (WXMCategory)

/** GCD定时器 */
- (void)wd_stopTiming;
- (dispatch_source_t)wd_startTimingInterval:(float)interval countdown:(BOOL(^)(void))countdown;
- (dispatch_source_t)wd_startTimingInterval:(float)interval
                                  addTarget:(id)target
                                     action:(SEL)action;

/** runtime替换方法 */
+ (BOOL)wd_swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;    /** 类方法 */
+ (BOOL)wd_swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel; /** 对象方法 */

/** runtime获取所有属性 */
+ (NSArray *)wd_getFropertys;

/** 绑定 */
- (void)wd_setAssociateValue:(nullable id)value withKey:(void *)key;
- (void)wd_setAssociateWeakValue:(nullable id)value withKey:(void *)key;

/** 获取 */
- (nullable id)wd_getAssociatedValueForKey:(void *)key;

/** kvo block*/
- (void)wd_addObserverBlockForKeyPath:(NSString *)keyPath block:(void (^)(id obj, id oldVal, id newVal))block;
- (void)wd_removeObserverBlocksForKeyPath:(NSString *)keyPath;
- (void)wd_removeObserverBlocks;

/** 解归档 需实现归档协议 */
- (BOOL)wd_archiverWithPath:(NSString *)path;
+ (instancetype)wd_unArchiverWithPath:(NSString *)path;

/** nib文件 */
+ (UINib *)wd_nib;

/** 深拷贝 */
- (instancetype)deepsCopy;
- (NSDictionary *)debugAllKeyValue;

@end
NS_ASSUME_NONNULL_END
